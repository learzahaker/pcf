from . import routes
from functools import wraps
from forms import *
import time
import email_validator
from system.crypto_functions import gen_uuid
from system.security_functions import run_function_timeout
from os import path, remove, rename, stat, makedirs, walk
from flask import Response, jsonify
import magic
import shutil
import calendar
import json, zipfile
from jinja2.sandbox import SandboxedEnvironment, Environment

from app import check_session, db, session, render_template, redirect, request, \
    config, send_log_data, requires_authorization


def check_project_access(fn):
    @wraps(fn)
    def decorated_view(*args, **kwargs):
        project_id = kwargs['project_id']
        current_project = db.check_user_project_access(str(project_id),
                                                       session['id'])
        if not current_project:
            return redirect('/projects/')
        kwargs['current_project'] = current_project
        return fn(*args, **kwargs)

    return decorated_view


def check_chat_access(fn):
    @wraps(fn)
    def decorated_view(*args, **kwargs):
        current_project = kwargs['current_project']
        chat_id = kwargs['chat_id']
        current_chat = db.select_project_chat(current_project['id'],
                                              str(chat_id))
        if not current_chat:
            return redirect('/projects/')
        kwargs['current_chat'] = current_chat[0]
        return fn(*args, **kwargs)

    return decorated_view


def check_project_archived(fn):
    @wraps(fn)
    def decorated_view(*args, **kwargs):
        current_project = kwargs['current_project']

        if current_project['status'] == 0 or (current_project[
                                                  'end_date'] < time.time() and
                                              current_project[
                                                  'auto_archive'] == 1):
            if current_project['status'] == 1:
                db.update_project_status(current_project['id'], 0)
            return redirect('/projects/')
        return fn(*args, **kwargs)

    return decorated_view


def check_project_issue(fn):
    @wraps(fn)
    def decorated_view(*args, **kwargs):
        current_project = kwargs['current_project']
        issue_id = str(kwargs['issue_id'])
        current_issue = db.select_issue(str(issue_id))
        if not current_issue:
            return redirect(
                '/project/{}/issues/'.format(current_project['id']))
        current_issue = current_issue[0]
        if current_issue['project_id'] != current_project['id']:
            return redirect(
                '/project/{}/issues/'.format(current_project['id']))
        kwargs['current_issue'] = current_issue
        return fn(*args, **kwargs)

    return decorated_view


def check_project_creds(fn):
    @wraps(fn)
    def decorated_view(*args, **kwargs):
        current_project = kwargs['current_project']
        creds_id = str(kwargs['creds_id'])
        current_creds = db.select_creds(str(creds_id))
        if not current_creds:
            return redirect(
                '/project/{}/credentials/'.format(current_project['id']))
        current_creds = current_creds[0]
        if current_creds['project_id'] != current_project['id']:
            return redirect(
                '/project/{}/credentials/'.format(current_project['id']))
        kwargs['current_creds'] = current_creds
        return fn(*args, **kwargs)

    return decorated_view


def check_project_file_access(fn):
    @wraps(fn)
    def decorated_view(*args, **kwargs):
        project_id = str(kwargs['project_id'])
        file_id = str(kwargs['file_id'])
        current_file = db.select_files(file_id)
        if not current_file:
            return redirect('/project/{}/files/'.format(project_id))
        current_file = current_file[0]
        if current_file['project_id'] != project_id:
            return redirect('/project/')
        kwargs['current_file'] = current_file
        return fn(*args, **kwargs)

    return decorated_view


