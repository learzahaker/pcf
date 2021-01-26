from . import routes
from app import check_session, db, session, redirect, render_template, request, \
    config, send_log_data, requires_authorization, csrf
from .project import check_project_access, check_project_archived
from forms import *
from libnmap.parser import NmapParser
from libnessus.parser import NessusParser
import json
import csv
import codecs
import re
import io
from flask import Response, send_file, Markup
from bs4 import BeautifulSoup
import urllib.parse
from IPy import IP
import socket
import csv
import dicttoxml
import time
from xml.dom.minidom import parseString
import ipwhois
import shodan
import ipaddress

from routes.tools_addons import nmap_scripts


@routes.route('/project/<uuid:project_id>/tools/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def project_tools(project_id, current_project, current_user):
    return render_template('project-pages/tools/toolslist.html',
                           current_project=current_project,
                           tab_name='Tools')


@routes.route('/project/<uuid:project_id>/tools/nmap/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def nmap_page(project_id, current_project, current_user):
    return render_template('project-pages/tools/import-scan/nmap.html',
                           current_project=current_project,
                           tab_name='Nmap')


@routes.route('/project/<uuid:project_id>/tools/nmap/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def nmap_page_form(project_id, current_project, current_user):
    form = NmapForm()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        add_empty_hosts = form.add_no_open.data

        # parse ports
        ignore_ports = form.ignore_ports.data.replace(' ', '')
        ignore_port_arr1 = ignore_ports.split(',') if ignore_ports else []
        ignore_port_array = []
        for port_str in ignore_port_arr1:
            protocol = 'tcp'
            port_num = port_str
            if '/' in port_str:
                if port_str.split('/')[1].lower() == 'udp':
                    protocol = 'udp'
                port_num = port_str.split('/')[0]
            port_num = int(port_num)
            ignore_port_array.append([port_num, protocol])

        ignore_services_array = [service.lower() for service in form.ignore_services.data.replace(' ', '').split(',')]

        for file in form.files.data:
            xml_report_data = file.read().decode('charmap')
        if not xml_report_data:
            return render_template('project-pages/tools/import-scan/nmap.html',
                                   current_project=current_project,
                                   errors=['No file selected!'],
                                   success=1,
                                   tab_name='Nmap')
        nmap_report = NmapParser.parse_fromstring(xml_report_data)
        try:
            command_str = nmap_report.commandline
        except:
            command_str = ''
        for host in nmap_report.hosts:
            # check if we will add host
            found = 0
            os = ''
            if host.os and host.os.osmatches:
                os = host.os.osmatches[0].name
            for service in host.services:
                protocol = service.protocol.lower()
                port_num = int(service.port)
                service_name = service.service.lower()
                if [port_num, protocol] not in ignore_port_array and service_name not in ignore_services_array:
                    if service.state == 'open':
                        found = 1
                    elif service.state == 'filtered' and \
                            form.rule.data in ['filtered', 'closed']:
                        found = 1
                    elif service.state == 'closed' and \
                            form.rule.data == 'closed':
                        found = 1
            if found or add_empty_hosts:
                host_id = db.select_project_host_by_ip(
                    current_project['id'], host.address)
                if not host_id:
                    host_id = db.insert_host(current_project['id'],
                                             host.address,
                                             current_user['id'],
                                             'Added from NMAP scan')
                else:
                    host_id = host_id[0]['id']
                if os:
                    db.update_host_os(host_id, os)
                for hostname in host.hostnames:
                    if hostname and hostname != host.address:
                        hostname_id = db.select_ip_hostname(host_id,
                                                            hostname)
                        if not hostname_id:
                            hostname_id = db.insert_hostname(host_id,
                                                             hostname,
                                                             'Added from NMAP scan',
                                                             current_user[
                                                                 'id'])
                        else:
                            hostname_id = hostname_id[0]['id']
                for service in host.services:
                    is_tcp = service.protocol == 'tcp'
                    protocol_str = service.protocol.lower()
                    port_num = int(service.port)
                    service_name = service.service
                    service_banner = service.banner
                    add = 0
                    if [port_num,
                        protocol_str] not in ignore_port_array and service_name.lower() not in ignore_services_array:
                        if service.state == 'open':
                            add = 1
                        elif service.state == 'filtered' and \
                                form.rule.data in ['filtered', 'closed']:
                            add = 1
                            service_banner += '\nstate: filtered'
                        elif service.state == 'closed' and \
                                form.rule.data == 'closed':
                            add = 1
                            service_banner += '\nstate: closed'
                    if add == 1:
                        port_id = db.select_ip_port(host_id, service.port,
                                                    is_tcp)
                        if not port_id:
                            port_id = db.insert_host_port(host_id,
                                                          service.port,
                                                          is_tcp,
                                                          service_name,
                                                          service_banner,
                                                          current_user[
                                                              'id'],
                                                          current_project[
                                                              'id'])
                        else:
                            port_id = port_id[0]['id']
                            db.update_port_proto_description(port_id,
                                                             service_name,
                                                             service_banner)

                        # check vulners
                        for script_xml in service.scripts_results:
                            for script in nmap_scripts.modules:
                                script_class = script.nmap_plugin
                                if script_class.script_id == script_xml['id']:
                                    script_obj = script_class(script_xml)

                                    if 'info' in script_obj.script_types:
                                        result = script_obj.info()
                                        update = False
                                        if 'protocol' in result and result['protocol']:
                                            service_name = result['protocol']
                                            update = True
                                        if 'info' in result and result['info']:
                                            service_banner = result['info']
                                            update = True
                                        if update:
                                            db.update_port_proto_description(port_id,
                                                                             service_name,
                                                                             service_banner)

                                    if 'issue' in script_obj.script_types:
                                        issues = script_obj.issues()
                                        for issue in issues:
                                            db.insert_new_issue_no_dublicate(issue['name'],
                                                                             issue[
                                                                                 'description'] if 'description' in issue else '',
                                                                             issue['path'] if 'path' in issue else '',
                                                                             issue['cvss'] if 'cvss' in issue else 0.0,
                                                                             current_user['id'],
                                                                             {port_id: ['0']},
                                                                             'need to recheck',
                                                                             current_project['id'],
                                                                             cve=issue['cve'] if 'cve' in issue else '',
                                                                             cwe=issue['cwe'] if 'cwe' in issue else 0,
                                                                             issue_type='service',
                                                                             fix=issue['fix'] if 'fix' in issue else '',
                                                                             param=issue[
                                                                                 'params'] if 'params' in issue else '')

    return render_template('project-pages/tools/import-scan/nmap.html',
                           current_project=current_project,
                           errors=errors,
                           success=1,
                           tab_name='Nmap')


@routes.route('/project/<uuid:project_id>/tools/nessus/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def nessus_page(project_id, current_project, current_user):
    return render_template('project-pages/tools/import-scan/nessus.html',
                           current_project=current_project,
                           tab_name='Nessus')


@routes.route('/project/<uuid:project_id>/tools/nessus/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def nessus_page_form(project_id, current_project, current_user):
    form = NessusForm()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        add_info_issues = form.add_info_issues.data
        # xml files
        for file in form.xml_files.data:
            if file.filename:
                xml_report_data = file.read().decode('charmap')
                scan_result = NessusParser.parse_fromstring(xml_report_data)
                for host in scan_result.hosts:
                    host_id = db.select_project_host_by_ip(
                        current_project['id'], host.ip)
                    if not host_id:
                        host_id = db.insert_host(current_project['id'],
                                                 host.ip,
                                                 current_user['id'],
                                                 'Added from Nessus scan')
                    else:
                        host_id = host_id[0]['id']

                    # add hostname
                    hostname_id = ''
                    hostname = host.name if host.name != host.name else ''
                    try:
                        test_hostname = IP(host.address)
                    except ValueError:
                        test_hostname = ''
                    if not hostname and not test_hostname and host.address:
                        hostname = host.address
                    if hostname:
                        hostname_id = db.select_ip_hostname(host_id, hostname)
                        if not hostname_id:
                            hostname_id = db.insert_hostname(host_id,
                                                             hostname,
                                                             'Added from Nessus scan',
                                                             current_user['id'])
                        else:
                            hostname_id = hostname_id[0]['id']

                    for issue in host.get_report_items:

                        # create port

                        is_tcp = issue.protocol == 'tcp'
                        port_id = db.select_ip_port(host_id, int(issue.port),
                                                    is_tcp)
                        if not port_id:
                            port_id = db.insert_host_port(host_id,
                                                          issue.port,
                                                          is_tcp,
                                                          issue.service,
                                                          'Added from Nessus scan',
                                                          current_user['id'],
                                                          current_project['id'])
                        else:
                            port_id = port_id[0]['id']
                            db.update_port_service(port_id,
                                                   issue.service)
                        # add issue to created port

                        name = 'Nessus: {}'.format(issue.plugin_name)
                        description = 'Plugin name: {}\r\n\r\nInfo: \r\n{}\r\n\r\nSolution:\r\n {} \r\n\r\nOutput: \r\n {}'.format(
                            issue.plugin_name,
                            issue.synopsis,
                            issue.solution,
                            issue.description.strip('\n'))
                        # add host OS
                        if issue.get_vuln_plugin["pluginName"] == 'OS Identification':
                            os = issue.get_vuln_plugin["plugin_output"].split('\n')[1].split(' : ')[1]
                            db.update_host_os(host_id, os)
                        cve = issue.cve.replace('[', '').replace(']', '').replace("'", '').replace(",",
                                                                                                   ', ') if issue.cve else ''
                        cvss = float(issue.severity)
                        if hostname_id:
                            services = {port_id: ['0', hostname_id]}
                        else:
                            services = {port_id: ['0']}
                        if cvss > 0 or (cvss == 0 and add_info_issues):
                            db.insert_new_issue_no_dublicate(name, description, '', cvss,
                                                             current_user['id'], services,
                                                             'need to check',
                                                             current_project['id'],
                                                             cve)

    return render_template('project-pages/tools/import-scan/nessus.html',
                           current_project=current_project,
                           errors=errors,
                           tab_name='Nessus')


@routes.route('/project/<uuid:project_id>/tools/nikto/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def nikto_page(project_id, current_project, current_user):
    return render_template('project-pages/tools/import-scan/nikto.html',
                           current_project=current_project,
                           tab_name='Nikto')


@routes.route('/project/<uuid:project_id>/tools/nikto/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def nikto_page_form(project_id, current_project, current_user):
    form = NiktoForm()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        # json files
        for file in form.json_files.data:
            if file.filename:
                json_report_data = file.read().decode('charmap').replace(',]',
                                                                         ']').replace(
                    ',}', '}')
                scan_result = json.loads(json_report_data)
                host = scan_result['ip']
                hostname = scan_result['host'] if scan_result['ip'] != \
                                                  scan_result['host'] else ''
                issues = scan_result['vulnerabilities']
                port = int(scan_result['port'])
                protocol = 'https' if '443' in str(port) else 'http'
                is_tcp = 1
                port_description = 'Added by Nikto scan'
                if scan_result['banner']:
                    port_description = 'Nikto banner: {}'.format(
                        scan_result['banner'])

                # add host
                host_id = db.select_project_host_by_ip(current_project['id'],
                                                       host)
                if not host_id:
                    host_id = db.insert_host(current_project['id'],
                                             host,
                                             current_user['id'],
                                             'Added by Nikto scan')
                else:
                    host_id = host_id[0]['id']

                # add hostname

                hostname_id = ''
                if hostname and hostname != host:
                    hostname_id = db.select_ip_hostname(host_id, hostname)
                    if not hostname_id:
                        hostname_id = db.insert_hostname(host_id,
                                                         hostname,
                                                         'Added from Nikto scan',
                                                         current_user['id'])
                    else:
                        hostname_id = hostname_id[0]['id']

                # add port
                port_id = db.select_ip_port(host_id, port, is_tcp)
                if not port_id:
                    port_id = db.insert_host_port(host_id,
                                                  port,
                                                  is_tcp,
                                                  protocol,
                                                  port_description,
                                                  current_user['id'],
                                                  current_project['id'])
                else:
                    port_id = port_id[0]['id']

                for issue in issues:
                    method = issue['method']
                    url = issue['url']
                    full_url = '{} {}'.format(method, url)
                    osvdb = int(issue['OSVDB'])
                    info = issue['msg']
                    full_info = 'OSVDB: {}\n\n{}'.format(osvdb, info)

                    services = {port_id: ['0']}
                    if hostname_id:
                        services = {port_id: ['0', hostname_id]}

                    db.insert_new_issue('Nikto scan', full_info, full_url, 0,
                                        current_user['id'], services,
                                        'need to check',
                                        current_project['id'],
                                        cve=0,
                                        cwe=0,
                                        )
        # csv load
        for file in form.csv_files.data:
            if file.filename:
                scan_result = csv.reader(codecs.iterdecode(file, 'charmap'),
                                         delimiter=',')

                for issue in scan_result:
                    if len(issue) == 7:
                        hostname = issue[0]
                        host = issue[1]
                        port = int(issue[2])
                        protocol = 'https' if '443' in str(port) else 'http'
                        is_tcp = 1
                        osvdb = issue[3]
                        full_url = '{} {}'.format(issue[4], issue[5])
                        full_info = 'OSVDB: {}\n{}'.format(osvdb, issue[6])

                        # add host
                        host_id = db.select_project_host_by_ip(
                            current_project['id'],
                            host)
                        if not host_id:
                            host_id = db.insert_host(current_project['id'],
                                                     host,
                                                     current_user['id'],
                                                     'Added by Nikto scan')
                        else:
                            host_id = host_id[0]['id']

                        # add hostname
                        hostname_id = ''
                        if hostname and hostname != host:
                            hostname_id = db.select_ip_hostname(host_id,
                                                                hostname)
                            if not hostname_id:
                                hostname_id = db.insert_hostname(host_id,
                                                                 hostname,
                                                                 'Added from Nikto scan',
                                                                 current_user[
                                                                     'id'])
                            else:
                                hostname_id = hostname_id[0]['id']

                        # add port
                        port_id = db.select_ip_port(host_id, port, is_tcp)
                        if not port_id:
                            port_id = db.insert_host_port(host_id,
                                                          port,
                                                          is_tcp,
                                                          protocol,
                                                          'Added from Nikto scan',
                                                          current_user['id'],
                                                          current_project['id'])
                        else:
                            port_id = port_id[0]['id']

                        # add issue
                        services = {port_id: ['0']}
                        if hostname_id:
                            services = {port_id: ['0', hostname_id]}

                        db.insert_new_issue('Nikto scan', full_info, full_url,
                                            0,
                                            current_user['id'], services,
                                            'need to check',
                                            current_project['id'],
                                            cve=0,
                                            cwe=0,
                                            )

        for file in form.xml_files.data:
            if file.filename:
                scan_result = BeautifulSoup(file.read(),
                                            "html.parser").niktoscan.scandetails
                host = scan_result['targetip']
                port = int(scan_result['targetport'])
                is_tcp = 1
                port_banner = scan_result['targetbanner']
                hostname = scan_result['targethostname']
                issues = scan_result.findAll("item")
                protocol = 'https' if '443' in str(port) else 'http'
                port_description = ''
                if port_banner:
                    port_description = 'Nikto banner: {}'.format(
                        scan_result['targetbanner'])

                # add host
                host_id = db.select_project_host_by_ip(
                    current_project['id'],
                    host)
                if not host_id:
                    host_id = db.insert_host(current_project['id'],
                                             host,
                                             current_user['id'],
                                             'Added by Nikto scan')
                else:
                    host_id = host_id[0]['id']

                # add hostname
                hostname_id = ''
                if hostname and hostname != host:
                    hostname_id = db.select_ip_hostname(host_id,
                                                        hostname)
                    if not hostname_id:
                        hostname_id = db.insert_hostname(host_id,
                                                         hostname,
                                                         'Added from Nikto scan',
                                                         current_user[
                                                             'id'])
                    else:
                        hostname_id = hostname_id[0]['id']

                # add port
                port_id = db.select_ip_port(host_id, port, is_tcp)
                if not port_id:
                    port_id = db.insert_host_port(host_id,
                                                  port,
                                                  is_tcp,
                                                  protocol,
                                                  port_description,
                                                  current_user['id'],
                                                  current_project['id'])
                else:
                    port_id = port_id[0]['id']

                for issue in issues:
                    method = issue['method']
                    url = issue.uri.contents[0]
                    full_url = '{} {}'.format(method, url)
                    osvdb = int(issue['osvdbid'])
                    info = issue.description.contents[0]
                    full_info = 'OSVDB: {}\n\n{}'.format(osvdb, info)

                    services = {port_id: ['0']}
                    if hostname_id:
                        services = {port_id: ['0', hostname_id]}

                    db.insert_new_issue('Nikto scan', full_info, full_url, 0,
                                        current_user['id'], services,
                                        'need to check',
                                        current_project['id'],
                                        cve=0,
                                        cwe=0,
                                        )

    return render_template('project-pages/tools/import-scan/nikto.html',
                           current_project=current_project,
                           tab_name='Nikto')


@routes.route('/project/<uuid:project_id>/tools/acunetix/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def acunetix_page(project_id, current_project, current_user):
    return render_template('project-pages/tools/import-scan/acunetix.html',
                           current_project=current_project,
                           tab_name='Acunetix')


@routes.route('/project/<uuid:project_id>/tools/acunetix/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def acunetix_page_form(project_id, current_project, current_user):
    form = AcunetixForm()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        auto_resolve = form.auto_resolve.data == 1

        # xml files
        for file in form.files.data:
            if file.filename:
                scan_result = BeautifulSoup(file.read(),
                                            "html.parser").scangroup.scan
                start_url = scan_result.starturl.contents[0]
                parsed_url = urllib.parse.urlparse(start_url)
                protocol = parsed_url.scheme
                hostname = parsed_url.hostname
                port = parsed_url.port
                os_descr = scan_result.os.contents[0]
                port_banner = scan_result.banner.contents[0]
                web_banner = scan_result.webserver.contents[0]
                port_description = 'Banner: {} Web: {}'.format(port_banner,
                                                               web_banner)
                host_description = 'OS: {}'.format(os_descr)
                is_tcp = 1
                if not port:
                    port = 80 if protocol == 'http' else 443

                try:
                    IP(hostname)
                    host = hostname
                    hostname = ''
                except:
                    if form.host.data:
                        IP(form.host.data)
                        host = form.host.data
                    elif form.auto_resolve.data == 1:
                        host = socket.gethostbyname(hostname)
                    else:
                        errors.append('ip not resolved!')

                if not errors:
                    # add host
                    host_id = db.select_project_host_by_ip(
                        current_project['id'],
                        host)
                    if not host_id:
                        host_id = db.insert_host(current_project['id'],
                                                 host,
                                                 current_user['id'],
                                                 host_description)
                    else:
                        host_id = host_id[0]['id']
                        db.update_host_description(host_id, host_description)

                    # add hostname
                    hostname_id = ''
                    if hostname and hostname != host:
                        hostname_id = db.select_ip_hostname(host_id,
                                                            hostname)
                        if not hostname_id:
                            hostname_id = db.insert_hostname(host_id,
                                                             hostname,
                                                             'Added from Acunetix scan',
                                                             current_user['id'])
                        else:
                            hostname_id = hostname_id[0]['id']

                    # add port
                    port_id = db.select_ip_port(host_id, port, is_tcp)
                    if not port_id:
                        port_id = db.insert_host_port(host_id,
                                                      port,
                                                      is_tcp,
                                                      protocol,
                                                      port_description,
                                                      current_user['id'],
                                                      current_project['id'])
                    else:
                        port_id = port_id[0]['id']
                        db.update_port_proto_description(port_id, protocol,
                                                         port_description)
                    issues = scan_result.reportitems.findAll("reportitem")

                    for issue in issues:
                        issue_name = issue.contents[1].contents[0]
                        module_name = issue.modulename.contents[0]
                        uri = issue.affects.contents[0]
                        request_params = issue.parameter.contents[0]
                        full_uri = '{} params:{}'.format(uri, request_params)
                        impact = issue.impact.contents[0]
                        issue_description = issue.description.contents[0]
                        recomendations = issue.recommendation.contents[0]
                        issue_request = issue.technicaldetails.request.contents[
                            0]
                        cwe = int(issue.cwe['id'].replace('CWE-', ''))
                        cvss = float(issue.cvss.score.contents[0])
                        # TODO: check CVE field

                        full_info = '''Module: \n{}\n\nDescription: \n{}\n\nImpact: \n{}\n\nRecomendations: \n{}\n\nRequest: \n{}'''.format(
                            module_name, issue_description, impact,
                            recomendations, issue_request)

                        services = {port_id: ['0']}
                        if hostname_id:
                            services = {port_id: ['0', hostname_id]}

                        db.insert_new_issue(issue_name,
                                            full_info, full_uri,
                                            cvss,
                                            current_user['id'], services,
                                            'need to check',
                                            current_project['id'],
                                            cve=0,
                                            cwe=cwe
                                            )
    return render_template('project-pages/tools/import-scan/acunetix.html',
                           current_project=current_project,
                           tab_name='Acunetix')


@routes.route('/project/<uuid:project_id>/tools/exporter/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def exporter_page(project_id, current_project, current_user):
    return render_template(
        'project-pages/tools/export/exporter.html',
        current_project=current_project,
        tab_name='Exporter')


@routes.route('/project/<uuid:project_id>/tools/exporter/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def exporter_page_form(project_id, current_project, current_user):
    form = ExportHosts()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        result_hosts = db.search_hostlist(project_id=current_project['id'],
                                          network=form.network.data,
                                          ip_hostname=form.ip_hostname.data,
                                          issue_name=form.issue_name.data,
                                          port=form.port.data,
                                          service=form.service.data,
                                          comment=form.comment.data,
                                          threats=form.threat.data)
    else:
        return render_template(
            'project-pages/tools/export/exporter.html',
            current_project=current_project,
            tab_name='Exporter')

    result = ''
    separator = '\n' if form.separator.data == '[newline]' \
        else form.separator.data
    host_export = form.hosts_export.data

    ports_array = []
    if form.port.data:
        ports_array = [[int(port.split('/')[0]), port.split('/')[1] == 'tcp']
                       for port in form.port.data.split(',')]

    if form.filetype.data == 'txt':
        # txt worker
        response_type = 'text/plain'
        if not form.add_ports.data:
            # no ports
            ips = [host['ip'] for host in result_hosts]
            ips_hostnames = {}
            hostnames = []
            for host in result_hosts:
                host_hostname = db.select_ip_hostnames(host['id'])
                hostnames += [hostname['hostname'] for hostname in
                              host_hostname]
                ips_hostnames[host['ip']] = host_hostname
            hostnames = list(set(hostnames))
            if host_export == 'ip':
                result = separator.join(ips)
            elif host_export == 'hostname':
                result = separator.join(hostnames)
            elif host_export == 'ip&hostname':
                result = separator.join(ips + hostnames)
            elif host_export == 'ip&hostname_unique':
                host_hostnames_arr = []
                for ip in ips_hostnames:
                    if not ips_hostnames[ip]:
                        host_hostnames_arr.append(ip)
                    else:
                        host_hostnames_arr += [hostname['hostname'] for
                                               hostname in ips_hostnames[ip]]
                result = separator.join(host_hostnames_arr)
        else:
            # with ports

            # preparation: issues

            if form.issue_name.data:
                port_ids = db.search_issues_port_ids(current_project['id'],
                                                     form.issue_name.data)

            for host in result_hosts:
                ports = db.select_host_ports(host['id'])
                hostnames = db.select_ip_hostnames(host['id'])
                for port in ports:
                    if (not form.port.data) or (
                            [port['port'], port['is_tcp']] in ports_array):
                        if form.service.data in port['service']:

                            if (not form.issue_name.data) or (
                                    port['id'] in port_ids):

                                if host_export == 'ip&hostname':
                                    result += '{}{}:{}'.format(separator,
                                                               host['ip'],
                                                               port['port'])
                                    for hostname in hostnames:
                                        result += '{}{}:{}'.format(separator,
                                                                   hostname[
                                                                       'hostname'],
                                                                   port['port'])
                                elif host_export == 'ip':
                                    result += '{}{}:{}'.format(separator,
                                                               host['ip'],
                                                               port['port'])

                                elif host_export == 'hostname':
                                    for hostname in hostnames:
                                        result += '{}{}:{}'.format(separator,
                                                                   hostname[
                                                                       'hostname'],
                                                                   port['port'])

                                elif host_export == 'ip&hostname_unique':
                                    if hostnames:
                                        for hostname in hostnames:
                                            result += '{}{}:{}'.format(
                                                separator,
                                                hostname[
                                                    'hostname'],
                                                port['port'])
                                    else:
                                        result += '{}{}:{}'.format(separator,
                                                                   host['ip'],
                                                                   port['port'])
            if result:
                result = result[len(separator):]

    elif form.filetype.data == 'csv':
        response_type = 'text/plain'
        # 'host/hostname','port', 'type', 'service', 'description'

        # always with ports

        csvfile = io.StringIO()
        csv_writer = csv.writer(csvfile, dialect='excel', delimiter=';')

        columns = ['host', 'port', 'type', 'service', 'description']
        csv_writer.writerow(columns)

        # preparation: issues

        if form.issue_name.data:
            port_ids = db.search_issues_port_ids(current_project['id'],
                                                 form.issue_name.data)

        for host in result_hosts:
            ports = db.select_host_ports(host['id'])
            hostnames = db.select_ip_hostnames(host['id'])
            for port in ports:
                if (not form.port.data) or ([port['port'], port['is_tcp']]
                                            in ports_array):
                    if form.service.data in port['service']:
                        if (not form.issue_name.data) or (
                                port['id'] in port_ids):
                            if host_export == 'ip&hostname':
                                csv_writer.writerow([host['ip'],
                                                     port['port'],
                                                     'tcp' if port[
                                                         'is_tcp'] else 'udp',
                                                     port['service'],
                                                     port['description']])
                                for hostname in hostnames:
                                    csv_writer.writerow([hostname['hostname'],
                                                         port['port'],
                                                         'tcp' if port[
                                                             'is_tcp'] else 'udp',
                                                         port['service'],
                                                         port['description']])
                            elif host_export == 'ip':
                                csv_writer.writerow([host['ip'],
                                                     port['port'],
                                                     'tcp' if port[
                                                         'is_tcp'] else 'udp',
                                                     port['service'],
                                                     port['description']])

                            elif host_export == 'hostname':
                                for hostname in hostnames:
                                    csv_writer.writerow([hostname['hostname'],
                                                         port['port'],
                                                         'tcp' if port[
                                                             'is_tcp'] else 'udp',
                                                         port['service'],
                                                         port['description']])

                            elif host_export == 'ip&hostname_unique':
                                if hostnames:
                                    for hostname in hostnames:
                                        csv_writer.writerow(
                                            [hostname['hostname'],
                                             port['port'],
                                             'tcp' if port[
                                                 'is_tcp'] else 'udp',
                                             port['service'],
                                             port['description']])
                                else:
                                    csv_writer.writerow([host['ip'],
                                                         port['port'],
                                                         'tcp' if port[
                                                             'is_tcp'] else 'udp',
                                                         port['service'],
                                                         port['description']])
        result = csvfile.getvalue()

    elif form.filetype.data == 'json' or form.filetype.data == 'xml':

        if form.filetype.data == 'xml':
            response_type = 'text/xml'
        else:
            response_type = 'application/json'

        # first generates json

        # [{"<ip>":"","hostnames":["<hostname_1",..],
        # "ports":[ {"num":"<num>", "type":"tcp", "service":"<service>",
        # "description": "<comment>"},...],},...]

        json_object = []

        # preparation: issues

        if form.issue_name.data:
            port_ids = db.search_issues_port_ids(current_project['id'],
                                                 form.issue_name.data)

        for host in result_hosts:
            ports = db.select_host_ports(host['id'])
            hostnames = db.select_ip_hostnames(host['id'])

            host_object = {}
            host_object['ip'] = host['ip']
            host_object['hostnames'] = [hostname['hostname'] for hostname in
                                        hostnames]
            host_object['ports'] = []
            for port in ports:
                if (not form.port.data) or ([port['port'], port['is_tcp']]
                                            in ports_array):
                    if form.service.data in port['service']:
                        port_object = {}
                        port_object['num'] = port['port']
                        port_object['type'] = 'tcp' if port['is_tcp'] else 'udp'
                        port_object['service'] = port['service']
                        port_object['description'] = port['description']

                        if (not form.issue_name.data) or (
                                port['id'] in port_ids):
                            host_object['ports'].append(port_object)

            if not ((not host_object['ports']) and (form.port.data or
                                                    form.service.data or
                                                    form.issue_name.data)):
                json_object.append(host_object)

        if form.filetype.data == 'xml':
            s = dicttoxml.dicttoxml(json_object)
            dom = parseString(s)
            result = dom.toprettyxml()
        else:
            result = json.dumps(json_object, sort_keys=True, indent=4)

    if form.open_in_browser.data:
        return Response(result, content_type=response_type)

    else:
        return send_file(io.BytesIO(result.encode()),
                         attachment_filename='{}.{}'.format(form.filename.data,
                                                            form.filetype.data),
                         mimetype=response_type,
                         as_attachment=True)


@routes.route('/project/<uuid:project_id>/tools/http-sniffer/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@send_log_data
def http_sniffer(project_id, current_project, current_user):
    return render_template('project-pages/tools/sniffers/http-sniffer.html',
                           current_project=current_project,
                           tab_name='HTTP-Sniffer')


@routes.route('/project/<uuid:project_id>/tools/http-sniffer/add',
              methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def http_sniffer_add_form(project_id, current_project, current_user):
    form = NewHTTPSniffer()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        db.insert_new_http_sniffer(form.name.data, current_project['id'])
    return redirect(
        '/project/{}/tools/http-sniffer/'.format(current_project['id']))


@routes.route(
    '/project/<uuid:project_id>/tools/http-sniffer/<uuid:sniffer_id>/edit',
    methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def http_sniffer_edit_form(project_id, current_project, current_user,
                           sniffer_id):
    # check if sniffer in project
    current_sniffer = db.select_http_sniffer_by_id(str(sniffer_id))
    if not current_sniffer or current_sniffer[0]['project_id'] != \
            current_project['id']:
        return redirect(
            '/project/{}/tools/http-sniffer/'.format(current_project['id']))

    current_sniffer = current_sniffer[0]

    form = EditHTTPSniffer()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        if form.submit.data == 'Clear':
            db.delete_http_sniffer_requests(current_sniffer['id'])
        elif form.submit.data == 'Update':
            db.update_http_sniffer(current_sniffer['id'],
                                   form.status.data,
                                   form.location.data,
                                   form.body.data)
    return redirect(
        '/project/{}/tools/http-sniffer/'.format(current_project['id']))


@routes.route('/http_sniff/<uuid:sniffer_id>/', defaults={"route_path": ""},
              methods=['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'CONNECT',
                       'OPTIONS', 'TRACE', 'PATCH'])
@csrf.exempt
@routes.route('/http_sniff/<uuid:sniffer_id>/<path:route_path>',
              methods=['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'CONNECT',
                       'OPTIONS', 'TRACE', 'PATCH'])
@csrf.exempt
def http_sniffer_capture_page(sniffer_id, route_path):
    current_sniffer = db.select_http_sniffer_by_id(str(sniffer_id))

    if not current_sniffer:
        return redirect('/')

    current_sniffer = current_sniffer[0]

    http_start_header = '''{} {} {}'''.format(request.method,
                                              request.environ['RAW_URI'],
                                              request.environ[
                                                  'SERVER_PROTOCOL'])

    http_headers = str(request.headers)

    data = request.get_data().decode('charmap')

    ip = request.remote_addr

    current_time = int(time.time() * 1000)

    full_request_str = '''{}\n{}{}'''.format(http_start_header, http_headers,
                                             data)

    db.insert_new_http_sniffer_package(current_sniffer['id'], current_time,
                                       ip, full_request_str)

    if current_sniffer['location']:
        return current_sniffer['body'], current_sniffer['status'], {
            'Location': current_sniffer['location'],
            'Content-Type': 'text/plain'}
    else:
        return current_sniffer['body'], current_sniffer['status'], \
               {'Content-Type': 'text/plain'}


@routes.route(
    '/project/<uuid:project_id>/tools/http-sniffer/<uuid:sniffer_id>/delete',
    methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def http_sniffer_delete_form(project_id, current_project, current_user,
                             sniffer_id):
    # check if sniffer in project
    current_sniffer = db.select_http_sniffer_by_id(str(sniffer_id))
    if not current_sniffer or current_sniffer[0]['project_id'] != \
            current_project['id']:
        return redirect(
            '/project/{}/tools/http-sniffer/'.format(current_project['id']))

    current_sniffer = current_sniffer[0]

    db.safe_delete_http_sniffer(current_sniffer['id'])
    return redirect(
        '/project/{}/tools/http-sniffer/'.format(current_project['id']))


@routes.route('/project/<uuid:project_id>/tools/ipwhois/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def ipwhois_page(project_id, current_project, current_user):
    return render_template('project-pages/tools/scanners/ipwhois.html',
                           current_project=current_project,
                           tab_name='IPWhois')


@routes.route('/project/<uuid:project_id>/tools/ipwhois/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def ipwhois_page_form(project_id, current_project, current_user):
    form = IPWhoisForm()
    form.validate()

    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if form.ip.data:
        try:
            ip_object = ipwhois.IPWhois(form.ip.data)
            ip_data = ip_object.lookup_rdap()
            asn_num = ip_data["asn"]
            if asn_num != 'NA':
                network = ip_data["asn_cidr"]
                gateway = network.split('/')[0]
                mask = int(network.split('/')[1])
                country = ip_data["asn_country_code"]
                description = ip_data["asn_description"]
                asn_date = ip_data['asn_date']
                ip_version = ip_data["network"]["ip_version"]

                # insert_new_network(self, ip, mask, asn, comment,
                # project_id, user_id,is_ipv6):

                full_description = "Country: {}\nDate: {}\nDescription: {}".format(
                    country,
                    asn_date,
                    description)

                # check if exist

                network = db.select_network_by_ip(current_project['id'],
                                                  gateway,
                                                  mask,
                                                  ipv6=(ip_version == 'v6'))
                if not network:
                    network_id = db.insert_new_network(gateway, mask, asn_num,
                                                       full_description,
                                                       current_project['id'],
                                                       current_user['id'],
                                                       ip_version == 'v6')
                else:
                    network_id = network[0]['id']
                    db.update_network(network_id, current_project['id'], gateway, mask, asn_num,
                                      full_description, ip_version == 'v6')
                return redirect(
                    '/project/{}/networks/'.format(current_project['id']))
            else:
                errors.append('ASN does not exist!')


        except ipwhois.IPDefinedError:
            errors.append('IP was defined in standards')
        except ValueError:
            errors.append('IP was defined in standards')
    elif form.hosts.data:
        for host in form.hosts.data.split(','):
            try:
                ip_object = ipwhois.IPWhois(host)
                ip_data = ip_object.lookup_rdap()
                asn_num = ip_data["asn"]
                if asn_num != 'NA':
                    network = ip_data["asn_cidr"]
                    gateway = network.split('/')[0]
                    mask = int(network.split('/')[1])
                    country = ip_data["asn_country_code"]
                    description = ip_data["asn_description"]
                    asn_date = ip_data['asn_date']
                    ip_version = ip_data["network"]["ip_version"]

                    # insert_new_network(self, ip, mask, asn, comment,
                    # project_id, user_id,is_ipv6):

                    full_description = "Country: {}\nDate: {}\nDescription: {}".format(
                        country,
                        asn_date,
                        description)

                    # check if exist

                    network = db.select_network_by_ip(current_project['id'],
                                                      gateway,
                                                      mask,
                                                      ipv6=(ip_version == 'v6'))
                    if not network:
                        network_id = db.insert_new_network(gateway, mask,
                                                           asn_num,
                                                           full_description,
                                                           current_project[
                                                               'id'],
                                                           current_user['id'],
                                                           ip_version == 'v6')
                    else:
                        network_id = network[0]['id']
                        db.update_network(network_id, current_project['id'], gateway, mask,
                                          asn_num, full_description, ip_version == 'v6')
                else:
                    errors.append('ASN does not exist!')
            except ipwhois.IPDefinedError:
                errors.append('IP was defined in standards')
            except ValueError:
                errors.append('IP was defined in standards')

    elif form.networks.data:
        for host in form.networks.data.split(','):
            try:
                ip_object = ipwhois.IPWhois(host)
                ip_data = ip_object.lookup_rdap()
                asn_num = ip_data["asn"]
                if asn_num != 'NA':
                    network = ip_data["asn_cidr"]
                    gateway = network.split('/')[0]
                    mask = int(network.split('/')[1])
                    country = ip_data["asn_country_code"]
                    description = ip_data["asn_description"]
                    asn_date = ip_data['asn_date']
                    ip_version = ip_data["network"]["ip_version"]

                    # insert_new_network(self, ip, mask, asn, comment,
                    # project_id, user_id,is_ipv6):

                    full_description = "Country: {}\nDate: {}\nDescription: {}".format(
                        country,
                        asn_date,
                        description)

                    # check if exist

                    network = db.select_network_by_ip(current_project['id'],
                                                      gateway,
                                                      mask,
                                                      ipv6=(ip_version == 'v6'))
                    if not network:
                        network_id = db.insert_new_network(gateway, mask,
                                                           asn_num,
                                                           full_description,
                                                           current_project[
                                                               'id'],
                                                           current_user['id'],
                                                           ip_version == 'v6')
                    else:
                        network_id = network[0]['id']
                        db.update_network(network_id, current_project['id'], gateway, mask, asn_num,
                                          full_description, ip_version == 'v6')
                else:
                    errors.append('ASN does not exist!')
            except ipwhois.IPDefinedError:
                errors.append('IP was defined in standards')
            except ValueError:
                errors.append('Wrong ip format')

    return render_template('project-pages/tools/scanners/ipwhois.html',
                           current_project=current_project,
                           errors=errors,
                           tab_name='IPWhois')


@routes.route('/project/<uuid:project_id>/tools/shodan/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def shodan_page(project_id, current_project, current_user):
    return render_template('project-pages/tools/scanners/shodan.html',
                           current_project=current_project,
                           tab_name='Shodan')


@routes.route('/project/<uuid:project_id>/tools/shodan/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def shodan_page_form(project_id, current_project, current_user):
    form = ShodanForm()
    form.validate()

    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    # api_key

    shodan_api_key = ''

    if form.api_id.data and is_valid_uuid(form.api_id.data):
        users_configs = db.select_configs(team_id='0',
                                          user_id=current_user['id'],
                                          name='shodan')

        for team in db.select_user_teams(current_user['id']):
            users_configs += db.select_configs(team_id=team['id'],
                                               user_id='0',
                                               name='shodan')

        for config in users_configs:
            if config['id'] == form.api_id.data:
                shodan_api_key = config['data']

    if not shodan_api_key:
        errors.append('Key not found!')

    shodan_api = shodan.Shodan(shodan_api_key)

    # checker
    try:
        shodan_api.host('8.8.8.8')
    except shodan.exception.APIError:
        errors.append('Wrong API Shodan key!')

    if not errors:
        if form.ip.data:
            try:
                shodan_json = shodan_api.host(form.ip.data)
                asn = int(shodan_json['asn'].replace('AS', ''))
                os_info = shodan_json['os']
                ip = shodan_json['ip_str']
                ip_version = IP(ip).version()
                asn_info = shodan_json['isp']
                coords = ''
                if 'latitude' in shodan_json:
                    coords = "lat {} long {}".format(shodan_json['latitude'],
                                                     shodan_json['longitude'])
                country = ''
                if 'country_name' in shodan_json:
                    country = shodan_json['country_name']
                city = ''
                if 'city' in shodan_json:
                    city = shodan_json['city']
                organization = shodan_json['org']

                if form.need_network.data:
                    # create network
                    net_tmp = ipwhois.net.Net('8.8.8.8')
                    asn_tmp = ipwhois.asn.ASNOrigin(net_tmp)
                    asn_full_data = asn_tmp.lookup(asn='AS{}'.format(asn))
                    for network in asn_full_data['nets']:
                        if ipaddress.ip_address(ip) in \
                                ipaddress.ip_network(network['cidr'], False):
                            cidr = network['cidr']
                            net_ip = cidr.split('/')[0]
                            net_mask = int(cidr.split('/')[1])
                            net_descr = network['description']
                            net_maintain = network['maintainer']
                            full_network_description = 'ASN info: {}\nCountry: {}\nCity: {}\nCoords: {}\nDescription: {}\nMaintainer: {}'.format(
                                asn_info, country, city,
                                coords, net_descr, net_maintain)

                            network_id = db.select_network_by_ip(
                                current_project['id'], net_ip, net_mask,
                                ip_version == 6)

                            if not network_id:
                                network_id = db.insert_new_network(net_ip,
                                                                   net_mask,
                                                                   asn,
                                                                   full_network_description,
                                                                   current_project[
                                                                       'id'],
                                                                   current_user[
                                                                       'id'],
                                                                   ip_version == 6)
                            else:
                                network_id = network_id[0]['id']
                                db.update_network(network_id, current_project['id'], net_ip, net_mask,
                                                  asn, full_network_description, ip_version == 6)

                # create host
                full_host_description = "Country: {}\nCity: {}\nOS: {}\nOrganization: {}".format(
                    country, city, os_info, organization)
                # hostnames = shodan_json["hostnames"]

                host_id = db.select_project_host_by_ip(
                    current_project['id'],
                    ip)
                if host_id:
                    host_id = host_id[0]['id']
                    db.update_host_description(host_id,
                                               full_host_description)
                else:
                    host_id = db.insert_host(current_project['id'],
                                             ip,
                                             current_user['id'],
                                             full_host_description)
                # add hostnames
                for hostname in shodan_json["hostnames"]:
                    hostname_obj = db.select_ip_hostname(host_id, hostname)
                    if not hostname_obj:
                        hostname_id = db.insert_hostname(host_id,
                                                         hostname,
                                                         'Added from Shodan',
                                                         current_user['id'])

                # add ports with cve
                for port in shodan_json['data']:
                    product = ''
                    if 'product' in port:
                        product = port['product']
                    is_tcp = (port['transport'] == 'tcp')
                    port_num = int(port['port'])
                    port_info = ''
                    protocol = port['_shodan']["module"]
                    if 'info' in port:
                        port_info = port['info']

                    full_port_info = "Product: {}\nInfo: {}".format(
                        product,
                        port_info
                    )

                    port_id = db.select_ip_port(host_id, port_num,
                                                is_tcp=is_tcp)

                    if port_id:
                        port_id = port_id[0]['id']
                        db.update_port_proto_description(port_id,
                                                         protocol,
                                                         full_port_info)
                    else:
                        port_id = db.insert_host_port(host_id, port_num,
                                                      is_tcp,
                                                      protocol,
                                                      full_port_info,
                                                      current_user['id'],
                                                      current_project['id'])

                    # add vulnerabilities
                    if "vulns" in port:
                        vulns = port['vulns']
                        for cve in vulns:
                            cvss = vulns[cve]['cvss']
                            summary = vulns[cve]['summary']
                            services = {port_id: ["0"]}

                            issue_id = db.insert_new_issue(cve, summary, '',
                                                           cvss,
                                                           current_user[
                                                               'id'],
                                                           services,
                                                           'need to check',
                                                           current_project[
                                                               'id'],
                                                           cve=cve)

            except shodan.exception.APIError as e:
                errors.append(e)
            except ValueError:
                errors.append('Wrong ip!')
        elif form.hosts.data:
            for host in form.hosts.data.split(','):
                try:
                    shodan_json = shodan_api.host(host)
                    asn = int(shodan_json['asn'].replace('AS', ''))
                    os_info = shodan_json['os']
                    ip = shodan_json['ip_str']
                    ip_version = IP(ip).version()
                    asn_info = shodan_json['isp']
                    coords = ''
                    if 'latitude' in shodan_json:
                        coords = "lat {} long {}".format(
                            shodan_json['latitude'],
                            shodan_json['longitude'])
                    country = ''
                    if 'country_name' in shodan_json:
                        country = shodan_json['country_name']
                    city = ''
                    if 'city' in shodan_json:
                        city = shodan_json['city']
                    organization = shodan_json['org']

                    if form.need_network.data:
                        # create network
                        net_tmp = ipwhois.net.Net('8.8.8.8')
                        asn_tmp = ipwhois.asn.ASNOrigin(net_tmp)
                        asn_full_data = asn_tmp.lookup(asn='AS{}'.format(asn))
                        for network in asn_full_data['nets']:
                            if ipaddress.ip_address(ip) in \
                                    ipaddress.ip_network(network['cidr'],
                                                         False):
                                cidr = network['cidr']
                                net_ip = cidr.split('/')[0]
                                net_mask = int(cidr.split('/')[1])
                                net_descr = network['description']
                                net_maintain = network['maintainer']
                                full_network_description = 'ASN info: {}\nCountry: {}\nCity: {}\nCoords: {}\nDescription: {}\nMaintainer: {}'.format(
                                    asn_info, country, city,
                                    coords, net_descr, net_maintain)

                                network_id = db.select_network_by_ip(
                                    current_project['id'], net_ip, net_mask,
                                    ip_version == 6)

                                if not network_id:
                                    network_id = db.insert_new_network(net_ip,
                                                                       net_mask,
                                                                       asn,
                                                                       full_network_description,
                                                                       current_project[
                                                                           'id'],
                                                                       current_user[
                                                                           'id'],
                                                                       ip_version == 6)
                                else:
                                    network_id = network_id[0]['id']
                                    db.update_network(network_id, current_project['id'], net_ip, net_mask,
                                                      asn, full_network_description, ip_version == 6)

                    # create host
                    full_host_description = "Country: {}\nCity: {}\nOS: {}\nOrganization: {}".format(
                        country, city, os_info, organization)
                    # hostnames = shodan_json["hostnames"]

                    host_id = db.select_project_host_by_ip(
                        current_project['id'],
                        ip)
                    if host_id:
                        host_id = host_id[0]['id']
                        db.update_host_description(host_id,
                                                   full_host_description)
                    else:
                        host_id = db.insert_host(current_project['id'],
                                                 ip,
                                                 current_user['id'],
                                                 full_host_description)
                    # add hostnames
                    for hostname in shodan_json["hostnames"]:
                        hostname_obj = db.select_ip_hostname(host_id, hostname)
                        if not hostname_obj:
                            hostname_id = db.insert_hostname(host_id,
                                                             hostname,
                                                             'Added from Shodan',
                                                             current_user['id'])

                    # add ports with cve
                    for port in shodan_json['data']:
                        product = ''
                        if 'product' in port:
                            product = port['product']
                        is_tcp = (port['transport'] == 'tcp')
                        port_num = int(port['port'])
                        port_info = ''
                        protocol = port['_shodan']["module"]
                        if 'info' in port:
                            port_info = port['info']

                        full_port_info = "Product: {}\nInfo: {}".format(
                            product,
                            port_info
                        )

                        port_id = db.select_ip_port(host_id, port_num,
                                                    is_tcp=is_tcp)

                        if port_id:
                            port_id = port_id[0]['id']
                            db.update_port_proto_description(port_id,
                                                             protocol,
                                                             full_port_info)
                        else:
                            port_id = db.insert_host_port(host_id, port_num,
                                                          is_tcp,
                                                          protocol,
                                                          full_port_info,
                                                          current_user['id'],
                                                          current_project['id'])

                        # add vulnerabilities
                        if "vulns" in port:
                            vulns = port['vulns']
                            for cve in vulns:
                                cvss = vulns[cve]['cvss']
                                summary = vulns[cve]['summary']
                                services = {port_id: ["0"]}

                                issue_id = db.insert_new_issue(cve, summary, '',
                                                               cvss,
                                                               current_user[
                                                                   'id'],
                                                               services,
                                                               'need to check',
                                                               current_project[
                                                                   'id'],
                                                               cve=cve)
                except shodan.exception.APIError as e:
                    errors.append(e)
                except ValueError:
                    errors.append('Wrong ip!')
                time.sleep(1.1)  # shodan delay

        elif form.networks.data:
            for network_id in form.networks.data.split(','):
                if is_valid_uuid(network_id):
                    current_network = db.select_network(network_id)
                    if current_network and current_network[0]['asn'] and \
                            current_network[0]['asn'] > 0:
                        asn = int(current_network[0]['asn'])

                        result = shodan_api.search('asn:AS{}'.format(asn),
                                                   limit=1000)
                        for shodan_json in result['matches']:
                            try:
                                os_info = shodan_json['os']
                                ip = shodan_json['ip_str']
                                ip_version = IP(ip).version()
                                asn_info = shodan_json['isp']
                                coords = ''
                                if 'latitude' in shodan_json:
                                    coords = "lat {} long {}".format(
                                        shodan_json['latitude'],
                                        shodan_json['longitude'])
                                country = ''
                                if 'country_name' in shodan_json:
                                    country = shodan_json['country_name']
                                city = ''
                                if 'city' in shodan_json:
                                    city = shodan_json['city']
                                organization = shodan_json['org']

                                if form.need_network.data:
                                    # create network
                                    net_tmp = ipwhois.net.Net('8.8.8.8')
                                    asn_tmp = ipwhois.asn.ASNOrigin(net_tmp)
                                    asn_full_data = asn_tmp.lookup(
                                        asn='AS{}'.format(asn))
                                    for network in asn_full_data['nets']:
                                        if ipaddress.ip_address(ip) in \
                                                ipaddress.ip_network(
                                                    network['cidr'],
                                                    False):
                                            cidr = network['cidr']
                                            net_ip = cidr.split('/')[0]
                                            net_mask = int(cidr.split('/')[1])
                                            net_descr = network['description']
                                            net_maintain = network['maintainer']
                                            full_network_description = 'ASN info: {}\nCountry: {}\nCity: {}\nCoords: {}\nDescription: {}\nMaintainer: {}'.format(
                                                asn_info, country, city,
                                                coords, net_descr, net_maintain)

                                            network_id = db.select_network_by_ip(
                                                current_project['id'], net_ip,
                                                net_mask,
                                                ip_version == 6)

                                            if not network_id:
                                                network_id = db.insert_new_network(
                                                    net_ip,
                                                    net_mask,
                                                    asn,
                                                    full_network_description,
                                                    current_project[
                                                        'id'],
                                                    current_user[
                                                        'id'],
                                                    ip_version == 6)
                                            else:
                                                network_id = network_id[0]['id']
                                                db.update_network(network_id,
                                                                  current_project['id'],
                                                                  net_ip,
                                                                  net_mask,
                                                                  asn,
                                                                  full_network_description,
                                                                  ip_version == 6)

                                # create host
                                full_host_description = "Country: {}\nCity: {}\nOS: {}\nOrganization: {}".format(
                                    country, city, os_info, organization)
                                # hostnames = shodan_json["hostnames"]

                                host_id = db.select_project_host_by_ip(
                                    current_project['id'],
                                    ip)
                                if host_id:
                                    host_id = host_id[0]['id']
                                    db.update_host_description(host_id,
                                                               full_host_description)
                                else:
                                    host_id = db.insert_host(
                                        current_project['id'],
                                        ip,
                                        current_user['id'],
                                        full_host_description)
                                # add hostnames
                                for hostname in shodan_json["hostnames"]:
                                    hostname_obj = db.select_ip_hostname(
                                        host_id, hostname)
                                    if not hostname_obj:
                                        hostname_id = db.insert_hostname(
                                            host_id,
                                            hostname,
                                            'Added from Shodan',
                                            current_user['id'])

                                # add ports with cve
                                port_num = int(shodan_json['port'])
                                product = ''
                                if 'product' in shodan_json:
                                    product = shodan_json['product']
                                is_tcp = int(shodan_json['transport'] == 'tcp')
                                port_info = ''
                                protocol = shodan_json['_shodan']["module"]
                                if 'info' in shodan_json:
                                    port_info = shodan_json['info']

                                full_port_info = "Product: {}\nInfo: {}".format(
                                    product,
                                    port_info
                                )

                                port_id = db.select_ip_port(host_id,
                                                            port_num,
                                                            is_tcp=is_tcp)

                                if port_id:
                                    port_id = port_id[0]['id']
                                    db.update_port_proto_description(
                                        port_id,
                                        protocol,
                                        full_port_info)
                                else:
                                    port_id = db.insert_host_port(host_id,
                                                                  port_num,
                                                                  is_tcp,
                                                                  protocol,
                                                                  full_port_info,
                                                                  current_user[
                                                                      'id'],
                                                                  current_project[
                                                                      'id'])

                                # add vulnerabilities
                                if "vulns" in shodan_json:
                                    vulns = shodan_json['vulns']
                                    for cve in vulns:
                                        cvss = vulns[cve]['cvss']
                                        summary = vulns[cve]['summary']
                                        services = {port_id: ["0"]}

                                        issue_id = db.insert_new_issue(cve,
                                                                       summary,
                                                                       '',
                                                                       cvss,
                                                                       current_user[
                                                                           'id'],
                                                                       services,
                                                                       'need to check',
                                                                       current_project[
                                                                           'id'],
                                                                       cve=cve)
                            except shodan.exception.APIError as e:
                                pass  # a lot of errors
                            except ValueError:
                                pass  # a lot of errors
                            time.sleep(1.1)  # shodan delay
    return render_template('project-pages/tools/scanners/shodan.html',
                           current_project=current_project,
                           errors=errors,
                           tab_name='Shodan')


@routes.route('/project/<uuid:project_id>/tools/checkmarx/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def checkmarx_page(project_id, current_project, current_user):
    return render_template('project-pages/tools/import-scan/checkmarx.html',
                           current_project=current_project,
                           tab_name='Checkmarx')


@routes.route('/project/<uuid:project_id>/tools/checkmarx/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def checkmarx_page_form(project_id, current_project, current_user):
    form = CheckmaxForm()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:

        # xml files
        for file in form.xml_files.data:
            if file.filename:
                scan_result = BeautifulSoup(file.read(),
                                            "html.parser")
                query_list = scan_result.find_all("query")
                for query in query_list:
                    vulnerability_name = re.sub(' Version:[0-9]+', '', query.attrs['querypath'].split('\\')[-1])
                    language = query.attrs['language']
                    cwe = query.attrs['cweid']
                    vuln_array = query.find_all("result")
                    for vuln_example in vuln_array:
                        criticality = vuln_example.attrs['severity']  # High
                        filename = vuln_example.attrs['filename']
                        path_find = vuln_example.find_all("path")
                        paths_str_arrays = []
                        for path_obj in path_find:
                            paths_str = ''
                            path_nodes = vuln_example.find_all("pathnode")
                            if path_nodes:
                                paths_str = '########## Path {} ###########\n'.format(path_find.index(path_obj) + 1)
                            for path_node in path_nodes:
                                filename = path_node.find_all("filename")[0].text
                                line_num = int(path_node.find_all("line")[0].text)
                                colum_num = int(path_node.find_all("column")[0].text)
                                code_arr = path_node.find_all("code")
                                node_str = 'Filename: {}\nLine: {} Column: {}'.format(filename, line_num, colum_num)
                                for code in code_arr:
                                    node_str += '\n' + code.text.strip(' \t')
                                paths_str += node_str + '\n\n'

                            if paths_str:
                                paths_str_arrays.append(paths_str + '\n\n')
                        all_paths_str = '\n'.join(paths_str_arrays)

                        if criticality == 'High':
                            cvss = 9.5
                        elif criticality == 'Medium':
                            cvss = 8.0
                        elif criticality == 'Low':
                            cvss = 2.0
                        else:
                            cvss = 0
                        issue_id = db.insert_new_issue(vulnerability_name,
                                                       'Language: {}\n'.format(language) + all_paths_str, filename,
                                                       cvss, current_user['id'],
                                                       {}, 'need to check', current_project['id'], cwe=cwe,
                                                       issue_type='custom')
    return render_template('project-pages/tools/import-scan/checkmarx.html',
                           current_project=current_project,
                           errors=errors,
                           tab_name='Checkmarx')


@routes.route('/project/<uuid:project_id>/tools/depcheck/', methods=['GET'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def depcheck_page(project_id, current_project, current_user):
    return render_template('project-pages/tools/import-scan/dep-check.html',
                           current_project=current_project,
                           tab_name='DepCheck')


@routes.route('/project/<uuid:project_id>/tools/depcheck/', methods=['POST'])
@requires_authorization
@check_session
@check_project_access
@check_project_archived
@send_log_data
def depcheck_page_form(project_id, current_project, current_user):
    form = Depcheck()
    form.validate()
    errors = []
    if form.errors:
        for field in form.errors:
            for error in form.errors[field]:
                errors.append(error)

    if not errors:
        for file in form.xml_files.data:
            if file.filename:
                scan_result = BeautifulSoup(file.read(),
                                            "html.parser")
                query_list = scan_result.find_all("dependency")
                for query in query_list:

                    filename = query.find("filename").text
                    filepath = query.find("filepath").text

                    vuln_array = query.find_all("vulnerability")
                    for vuln_example in vuln_array:
                        name = vuln_example.find('name').text
                        cve = ''
                        if name.startswith('CVE'):
                            cve = name
                        cvss = float(vuln_example.find('cvssv3').find('basescore').text)
                        cwes = vuln_example.find_all("cwe")
                        cwe = 0
                        if cwes:
                            cwe = int(cwes[0].text.replace('CWE-', ''))
                        description = vuln_example.find('description').text
                        soft_search = vuln_example.find_all("software")
                        software_arr = []
                        for path_obj in soft_search:
                            s = str(path_obj.text)
                            versions = ''
                            if 'versionstartincluding' in path_obj.attrs:
                                versions += str(path_obj.attrs['versionstartincluding']) + '<=x'
                            if 'versionstartexcluding' in path_obj.attrs:
                                versions += str(path_obj.attrs['versionendexcluding']) + '<x'
                            if 'versionendincluding' in path_obj.attrs:
                                versions += '<=' + str(path_obj.attrs['versionendincluding'])
                            if 'versionendexcluding' in path_obj.attrs:
                                versions += '<' + str(path_obj.attrs['versionendexcluding'])

                            if versions:
                                s += ' versions ({})'.format(versions)
                            software_arr.append(s)

                        all_software_str = '\n\n'.join(software_arr)

                        full_description = 'File: ' + filepath + '\n\n' + description \
                                           + '\n\nVulnerable versions: \n' + all_software_str

                        issue_id = db.insert_new_issue(name, full_description, filepath, cvss, current_user['id'],
                                                       '{}', 'need to recheck', current_project['id'], cve, cwe,
                                                       'custom', '', filename)
    return render_template('project-pages/tools/import-scan/dep-check.html',
                           current_project=current_project,
                           tab_name='DepCheck')
