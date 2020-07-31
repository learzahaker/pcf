import sqlite3
from system.config_load import config_dict
from system.crypto_functions import *
import json


class Database:
    db_path = config_dict()['database']['path']
    cursor = None
    conn = None

    def __init__(self):
        self.conn = sqlite3.connect(self.db_path, check_same_thread=False)
        self.cursor = self.conn.cursor()
        return

    def return_arr_dict(self):
        ncols = len(self.cursor.description)
        colnames = [self.cursor.description[i][0] for i in range(ncols)]
        results = []
        for row in self.cursor.fetchall():
            res = {}
            for i in range(ncols):
                res[colnames[i]] = row[i]
            results.append(res)
        return results

    def insert_user(self, email, password):
        password_hash = hash_password(password)
        self.cursor.execute(
            "INSERT INTO Users(`id`,`email`,`password`) VALUES (?,?,?)",
            (gen_uuid(), email, password_hash)
        )
        self.conn.commit()
        return

    def select_user_by_email(self, email):
        self.cursor.execute('SELECT * FROM Users WHERE email=?', (email,))
        result = self.return_arr_dict()
        return result

    def select_user_by_id(self, user_id):
        self.cursor.execute('SELECT * FROM Users WHERE id=?', (user_id,))
        result = self.return_arr_dict()
        return result

    def update_user_info(self, user_id, fname, lname, email, company):
        self.cursor.execute('''UPDATE Users SET fname=?, 
                                                lname=?, 
                                                email=?, 
                                                company=? 
                               WHERE id=?''',
                            (fname, lname, email, company, user_id))
        self.conn.commit()
        return

    def update_user_password(self, id, password):
        password_hash = hash_password(password)
        self.cursor.execute('''UPDATE Users SET password=? WHERE id=?''',
                            (password_hash, id))
        self.conn.commit()
        return

    def insert_team(self, name, description, user_id):
        self.cursor.execute(
            "INSERT INTO Teams(`id`,`admin_id`,`name`,`description`,`admin_email`,`users`) "
            "VALUES (?,?,?,?,(SELECT `email` FROM Users WHERE `id`=? LIMIT 1),?)",
            (gen_uuid(),
             user_id,
             name,
             description,
             user_id,
             '{{"{}":"admin"}}'.format(user_id))  # initiation of json dict
        )
        self.conn.commit()
        return

    def select_user_teams(self, user_id):
        self.cursor.execute(
            'SELECT * FROM Teams WHERE '
            '`admin_id`=? OR '
            '`users` LIKE \'%\' || ? ||\'%\' ',
            (user_id, user_id))
        result = self.return_arr_dict()
        return result

    def update_team_info(self, team_id, name, admin_email, description):
        self.cursor.execute(
            '''UPDATE Teams SET name=?,admin_email=?,description=? WHERE id=?''',
            (name, admin_email, description, team_id))
        self.conn.commit()
        return

    def select_team_by_id(self, team_id):
        self.cursor.execute('SELECT * FROM Teams WHERE id=?', (team_id,))
        result = self.return_arr_dict()
        return result

    def update_new_team_user(self, team_id, user_email, role='tester'):
        curr_users_data = json.loads(
            self.select_team_by_id(team_id)[0]['users'])
        curr_user = self.select_user_by_email(user_email)[0]
        curr_users_data[curr_user['id']] = role
        self.cursor.execute(
            '''UPDATE Teams SET users=? WHERE id=?''',
            (json.dumps(curr_users_data), team_id))
        self.conn.commit()
        return

    def get_log_by_team_id(self, team_id):
        self.cursor.execute('SELECT * FROM Logs WHERE team_id=?', (team_id,))
        result = self.return_arr_dict()
        return result

    def insert_log(self, team_id, description, date, user_id):
        self.cursor.execute(
            '''INSERT INTO Logs(`id`,`team_id`,`description`,`date`,`user_id`) 
               VALUES (?,?,?,?,?)''',
            (gen_uuid(), team_id, description, date, user_id)
        )
        self.conn.commit()
        return

    def select_user_teams(self, user_id):
        self.cursor.execute(
            'SELECT * FROM Teams WHERE admin_id=? or users like "%" || ? || "%" ',
            (user_id, user_id))
        result = self.return_arr_dict()
        return result

    def select_user_team_members(self, user_id):
        teams = self.select_user_teams(user_id)
        members = []
        for team in teams:
            current_team = self.select_team_by_id(team['id'])[0]
            users = json.loads(current_team['users'])
            members += [user for user in users]
        members = list(set(members))

        members_info = []
        for member in members:
            members_info += self.select_user_by_id(member)
        return members_info

    def insert_new_project(self, name, description, project_type, scope,
                           start_date, end_date, auto_archive, testers,
                           teams, admin_id):
        project_id = gen_uuid()
        self.cursor.execute(
            "INSERT INTO Projects(`id`,`name`,`description`,`type`,`scope`,`start_date`,"
            "`end_date`,`auto_archive`,`status`,`testers`,`teams`,`admin_id`) "
            "VALUES (?,?,?,?,?,?,?,?,1,?,?,?)",
            (project_id,
             name,
             description,
             project_type,
             scope,
             int(start_date),
             int(end_date),
             int(auto_archive),
             json.dumps(testers),
             json.dumps(teams),
             admin_id)  # initiation of json dict
        )
        self.conn.commit()
        return project_id

    def check_admin_team(self, team_id, user_id):
        team = self.select_team_by_id(team_id)
        if not team:
            return False
        team = team[0]
        users = json.loads(team['users'])
        return team['admin_id'] == user_id or (
                user_id in users and users[user_id] == 'admin')

    def delete_user_from_team(self, team_id, user_id):
        self.cursor.execute('SELECT * FROM Teams WHERE id=?', (team_id,))
        team = self.return_arr_dict()
        if not team:
            return 'Team does not exist.'
        team = team[0]
        if team['admin_id'] == user_id:
            return 'Can\'t kick team creator.'
        users = json.loads(team['users'])
        if user_id not in users:
            return 'User is not in team'
        del users[user_id]

        self.cursor.execute(
            "UPDATE Teams set `users`=? WHERE id=?",
            (json.dumps(users), team_id)
        )
        self.conn.commit()

        return ''

    def devote_user_from_team(self, team_id, user_id):

        self.cursor.execute('SELECT * FROM Teams WHERE id=?', (team_id,))
        team = self.return_arr_dict()
        if not team:
            return 'Team does not exist.'
        team = team[0]
        if team['admin_id'] == user_id:
            return 'Can\'t devote team creator.'
        users = json.loads(team['users'])
        if user_id not in users:
            return 'User is not in team'
        if users[user_id] != 'admin':
            return 'User is not team administrator.'

        users[user_id] = 'tester'

        self.cursor.execute(
            "UPDATE Teams set `users`=? WHERE id=?",
            (json.dumps(users), team_id)
        )
        self.conn.commit()

        return ''

    def set_admin_team_user(self, team_id, user_id):

        self.cursor.execute('SELECT * FROM Teams WHERE id=?', (team_id,))
        team = self.return_arr_dict()
        if not team:
            return 'Team does not exist.'
        team = team[0]
        if team['admin_id'] == user_id:
            return 'Can\'t devote team creator.'
        users = json.loads(team['users'])
        if user_id not in users:
            return 'User is not in team'
        if users[user_id] != 'tester':
            return 'User is not team tester.'

        if users[user_id] == 'admin':
            return 'User is already admin.'

        users[user_id] = 'admin'

        self.cursor.execute(
            "UPDATE Teams set `users`=? WHERE id=?",
            (json.dumps(users), team_id)
        )
        self.conn.commit()
        return ''

    def select_team_projects(self, team_id):
        self.cursor.execute(
            '''SELECT * FROM Projects WHERE teams LIKE '%' || ? || '%' ''',
            (team_id,))
        result = self.return_arr_dict()
        return result

    def select_user_projects(self, user_id):
        projects = []
        user_teams = self.select_user_teams(user_id)
        for team in user_teams:
            team_projects = self.select_team_projects(team['id'])
            for team_project in team_projects:
                found = 0
                for added_project in projects:
                    if added_project['id'] == team_project['id']:
                        found = 1
                if not found:
                    projects.append(team_project)
        self.cursor.execute(
            '''SELECT * FROM Projects WHERE testers LIKE '%' || ? || '%' or admin_id=? ''',
            (user_id, user_id))
        user_projects = self.return_arr_dict()
        for user_project in user_projects:
            found = 0
            for added_project in projects:
                if added_project['id'] == user_project['id']:
                    found = 1
            if not found:
                projects.append(user_project)
        return projects

    def check_user_project_access(self, project_id, user_id):
        user_projects = self.select_user_projects(user_id)
        for user_project in user_projects:
            if user_project['id'] == project_id:
                return user_project
        return None

    def select_project_hosts(self, project_id):
        self.cursor.execute(
            '''SELECT * FROM Hosts WHERE project_id=? ORDER BY ip ASC''',
            (project_id,))
        result = self.return_arr_dict()
        return result

    def select_ip_hostnames(self, host_id):
        self.cursor.execute(
            '''SELECT * FROM Hostnames WHERE host_id=?''',
            (host_id,))
        result = self.return_arr_dict()
        return result

    def select_ip_from_project(self, project_id, ip):
        self.cursor.execute(
            '''SELECT * FROM Hosts WHERE project_id=? and ip=?''',
            (project_id, ip))
        result = self.return_arr_dict()
        return result

    def insert_new_ip(self, project_id, ip, user_id, comment=''):
        ip_id = gen_uuid()
        self.cursor.execute(
            '''INSERT INTO Hosts(`id`,`project_id`,`ip`,`comment`,`user_id`,`threats`) 
               VALUES (?,?,?,?,?,'[]')''',
            (ip_id, project_id, ip, comment, user_id)
        )
        self.conn.commit()
        return ip_id

    def select_project_host(self, project_id, host_id):
        self.cursor.execute(
            '''SELECT * FROM Hosts WHERE id=? AND project_id=?''',
            (host_id, project_id,))
        result = self.return_arr_dict()
        return result

    def update_host_description(self, host_id, comment, threats):
        self.cursor.execute(
            '''UPDATE Hosts SET comment=?,threats=? WHERE id=?''',
            (comment, json.dumps(threats), host_id))
        self.conn.commit()
        return

    def delete_host(self, host_id):
        self.cursor.execute(
            '''DELETE FROM Hosts WHERE id=?''',
            (host_id,))
        self.conn.commit()
        return

    def insert_host_port(self, host_id, port, is_tcp, service, description,
                         user_id):
        port_id = gen_uuid()
        self.cursor.execute(
            '''INSERT INTO Ports(
            `id`,`host_id`,`port`,`is_tcp`,`service`,`description`,`user_id`) 
               VALUES (?,?,?,?,?,?,?)''',
            (port_id, host_id, port, int(is_tcp), service, description, user_id)
        )
        self.conn.commit()
        return port_id

    def select_host_ports(self, host_id):
        self.cursor.execute(
            '''SELECT * FROM Ports WHERE host_id=? ORDER BY port''',
            (host_id,))
        result = self.return_arr_dict()
        return result

    def find_ip_hostname(self, host_id, hostname):
        self.cursor.execute(
            '''SELECT * FROM Hostnames WHERE host_id=? AND hostname=?''',
            (host_id, hostname))
        result = self.return_arr_dict()
        return result

    def insert_hostname(self, host_id, hostname, description, user_id):
        hostname_id = gen_uuid()
        self.cursor.execute(
            '''INSERT INTO Hostnames(
            `id`,`host_id`,`hostname`,`description`,`user_id`) 
               VALUES (?,?,?,?,?)''',
            (hostname_id, host_id, hostname, description, user_id)
        )
        self.conn.commit()
        return hostname_id

    def check_host_hostname_id(self, host_id, hostname_id):
        self.cursor.execute(
            '''SELECT * FROM Hostnames WHERE host_id=? AND id=?''',
            (host_id, hostname_id))
        result = self.return_arr_dict()
        return result

    def delete_hostname(self, hostname_id):
        self.cursor.execute(
            '''DELETE FROM Hostnames WHERE id=?''',
            (hostname_id,))
        self.conn.commit()
        return

    def check_port_in_project(self, project_id, port_id):
        self.cursor.execute(
            '''SELECT project_id FROM Hosts WHERE 
            id=(SELECT host_id FROM Ports WHERE id=? LIMIT 1) 
            and project_id=? ''',
            (port_id, project_id))
        result = self.return_arr_dict()
        return result != []

    def select_port(self, port_id):
        self.cursor.execute(
            '''SELECT * FROM Ports WHERE id=?''',
            (port_id,))
        result = self.return_arr_dict()
        return result

    def select_hostname(self, hostname_id):
        self.cursor.execute(
            '''SELECT * FROM Hostnames WHERE id=?''',
            (hostname_id,))
        result = self.return_arr_dict()
        return result

    def insert_new_issue(self, name, description, url_path, cvss, user_id,
                         services, status, project_id):
        issue_id = gen_uuid()
        self.cursor.execute(
            '''INSERT INTO Issues(
            `id`,`name`,`description`,`url_path`,`cvss`,`user_id`,`services`,`status`, `project_id`) 
               VALUES (?,?,?,?,?,?,?,?,?)''',
            (issue_id, name, description, url_path, cvss, user_id,
             json.dumps(services), status, project_id)
        )
        self.conn.commit()
        return issue_id

    def select_project_issues(self, project_id):
        self.cursor.execute(
            '''SELECT * FROM Issues WHERE project_id=? ORDER BY cvss DESC''',
            (project_id,))
        result = self.return_arr_dict()
        return result

    def select_host_by_port_id(self, port_id):
        self.cursor.execute(
            '''SELECT * FROM Hosts WHERE 
            id=(SELECT host_id FROM Ports WHERE id=?)''',
            (port_id,))
        result = self.return_arr_dict()
        return result

    def select_issue(self, issue_id):
        self.cursor.execute(
            '''SELECT * FROM Issues WHERE id=?''',
            (issue_id,))
        result = self.return_arr_dict()
        return result

    def update_issue(self, issue_id, name, description, url_path, cvss,
                     services, status, cve, cwe):
        self.cursor.execute(
            '''UPDATE Issues SET name=?, description=?, url_path=?, cvss=?, 
            services=?, status=?, cve=?, cwe=? WHERE id=?''',
            (name, description, url_path, cvss,
             json.dumps(services), status, cve, cwe, issue_id)
        )
        self.conn.commit()

    def check_hostname_port_in_issue(self, hostname_id, port_id, issue_id):
        current_issue = self.select_issue(issue_id)[0]
        services = json.loads(current_issue['services'])
        if port_id not in services:
            return False
        if hostname_id not in services[port_id]:
            return False
        return True

    def insert_new_poc(self, port_id, description, file_type, filename,
                       issue_id,
                       user_id, hostname_id, poc_id=gen_uuid()):
        self.cursor.execute(
            '''INSERT INTO PoC(
            `id`,`port_id`,`description`,`type`,`filename`,
            `issue_id`,`user_id`,`hostname_id`) 
               VALUES (?,?,?,?,?,?,?,?)''',
            (poc_id, port_id, description, file_type, filename, issue_id,
             user_id,
             hostname_id)
        )
        self.conn.commit()
        return poc_id

    def select_issue_pocs(self, issue_id):
        self.cursor.execute(
            '''SELECT * FROM PoC WHERE issue_id=?''',
            (issue_id,))
        result = self.return_arr_dict()
        return result

    def select_poc(self, poc_id):
        self.cursor.execute(
            '''SELECT * FROM PoC WHERE id=?''',
            (poc_id,))
        result = self.return_arr_dict()
        return result

    def delete_poc(self, poc_id):
        self.cursor.execute(
            '''DELETE FROM PoC WHERE id=?''',
            (poc_id,))
        self.conn.commit()
        return

    def delete_issue(self, issue_id):
        self.cursor.execute(
            '''DELETE FROM Issues WHERE id=?''',
            (issue_id,))
        self.conn.commit()
        return

    def insert_new_network(self, ip, mask, asn, comment, project_id, user_id,
                           is_ipv6):
        network_id = gen_uuid()
        self.cursor.execute(
            '''INSERT INTO Networks(
            `id`,`ip`,`mask`,`comment`,`project_id`,`user_id`,`is_ipv6`,`asn`) 
               VALUES (?,?,?,?,?,?,?,?)''',
            (network_id, ip, mask, comment, project_id, user_id, int(is_ipv6),
             asn)
        )
        self.conn.commit()
        return network_id

    def select_project_networks(self, project_id):
        self.cursor.execute(
            '''SELECT * FROM Networks WHERE project_id=?''',
            (project_id,))
        result = self.return_arr_dict()
        return result

    def delete_network(self, network_id):
        self.cursor.execute(
            '''DELETE FROM Networks WHERE id=?''',
            (network_id,))
        self.conn.commit()
        return

    def select_network(self, network_id):
        self.cursor.execute(
            '''SELECT * FROM Networks WHERE id=?''',
            (network_id,))
        result = self.return_arr_dict()
        return result

    def insert_new_cred(self, login, password_hash, hash_type,
                        cleartext_passwd, description, source,
                        services, user_id, project_id):
        cred_id = gen_uuid()
        self.cursor.execute(
            '''INSERT INTO Credentials(
            `id`,`login`,`hash`,`hash_type`,`cleartext`,
            `description`,`source`,`services`, `user_id`, `project_id`)
             VALUES (?,?,?,?,?,?,?,?,?,?)''',
            (cred_id, login, password_hash, hash_type, cleartext_passwd,
             description, source, json.dumps(services), user_id, project_id)
        )
        self.conn.commit()
        return cred_id

    def select_project_creds(self, project_id):
        self.cursor.execute(
            '''SELECT * FROM Credentials WHERE project_id=?''',
            (project_id,))
        result = self.return_arr_dict()
        return result

    def select_creds(self, creds_id):
        self.cursor.execute(
            '''SELECT * FROM Credentials WHERE id=?''',
            (creds_id,))
        result = self.return_arr_dict()
        return result

    def delete_creds(self, creds_id):
        self.cursor.execute(
            '''DELETE FROM Credentials WHERE id=?''',
            (creds_id,))
        self.conn.commit()
        return

    def update_creds(self, creds_id, login, password_hash, hash_type,
                     cleartext_passwd, description, source,
                     services):
        self.cursor.execute(
            '''UPDATE Credentials SET `login`=?,`hash`=?,`hash_type`=?,`cleartext`=?,
            `description`=?,`source`=?,`services`=? WHERE id=?''',
            (login, password_hash, hash_type, cleartext_passwd,
             description, source, json.dumps(services), creds_id)
        )
        self.conn.commit()
        return

    def select_project_notes(self, project_id):
        self.cursor.execute(
            '''SELECT * FROM Notes WHERE project_id=?''',
            (project_id,))
        result = self.return_arr_dict()
        return result

    def insert_new_note(self, project_id, name, user_id):
        note_id = gen_uuid()
        self.cursor.execute(
            '''INSERT INTO Notes(
            `id`,`project_id`,`name`,`text`,`user_id`) 
               VALUES (?,?,?,'',?)''',
            (note_id, project_id, name, user_id)
        )
        self.conn.commit()
        return note_id

    def update_note(self, note_id, text_data, project_id):
        self.cursor.execute(
            '''UPDATE Notes SET `text`=? WHERE `id`=? AND `project_id`=?''',
            (text_data, note_id, project_id)
        )
        self.conn.commit()
        return

    def delete_note(self, note_id, project_id):
        self.cursor.execute(
            '''DELETE FROM Notes WHERE `id`=? AND `project_id`=?''',
            (note_id, project_id)
        )
        self.conn.commit()
        return

    def insert_new_file(self, file_id, project_id, filename, description,
                        services, filetype, user_id):
        self.cursor.execute(
            '''INSERT INTO Files(
            `id`,`project_id`,`filename`,`description`,
            `services`,`type`,`user_id`) VALUES (?,?,?,?,?,?,?)''',
            (file_id, project_id, filename, description,
             json.dumps(services), filetype, user_id)
        )
        self.conn.commit()
        return

    def select_files(self, file_id):
        self.cursor.execute(
            '''SELECT * FROM Files WHERE id=?''',
            (file_id,))
        result = self.return_arr_dict()
        return result

    def select_project_files(self, project_id):
        self.cursor.execute(
            '''SELECT * FROM Files WHERE project_id=?''',
            (project_id,))
        result = self.return_arr_dict()
        return result

    def delete_file(self, file_id):
        self.cursor.execute(
            '''DELETE FROM Files WHERE id=?''',
            (file_id,))
        self.conn.commit()
        return

    def update_project_status(self, project_id, status):
        # TODO: add data types to functions status: int
        self.cursor.execute(
            '''UPDATE Projects SET status=? WHERE `id`=? ''',
            (status, project_id)
        )
        self.conn.commit()
        return

    def update_project_settings(self, project_id, name, description,
                                project_type, scope,
                                start_date, end_date, auto_archive, testers,
                                teams):
        self.cursor.execute(
            "UPDATE Projects set `name`=?,`description`=?,`type`=?,"
            "`scope`=?,`start_date`=?,"
            "`end_date`=?,`auto_archive`=?,"
            "`testers`=?,`teams`=? WHERE `id`=? ",
            (name,
             description,
             project_type,
             scope,
             int(start_date),
             int(end_date),
             int(auto_archive),
             json.dumps(testers),
             json.dumps(teams),
             project_id)
        )
        self.conn.commit()
        return

    def update_project_autoarchive(self, project_id, autoarchive):
        self.cursor.execute(
            '''UPDATE Projects SET auto_archive=? WHERE `id`=? ''',
            (autoarchive, project_id)
        )
        self.conn.commit()
        return