@routes.route('/project/<uuid:project_id>/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_index(project_id, current_project, current_user):
    return render_template('project-pages/stats/statslist.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/hosts/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def hosts(project_id, current_project, current_user):
    return render_template('project-pages/ip-list/projectiplist.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/hosts/new_host', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def new_host(project_id, current_project, current_user):
    return render_template('project-pages/ip-list/projectnewhost.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/hosts/new_host', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def new_host_form(project_id, current_project, current_user):
    form = NewHost()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            errors += form.errors[field]
    if not errors and db.select_ip_from_project(
            project_id=current_project['id'], ip=form.ip.data):
        errors.append('IP already in project!')

    if errors:
        return render_template('project-pages/ip-list/projectnewhost.html',
                               current_project=current_project,
                               errors=errors)
    ip_id = db.insert_host(current_project['id'],
                           form.ip.data,
                           session['id'],
                           current_project,
                           form.description.data)

    return redirect('/project/{}/hosts/'.format(current_project['id']))


@routes.route('/project/<uuid:project_id>/host/<uuid:host_id>/',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def host_page(project_id, host_id, current_project, current_user):
    current_host = db.select_project_host(current_project['id'], str(host_id))
    if not current_host:
        return redirect('/project/{}/hosts/'.format(current_project['id']))
    current_host = current_host[0]
    return render_template('project-pages/ip-list/projectippage.html',
                           current_project=current_project,
                           current_host=current_host)


@routes.route('/project/<uuid:project_id>/host/<uuid:host_id>/',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def host_page_form(project_id, host_id, current_project, current_user):
    current_host = db.select_project_host(current_project['id'], str(host_id))
    if not current_host:
        return redirect('/project/{}/hosts/'.format(current_project['id']))
    current_host = current_host[0]

    if 'delete_host_issue' in request.form:
        form = DeleteHostIssue()
        form.validate()
        errors = []
        if form.errors:
            for field in form.errors:
                errors += form.errors[field]
        if not errors:
            current_issue = db.select_issue(form.issue_id.data)
            if not current_issue:
                errors.append('Issue not found!')
            elif current_issue[0]['project_id'] != current_project['id']:
                errors.append('Issue is in another project!')
            else:
                db.delete_issue_host(current_issue[0]['id'], current_host['id'])

    if 'delete_port' in request.form:
        form = DeletePort()
        form.validate()
        errors = []
        if form.errors:
            for field in form.errors:
                errors += form.errors[field]
        if not errors:
            current_port = db.select_port(form.port_id.data)
            if not current_port:
                errors.append('Port not found!')
            elif current_port[0]['host_id'] != current_host['id']:
                errors.append('Port is in another host!')
            else:
                db.delete_port_safe(current_port[0]['id'])

    if 'update_description' in request.form:
        if 'Submit' in request.form and request.form['Submit'] == 'Delete':
            ports = db.select_host_ports(current_host['id'], full=True)
            for current_port in ports:
                db.delete_port_safe(current_port['id'])
            db.delete_host(current_host['id'])
            return redirect('/project/{}/hosts/'.format(current_project['id']))

        form = UpdateHostDescription()
        form.validate()
        errors = []
        if form.errors:
            for field in form.errors:
                errors += form.errors[field]

        if not errors:
            db.update_host_comment_threats(current_host['id'],
                                           form.comment.data,
                                           form.threats.data)
            current_host = \
                db.select_project_host(current_project['id'], str(host_id))[0]

        return render_template('project-pages/ip-list/projectippage.html',
                               current_project=current_project,
                               current_host=current_host,
                               edit_description_errors=errors)

    if 'add_port' in request.form:
        form = AddPort()
        form.validate()
        errors = []
        if form.errors:
            for field in form.errors:
                errors += form.errors[field]

        # check port number
        port_type = 'tcp'  # 1 - tcp, 2 - udp
        if form.port.data.endswith('/udp'):
            port_type = 'udp'
        try:
            port_num = int(form.port.data.replace('/' + port_type, ''))
            if (port_num < 1) or (port_num > 65535):
                errors.append('UDP port number invalid {1..65535}')
        except ValueError:
            errors.append('Port number invalid format')

        if not errors:
            ports = db.select_host_ports(current_host['id'])
            service = form.service_text.data if form.service_text.data else form.service.data
            found = {}
            for port in ports:
                if int(port['port']) == port_num and port['is_tcp'] == (
                        port_type == 'tcp'):
                    found = port
            if not found:
                db.insert_host_port(current_host['id'],
                                    port_num,
                                    port_type == 'tcp',
                                    service,
                                    form.description.data,
                                    session['id'],
                                    current_project['id'])
            else:
                db.update_port_proto_description(found['id'],
                                                 service,
                                                 form.description.data)

        return render_template('project-pages/ip-list/projectippage.html',
                               current_project=current_project,
                               current_host=current_host,
                               add_port_errors=errors)

    if 'add_hostname' in request.form:
        form = AddHostname()
        form.validate()
        errors = []
        if form.errors:
            for field in form.errors:
                errors += form.errors[field]

        # validate hostname
        if not errors:
            try:
                email_validator.validate_email('@' + form.hostname.data,
                                               allow_empty_local=True,
                                               check_deliverability=False)
            except email_validator.EmailNotValidError:
                errors.append('Hostname not valid!')

        if not errors:
            hostnames = db.find_ip_hostname(current_host['id'],
                                            form.hostname.data)
            if hostnames:
                db.update_hostname(hostnames[0]['id'], form.comment.data)
            else:
                hostname_id = db.insert_hostname(current_host['id'],
                                                 form.hostname.data,
                                                 form.comment.data,
                                                 session['id'])

        return render_template('project-pages/ip-list/projectippage.html',
                               current_project=current_project,
                               current_host=current_host,
                               add_hostname_errors=errors)

    if 'delete_hostname' in request.form:
        form = DeleteHostname()
        form.validate()
        errors = []
        if form.errors:
            for field in form.errors:
                errors += form.errors[field]

        if not errors:
            found = db.check_host_hostname_id(current_host['id'],
                                              form.hostname_id.data)
            if not found:
                errors.append('Hostname ID in this host not found!')

        if not errors:
            db.delete_hostname_safe(form.hostname_id.data)

        return render_template('project-pages/ip-list/projectippage.html',
                               current_project=current_project,
                               current_host=current_host,
                               delete_hostname_errors=errors)

    return render_template('project-pages/ip-list/projectippage.html',
                           current_project=current_project,
                           current_host=current_host)


@routes.route('/project/<uuid:project_id>/new_issue', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def new_issue(project_id, current_project, current_user):
    return render_template('project-pages/issues/newissue.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/new_issue', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def new_issue_form(project_id, current_project, current_user):
    form = NewIssue()
    form.validate()
    errors = []

    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    services = {}

    # check port_id variable
    if not errors:
        for port_id in form.ip_port.data:
            if not db.check_port_in_project(current_project['id'], port_id):
                errors.append('Some ports are not in project!')
            else:
                if port_id in services:
                    if "0" not in services[port_id]:
                        services[port_id].append("0")
                else:
                    services[port_id] = ["0"]

    # check host_id variable
    if not errors:
        for host_port in form.host_port.data:
            port_id = host_port.split(':')[0]
            hostname_id = host_port.split(':')[1]
            port_data = db.select_port(port_id)
            hostname_data = db.select_hostname(hostname_id)
            if not port_data or not hostname_data:
                errors.append('Hostname not found error!')
            else:
                if port_data[0]['host_id'] != hostname_data[0]['host_id']:
                    errors.append('Some ports are not with these hostnames.')
                else:
                    if port_id not in services:
                        services[port_id] = [hostname_id]
                    else:
                        if hostname_id not in services[port_id]:
                            services[port_id].append(hostname_id)
    cvss = form.cvss.data
    criticality = form.criticality.data
    if criticality >= 0 and criticality <= 10:
        cvss = criticality

    if not errors:
        issue_id = db.insert_new_issue(form.name.data, form.description.data,
                                       form.url.data,
                                       cvss, session['id'], services,
                                       form.status.data, current_project['id'],
                                       form.cve.data,
                                       issue_type=form.issue_type.data,
                                       fix=form.fix.data,
                                       param=form.param.data)
        return redirect(
            '/project/{}/issue/{}/'.format(current_project['id'], issue_id))

    return render_template('project-pages/issues/newissue.html',
                           current_project=current_project,
                           errors=errors)


@routes.route('/project/<uuid:project_id>/issues/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def issues_list(project_id, current_project, current_user):
    return render_template('project-pages/issues/issueslist.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/issue/<uuid:issue_id>/',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_issue
@send_log_data
def issues_info(project_id, issue_id, current_project, current_user,
                current_issue):
    current_issue = db.select_issue(str(issue_id))[0]
    if current_issue['project_id'] != current_project['id']:
        return redirect('/project/{}/issues/'.format(current_project['id']))

    return render_template('project-pages/issues/issueinfo.html',
                           current_project=current_project,
                           current_issue=current_issue)


@routes.route('/project/<uuid:project_id>/issue/<uuid:issue_id>/',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@check_project_issue
@send_log_data
def issues_info_form(project_id, issue_id, current_project, current_user,
                     current_issue):
    form = UpdateIssue()

    form.validate()
    errors = []

    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    services = {}

    # check port_id variable
    if not errors:
        for port_id in form.ip_port.data:
            if not db.check_port_in_project(current_project['id'], port_id):
                errors.append('Some ports are not in project!')
            else:
                if port_id in services:
                    if "0" not in services[port_id]:
                        services[port_id].append("0")
                else:
                    services[port_id] = ["0"]

    # check host_id variable
    if not errors:
        for host_port in form.host_port.data:
            port_id = host_port.split(':')[0]
            hostname_id = host_port.split(':')[1]
            port_data = db.select_port(port_id)
            hostname_data = db.select_hostname(hostname_id)
            if not port_data or not hostname_data:
                errors.append('Hostname not found error!')
            else:
                if port_data[0]['host_id'] != hostname_data[0]['host_id']:
                    errors.append('Some ports are not with these hostnames.')
                else:
                    if port_id not in services:
                        services[port_id] = [hostname_id]
                    else:
                        if hostname_id not in services[port_id]:
                            services[port_id].append(hostname_id)

    cvss = form.cvss.data
    criticality = form.criticality.data
    if criticality >= 0 and criticality <= 10:
        cvss = criticality

    if not errors:
        db.update_issue(current_issue['id'], form.name.data,
                        form.description.data, form.url.data,
                        cvss, services, form.status.data,
                        form.cve.data, form.cwe.data,
                        issue_type=form.issue_type.data,
                        fix=form.fix.data,
                        param=form.param.data)

    current_issue = db.select_issue(str(issue_id))[0]

    return render_template('project-pages/issues/issueinfo.html',
                           current_project=current_project,
                           current_issue=current_issue,
                           update_info_errors=errors)


@routes.route('/project/<uuid:project_id>/issue/<uuid:issue_id>/delete_issue',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@check_project_issue
@send_log_data
def delete_issue_form(project_id, issue_id, current_project, current_user,
                      current_issue):
    db.delete_issue(current_issue['id'])
    return redirect('/project/{}/issues/'.format(current_project['id']))


@routes.route('/project/<uuid:project_id>/issue/<uuid:issue_id>/new_poc',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@check_project_issue
@send_log_data
def new_poc_form(project_id, issue_id, current_project, current_user,
                 current_issue):
    form = NewPOC()

    form.validate()
    errors = []

    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        port_id = form.service.data.split(':')[0]
        hostname_id = form.service.data.split(':')[1]
        if not (port_id == '0' and hostname_id == '0'):
            # check if port-host in issue
            if not db.check_hostname_port_in_issue(hostname_id, port_id,
                                                   current_issue['id']):
                errors.append('Hostname-port id pair is not in this issue!')

    # save template file
    if not errors:
        file_type = 'image'
        file = request.files.get('file')
        poc_id = gen_uuid()
        tmp_file_path = path.join(config['main']['tmp_path'], poc_id)
        file.save(tmp_file_path)
        file.close()
        file_size = stat(tmp_file_path).st_size
        if file_size > int(config['files']['poc_max_size']):
            errors.append("File too large!")
            remove(tmp_file_path)

    if not errors:
        # check file type
        magic_obj = magic.Magic(magic.MAGIC_NONE)
        magic_type = magic_obj.from_file(tmp_file_path).lower()
        print(magic_type)
        if 'text' in magic_type.lower():
            file_type = 'text'
        elif 'image' in magic_type.lower():
            file_type = 'image'
        else:
            errors.append('Unknown file format {}'.format(file_type))
            remove(tmp_file_path)
            return render_template('project-pages/issues/issueinfo.html',
                                   current_project=current_project,
                                   current_issue=current_issue,
                                   add_poc_error=errors)
        # move file to new dir
        new_file_path = path.join('./static/files/poc/', poc_id)
        rename(tmp_file_path, new_file_path)
        db.insert_new_poc(port_id,
                          form.comment.data,
                          file_type,
                          file.filename,
                          current_issue['id'],
                          current_user['id'],
                          hostname_id,
                          poc_id)
        return redirect('/project/{}/issue/{}/'.format(current_project['id'],
                                                       current_issue['id']))

    return render_template('project-pages/issues/issueinfo.html',
                           current_project=current_project,
                           current_issue=current_issue,
                           poc_errors=errors)


@routes.route('/project/<uuid:project_id>/issue/<uuid:issue_id>/delete_poc',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@check_project_issue
@send_log_data
def delete_poc_form(project_id, issue_id, current_project, current_user,
                    current_issue):
    form = DeletePOC()

    form.validate()
    errors = []

    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        current_poc = db.select_poc(form.poc_id.data)
        if not current_poc:
            errors.append('Poc-ID does not exist!')
        elif current_poc[0]['issue_id'] != current_issue['id']:
            errors.append('PoC is not in this issue!')
        else:
            current_poc = current_poc[0]
            db.delete_poc(current_poc['id'])
            return redirect(
                '/project/{}/issue/{}/'.format(current_project['id'],
                                               current_issue['id']))

    return render_template('project-pages/issues/issueinfo.html',
                           current_project=current_project,
                           current_issue=current_issue,
                           poc_errors=errors)


@routes.route('/project/<uuid:project_id>/networks/',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def networks(project_id, current_project, current_user):
    return render_template('project-pages/networks/projectnetworks.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/networks/new_network',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def new_network(project_id, current_project, current_user):
    return render_template('project-pages/networks/projectnewnetwork.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/networks/new_network',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def new_network_form(project_id, current_project, current_user):
    form = NewNetwork()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    is_ipv6 = False

    if not errors:
        is_ipv6 = ':' in form.ip.data

    if form.mask.data > 32 and not is_ipv6:
        errors.append('Mask too large for ipv4')
    else:
        network_id = db.insert_new_network(form.ip.data, form.mask.data,
                                           form.asn.data, form.comment.data,
                                           current_project['id'],
                                           current_user['id'], is_ipv6)
        return redirect('/project/{}/networks/'.format(current_project['id']))

    return render_template('project-pages/networks/projectnewnetwork.html',
                           current_project=current_project,
                           errors=errors)


@routes.route('/project/<uuid:project_id>/networks/delete_network',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def delete_network_form(project_id, current_project, current_user):
    form = DeleteNetwork()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        current_network = db.select_network(form.network_id.data)

        if not current_network or \
                current_network[0]['project_id'] != current_project['id']:
            errors.append('Network not found!')
        else:
            db.delete_network(form.network_id.data)

    return redirect('/project/{}/networks/'.format(current_project['id']))


@routes.route('/project/<uuid:project_id>/credentials/',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_credentials(project_id, current_project, current_user):
    return render_template('project-pages/users/userslist.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/credentials/new_creds',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def project_add_credentials(project_id, current_project, current_user):
    return render_template('project-pages/users/newuser.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/credentials/new_creds',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def project_add_credentials_form(project_id, current_project, current_user):
    form = NewCredentials()

    form.validate()
    errors = []

    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    services = {}

    # check port_id variable
    if not errors:
        for port_id in form.ip_port.data:
            if not db.check_port_in_project(current_project['id'], port_id):
                errors.append('Some ports are not in project!')
            else:
                if port_id in services:
                    if "0" not in services[port_id]:
                        services[port_id].append("0")
                else:
                    services[port_id] = ["0"]

    # check host_id variable
    if not errors:
        for host_port in form.host_port.data:
            port_id = host_port.split(':')[0]
            hostname_id = host_port.split(':')[1]
            port_data = db.select_port(port_id)
            hostname_data = db.select_hostname(hostname_id)
            if not port_data or not hostname_data:
                errors.append('Hostname not found error!')
            else:
                if port_data[0]['host_id'] != hostname_data[0]['host_id']:
                    errors.append('Some ports are not with these hostnames.')
                else:
                    if port_id not in services:
                        services[port_id] = [hostname_id]
                    else:
                        if hostname_id not in services[port_id]:
                            services[port_id].append(hostname_id)

    if not errors:
        creds_id = db.insert_new_cred(form.login.data, form.password_hash.data,
                                      form.hash_type.data,
                                      form.cleartext_password.data,
                                      form.comment.data,
                                      form.info_source.data,
                                      services,
                                      current_user['id'], current_project['id'])
        return redirect(
            '/project/{}/credentials/{}/'.format(current_project['id'],
                                                 creds_id))

    return render_template('project-pages/users/newuser.html',
                           current_project=current_project,
                           errors=errors)


@routes.route('/project/<uuid:project_id>/credentials/<uuid:creds_id>/',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_creds
@send_log_data
def project_credentials_info(project_id, current_project, current_user,
                             creds_id, current_creds):
    return render_template('project-pages/users/userinfo.html',
                           current_project=current_project,
                           current_creds=current_creds)


@routes.route('/project/<uuid:project_id>/credentials/<uuid:creds_id>/',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@check_project_creds
@send_log_data
def project_credentials_info_form(project_id, current_project, current_user,
                                  creds_id, current_creds):
    form = UpdateCredentials()

    form.validate()
    errors = []

    if form.action.data == 'delete':
        db.delete_creds(current_creds['id'])
        return redirect(
            '/project/{}/credentials/'.format(current_project['id']))

    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    services = {}

    # check port_id variable
    if not errors:
        for port_id in form.ip_port.data:
            if not db.check_port_in_project(current_project['id'], port_id):
                errors.append('Some ports are not in project!')
            else:
                if port_id in services:
                    if "0" not in services[port_id]:
                        services[port_id].append("0")
                else:
                    services[port_id] = ["0"]

    # check host_id variable
    if not errors:
        for host_port in form.host_port.data:
            port_id = host_port.split(':')[0]
            hostname_id = host_port.split(':')[1]
            port_data = db.select_port(port_id)
            hostname_data = db.select_hostname(hostname_id)
            if not port_data or not hostname_data:
                errors.append('Hostname not found error!')
            else:
                if port_data[0]['host_id'] != hostname_data[0]['host_id']:
                    errors.append('Some ports are not with these hostnames.')
                else:
                    if port_id not in services:
                        services[port_id] = [hostname_id]
                    else:
                        if hostname_id not in services[port_id]:
                            services[port_id].append(hostname_id)

    if not errors:
        creds_id = db.update_creds(current_creds['id'],
                                   form.login.data,
                                   form.password_hash.data,
                                   form.hash_type.data,
                                   form.cleartext_password.data,
                                   form.comment.data,
                                   form.info_source.data,
                                   services)

    current_creds = db.select_creds(current_creds['id'])[0]
    return render_template('project-pages/users/userinfo.html',
                           current_project=current_project,
                           current_creds=current_creds,
                           errors=errors)


@routes.route('/project/<uuid:project_id>/credentials/export',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_credentials_export(project_id, current_project, current_user):
    form = ExportCredsForm()
    form.validate()

    if not form.errors:
        creds_array = db.select_project_creds(current_project['id'])
        result = []

        users_arr = list(
            set([current_creds['login'] for current_creds in creds_array]))
        passwords_arr = list(
            set([current_creds['cleartext'] for current_creds in creds_array]))

        if not form.empty_passwords.data and '' in passwords_arr:
            del passwords_arr[passwords_arr.index('')]

        if form.login_as_password.data:
            passwords_arr += users_arr
            passwords_arr = list(set(passwords_arr))

        if form.export_type.data == 'passwords':
            result = passwords_arr
        elif form.export_type.data == 'user_pass':
            for current_creds in creds_array:
                if form.empty_passwords.data or \
                        (not form.empty_passwords.data
                         and '' != current_creds['cleartext']):
                    result.append('{}{}{}'.format(current_creds['login'],
                                                  form.separator.data,
                                                  current_creds['cleartext']))
        elif form.export_type.data == 'user_pass_variations':
            for user in users_arr:
                for password in passwords_arr:
                    result.append('{}{}{}'.format(user,
                                                  form.separator.data,
                                                  password))
        return Response('\n'.join(result),
                        mimetype="text/plain",
                        headers={
                            "Content-disposition": "attachment; filename=passwords.txt"})
    return redirect(
        '/project/{}/credentials/'.format(current_project['id']))


@routes.route('/project/<uuid:project_id>/notes/',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_notes(project_id, current_project, current_user):
    return render_template('project-pages/notes/notes-list.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/notes/add',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def new_note_form(project_id, current_project, current_user):
    form = NewNote()

    form.validate()
    errors = []

    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        note_id = db.insert_new_note(current_project['id'], form.name.data,
                                     current_user['id'])

    return redirect('/project/{}/notes/'.format(current_project['id']))


@routes.route('/project/<uuid:project_id>/notes/edit',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def edit_note_form(project_id, current_project, current_user):
    form = EditNote()

    form.validate()
    errors = []

    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        if form.action.data == 'Update':
            db.update_note(form.note_id.data, form.text.data,
                           current_project['id'])
        elif form.action.data == 'Delete':
            db.delete_note(form.note_id.data, current_project['id'])

    return redirect('/project/{}/notes/'.format(current_project['id']))


@routes.route('/project/<uuid:project_id>/files/',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_files(project_id, current_project, current_user):
    return render_template('project-pages/code/fileslist.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/files/new',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def project_new_file_form(project_id, current_project, current_user):
    form = NewFile()
    form.validate()

    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    # check port_id variable
    services = {}
    if not errors:
        for port_id in form.ip_port.data:
            if not db.check_port_in_project(current_project['id'], port_id):
                errors.append('Some ports are not in project!')
            else:
                if port_id in services:
                    if "0" not in services[port_id]:
                        services[port_id].append("0")
                else:
                    services[port_id] = ["0"]

    # check host_id variable
    if not errors:
        for host_port in form.host_port.data:
            port_id = host_port.split(':')[0]
            hostname_id = host_port.split(':')[1]
            port_data = db.select_port(port_id)
            hostname_data = db.select_hostname(hostname_id)
            if not port_data or not hostname_data:
                errors.append('Hostname not found error!')
            else:
                if port_data[0]['host_id'] != hostname_data[0]['host_id']:
                    errors.append(
                        'Some ports are not with these hostnames.')
                else:
                    if port_id not in services:
                        services[port_id] = [hostname_id]
                    else:
                        if hostname_id not in services[port_id]:
                            services[port_id].append(hostname_id)

    if not errors:
        file = request.files.get('file')
        file_id = gen_uuid()
        tmp_file_path = path.join(config['main']['tmp_path'], file_id)
        file.save(tmp_file_path)
        file.close()
        file_size = stat(tmp_file_path).st_size
        if file_size > int(config['files']['files_max_size']):
            remove(tmp_file_path)
            errors.append('File too large!')
        else:
            new_file_path = path.join('./static/files/code/', file_id)
            rename(tmp_file_path, new_file_path)
            db.insert_new_file(file_id, current_project['id'], file.filename,
                               form.description.data,
                               services, form.filetype.data, current_user['id'])
            return redirect('/project/{}/files/'.format(current_project['id']))

    return render_template('project-pages/code/fileslist.html',
                           current_project=current_project,
                           errors=errors)


@routes.route('/project/<uuid:project_id>/files/<uuid:file_id>/',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_file_access
@send_log_data
def project_file_info(project_id, current_project, current_user, file_id,
                      current_file):
    return render_template('project-pages/code/codeviewer.html',
                           current_project=current_project,
                           current_file=current_file)


@routes.route('/project/<uuid:project_id>/files/<uuid:file_id>/',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@check_project_file_access
@send_log_data
def project_file_edit(project_id, current_project, current_user, file_id,
                      current_file):
    form = EditFile()

    form.validate()

    errors = []

    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if form.action.data == 'delete':
        file_path = path.join('./static/files/code/', current_file['id'])
        remove(file_path)
        db.delete_file(current_file['id'])
        return redirect('/project/{}/files/'.format(current_project['id']))

    return render_template('project-pages/code/codeviewer.html',
                           current_project=current_project,
                           current_file=current_file)


@routes.route('/project/<uuid:project_id>/settings/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_settings(project_id, current_project, current_user):
    return render_template('project-pages/settings/projectsettings.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/settings/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_settings_form(project_id, current_project, current_user):
    # team access check
    form = EditProjectSettings()
    form.validate()

    if form.action.data == 'Archive':
        db.update_project_status(current_project['id'], 0)
        return redirect(request.referrer)
    if form.action.data == 'Activate':
        db.update_project_status(current_project['id'], 1)
        db.update_project_autoarchive(current_project['id'], 0)
        return redirect(request.referrer)
    # else 'Update'

    errors = []
    if form.errors:
        for field in form.errors:
            for err in form.errors[field]:
                errors.append(err)

    # check teams access
    if not errors:

        for team_id in form.teams.data:
            current_team = db.select_team_by_id(team_id)
            if not current_team:
                errors.append('Team {} does not exist!'.format(team_id))
            elif session['id'] not in current_team[0]['users']:
                errors.append(
                    'User does not have access to team {}!'.format(team_id))

    # check user relationship

    form_users = [user for user in form.users.data if user]
    teams_array = db.select_user_teams(session['id'])
    if not errors:
        for user_id in form_users:
            found = 0
            for team in teams_array:
                if user_id in team['users']:
                    found = 1
            if not found or not db.select_user_by_id(user_id):
                errors.append('User {} not found!'.format(user_id))

    if not errors:
        # creating project
        start_time = calendar.timegm(form.start_date.data.timetuple())
        end_time = calendar.timegm(form.end_date.data.timetuple())

        if current_user['id'] not in form_users:
            form_users.append(current_user['id'])

        project_id = db.update_project_settings(current_project['id'],
                                                form.name.data,
                                                form.description.data,
                                                form.project_type.data,
                                                form.scope.data,
                                                start_time,
                                                end_time,
                                                form.archive.data,
                                                form_users,
                                                form.teams.data)
    current_project = db.check_user_project_access(current_project['id'],
                                                   session['id'])
    return render_template('project-pages/settings/projectsettings.html',
                           current_project=current_project,
                           errors=errors)


@routes.route('/project/<uuid:project_id>/services/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_services(project_id, current_project, current_user):
    return render_template('project-pages/services/projectservicelist.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/services/new_service',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def project_new_services(project_id, current_project, current_user):
    return render_template('project-pages/services/projectnewservice.html',
                           current_project=current_project)


@routes.route('/project/<uuid:project_id>/services/new_service',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def project_new_services_form(project_id, current_project, current_user):
    form = MultiplePortHosts()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            errors += form.errors[field]

    port_type = 'tcp'
    if form.port.data.endswith('/udp'):
        port_type = 'udp'
    is_tcp = port_type == 'tcp'
    try:
        port_num = int(form.port.data.replace('/' + port_type, ''))
        if (port_num < 1) or (port_num > 65535):
            errors.append('UDP port number invalid {1..65535}')
    except ValueError:
        errors.append('Port number invalid format')
    if not errors:
        for host_id in form.host.data:
            current_host = db.select_project_host(current_project['id'],
                                                  str(host_id))
            if current_host:
                db.insert_host_port(host_id, port_num, is_tcp,
                                    form.service.data, form.description.data,
                                    current_user['id'], current_project['id'])

    return render_template('project-pages/services/projectnewservice.html',
                           current_project=current_project, errors=errors)


@routes.route('/project/<uuid:project_id>/reports/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_reports(project_id, current_project, current_user):
    return render_template('project-pages/reports/reportslist.html',
                           current_project=current_project,
                           current_user=current_user)


@routes.route('/project/<uuid:project_id>/reports/export/json', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_report_export(project_id, current_project, current_user):
    # TODO: add another export types
    # TODO: export issues without service connections
    issues = db.select_project_issues(current_project['id'])
    for issue in issues:
        services = json.loads(issue['services'])
        targets = []  # google.com:80, 127.0.0.1:8080
        for port_id in services:
            target = {'ip': '', 'port': 0, 'hostnames': [], 'pocs': []}
            port = db.select_port(port_id)[0]
            target['port'] = int(port['port'])
            target['ip'] = db.select_project_host(current_project['id'],
                                                  port['host_id'])[0]['ip']
            hostnames = []
            for hostname_id in services[port_id]:
                if hostname_id != '0':
                    hostnames += [x['hostname'] for x in
                                  db.select_hostname(hostname_id)]
            target['hostnames'] = hostnames

            pocs = db.select_issue_pocs(issue['id'])
            for poc in pocs:
                poc_object = {'filename': poc['filename'],
                              'url': '',
                              'type': ''}
                poc_url = '/static/files/poc/{}'.format(poc['id'])
                poc_object['url'] = poc_url
                poc_object['type'] = poc['type']
                target['pocs'].append(poc_object)
            targets.append(target)
        issue['services'] = targets
    return jsonify(issues)


@routes.route('/project/<uuid:project_id>/chats/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def project_chats(project_id, current_project, current_user):
    return render_template('project-pages/chat/chatlist.html',
                           current_project=current_project,
                           current_user=current_user)


@routes.route('/project/<uuid:project_id>/chats/add', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def project_new_chat(project_id, current_project, current_user):
    form = NewChat()

    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)
    if not errors:
        chat_id = db.insert_chat(current_project['id'],
                                 form.name.data,
                                 current_user['id'])
    return redirect('/project/{}/chats/'.format(current_project['id']))


@routes.route('/project/<uuid:project_id>/chats/<uuid:chat_id>/getall.json',
              methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_chat_access
@send_log_data
def project_chats_getall(project_id, current_project, current_user, chat_id,
                         current_chat):
    messages = db.select_chat_messages(current_chat['id'])
    users_arr = {}
    message_array = []
    for message in messages:
        # get email
        # TODO: change email to names
        if not message['user_id'] in users_arr:
            email = db.select_user_by_id(message['user_id'])[0]['email']
            users_arr[message['user_id']] = email
        else:
            email = users_arr[message['user_id']]

        message_array.append({'email': email,
                              'message': message['message'],
                              'time': message['time']})
    return jsonify(message_array)


@routes.route(
    '/project/<uuid:project_id>/chats/<uuid:chat_id>/getnewmessages/<int:last_msg_time>/',
    methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@check_chat_access
@send_log_data
def project_chats_getlastmsg(project_id, current_project, current_user, chat_id,
                             current_chat, last_msg_time):
    messages = db.select_chat_messages(current_chat['id'], last_msg_time)
    users_arr = {}
    message_array = []
    for message in messages:
        # get email
        # TODO: change email to names
        if not message['user_id'] in users_arr:
            email = db.select_user_by_id(message['user_id'])[0]['email']
            users_arr[message['user_id']] = email
        else:
            email = users_arr[message['user_id']]

        message_array.append({'email': email,
                              'message': message['message'],
                              'time': message['time']})
    return jsonify(message_array)


@routes.route('/project/<uuid:project_id>/chats/<uuid:chat_id>/sendmessage',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@check_chat_access
@send_log_data
def project_send_chat_message(project_id, current_project, current_user,
                              chat_id, current_chat):
    form = NewMessage()

    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)
    if not errors:
        message_time = db.insert_new_message(current_chat['id'],
                                             form.message.data,
                                             current_user['id'])
        return str(message_time)
    return 'Error!'


@routes.route('/share/issue/<uuid:issue_id>/',
              methods=['GET'])
def issues_info_share(issue_id):
    current_issue = db.select_issue(str(issue_id))
    if not current_issue:
        return redirect('/404')

    current_issue = current_issue[0]

    return render_template('project-pages/issues/issueinfo_share.html',
                           current_issue=current_issue)


@routes.route('/project/<uuid:project_id>/reports/generate',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def generate_report(project_id, current_project, current_user):
    form = ReportGenerate()

    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)
    if not errors:
        if 'file' in request.files and request.files.get('file').filename:
            # if new file
            file = request.files.get('file')
            template_tmp_name = gen_uuid()
            report_path = path.join(config['main']['tmp_path'],
                                    template_tmp_name)
            file.save(report_path)
            file.close()
            file_size = stat(report_path).st_size
            if file_size > int(config['files']['template_max_size']):
                remove(report_path)
                errors.append('File too large!')
        else:
            # exist template
            if is_valid_uuid(form.template_id.data):
                if db.select_templates(template_id=form.template_id.data):
                    report_path = path.join('./static/files/templates/',
                                            form.template_id.data)
            else:
                errors.append('Wrong template id!')

    if not errors:
        if zipfile.is_zipfile(report_path):
            zipfile_obj = zipfile.ZipFile(report_path, 'r')
            zip_unpack_size = sum([zinfo.file_size for zinfo
                                   in zipfile_obj.filelist])
            if zip_unpack_size > int(config['files']['template_max_size']):
                errors.append('Unpacked ZIP too large!')
            zip_uuid = gen_uuid()
            zip_unpacked_path = path.join(config['main']['tmp_path'], zip_uuid)
            makedirs(zip_unpacked_path)
            zipfile_obj.extractall(zip_unpacked_path)
            zipfile_obj.close()
            if 'file' in request.files and request.files.get('file').filename:
                remove(report_path)
            result_zip_path = path.join(config['main']['tmp_path'],
                                        zip_uuid + '.zip')
            result_zip_obj = zipfile.ZipFile(result_zip_path, 'w',
                                             zipfile.ZIP_DEFLATED)
            for root, dirs, files in walk(zip_unpacked_path):
                for file in files:
                    file_path = path.join(root, file)
                    if file.split('.')[-1].lower() \
                            in form.extentions.data.split(','):
                        f = open(file_path, encoding='utf-8')
                        template_data = ''
                        try:
                            template_data = f.read()
                        except:
                            print('Error reading ' + file_path)
                        f.close()
                        if template_data:
                            for env in Environment(), SandboxedEnvironment():
                                template_obj = env.from_string(template_data)
                                project_dict = db.select_report_info_sorted(
                                    current_project['id'])
                                try:

                                    rendered_txt = run_function_timeout(
                                        template_obj.render, 10,
                                        project=project_dict['project'],
                                        issues=project_dict['issues'],
                                        hosts=project_dict['hosts'],
                                        pocs=project_dict['pocs'],
                                        ports=project_dict['ports'],
                                        hostnames=project_dict['hostnames'],
                                        grouped_issues=project_dict[
                                            'grouped_issues'])
                                    f = open(file_path, 'w', encoding='utf-8')
                                    f.write(rendered_txt)
                                    f.close()
                                except Exception as e:
                                    shutil.rmtree(zip_unpacked_path)
                                    return render_template(
                                        'project-pages/reports/reportslist.html',
                                        current_project=current_project,
                                        current_user=current_user,
                                        errors=errors,
                                        exception=e)
                    result_zip_obj.write(file_path)

            # add PoC to zip

            poc_save_dir = path.join(zip_unpacked_path, 'poc_files')
            makedirs(poc_save_dir)
            for current_poc in db.select_project_pocs(current_project['id']):
                poc_server_path = path.join(path.join('./static/files/poc/',
                                                      current_poc['id']))
                if current_poc['type'] == 'text':
                    poc_save_path = path.join(poc_save_dir,
                                              current_poc['id'] + '.txt')
                elif current_poc['type'] == 'image':
                    poc_save_path = path.join(poc_save_dir,
                                              current_poc['id'] + '.png')
                shutil.copyfile(poc_server_path, poc_save_path)
                result_zip_obj.write(poc_save_path)

            result_zip_obj.close()
            shutil.rmtree(zip_unpacked_path)
            result_zip_file_obj = open(result_zip_path, 'rb')
            result_data = result_zip_file_obj.read()
            result_zip_file_obj.close()
            remove(result_zip_path)
            return Response(result_data,
                            mimetype="application/zip",
                            headers={
                                "Content-disposition":
                                    "attachment; filename=report.zip"})

        else:
            # textfile
            template_file = open(report_path, encoding='utf-8')
            template_data = template_file.read()
            template_file.close()
            if 'file' in request.files and request.files.get('file').filename:
                remove(report_path)

            for env in Environment(), SandboxedEnvironment():
                try:
                    template_obj = env.from_string(template_data)
                    project_dict = db.select_report_info_sorted(
                        current_project['id'])
                    rendered_txt = run_function_timeout(template_obj.render, 10,
                                                        project=project_dict[
                                                            'project'],
                                                        issues=project_dict[
                                                            'issues'],
                                                        hosts=project_dict[
                                                            'hosts'],
                                                        pocs=project_dict[
                                                            'pocs'],
                                                        ports=project_dict[
                                                            'ports'],
                                                        hostnames=project_dict[
                                                            'hostnames'],
                                                        grouped_issues=
                                                        project_dict[
                                                            'grouped_issues'])
                    if rendered_txt:
                        return Response(rendered_txt,
                                        mimetype="text/plain")
                    else:
                        errors.append('Template generation timeout!')
                    # headers={
                    #    "Content-disposition": "attachment; filename=passwords.txt"})
                except Exception as e:
                    return render_template(
                        'project-pages/reports/reportslist.html',
                        current_project=current_project,
                        current_user=current_user,
                        errors=errors,
                        exception=e)
    return render_template(
        'project-pages/reports/reportslist.html',
        current_project=current_project,
        current_user=current_user,
        errors=errors)
