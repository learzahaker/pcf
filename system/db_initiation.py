import os
import logging

import sqlite3

from system.crypto_functions import random_string

import system.config_load

try:
    db_path = system.config_load.config_dict()['database']['path']
except Exception as e:
    logging.error(e)
    logging.info(system.config_load.config_dict())


def create_db():
    if os.path.isfile(db_path):
        new_db_path = db_path + '.' + random_string() + '.old'
        os.rename(db_path, new_db_path)
        logging.info('Moved old db from {} to {}'.format(db_path, new_db_path))

    try:
        conn = sqlite3.connect(db_path)
    except Exception as e:
        logging.error(e)
        return

    cursor = conn.cursor()

    # create table - Users

    cursor.execute('''CREATE TABLE Users
                 (
                 [id] text PRIMARY KEY,
                 [fname] text default '',
                 [lname] text default '',
                 [email] text unique,
                 [company] text default '',
                 [password] text
                  )''')

    # create table - Teams
    cursor.execute('''CREATE TABLE Teams
                     (
                     [id] text PRIMARY KEY,
                     [admin_id] text, 
                     [name] text default '',
                     [description] text default '',
                     [users] text default '{}',
                     [projects] text default "[]",
                     [admin_email] text default ''
                      )''')

    # create table - Logs
    cursor.execute('''CREATE TABLE Logs
                         (
                         [id] text PRIMARY KEY,
                         [team_id] text, 
                         [description] text default '',
                         [date] integer,
                         [user_id] text
                          )''')

    # create table - Projects
    cursor.execute('''CREATE TABLE Projects
                             (
                             [id] text PRIMARY KEY,
                             [name] text default '', 
                             [description] text default '',
                             [type] text default 'pentest',
                             [scope] text default '',
                             [start_date] int,
                             [end_date] int,
                             [auto_archive] int default 0,
                             [status] int default 1,
                             [testers] text DEFAULT "[]",
                             [teams]  text DEFAULT "[]",
                             [admin_id] text
                              )''')

    # create table - Hosts
    cursor.execute('''CREATE TABLE Hosts
                                 (
                                 [id] text PRIMARY KEY,
                                 [project_id] text, 
                                 [ip] text,
                                 [comment] text default '',
                                 [user_id] text,
                                 [threats] text default "[]"
                                  )''')

    # create table - Hostnames
    cursor.execute('''CREATE TABLE Hostnames
                                     (
                                     [id] text PRIMARY KEY,
                                     [host_id] text, 
                                     [hostname] text,
                                     [description] text default '',
                                     [user_id] text
                                      )''')

    # create table - PoC
    cursor.execute('''CREATE TABLE PoC
                                         (
                                         [id] text PRIMARY KEY,
                                         [port_id] text default '',
                                         [description] text default '',
                                         [type] text default '',
                                         [filename] text default '',
                                         [issue_id] text,
                                         [user_id] text,
                                         [hostname_id] text default '0'
                                          )''')

    # create table - Ports
    cursor.execute('''CREATE TABLE Ports
                                             (
                                             [id] text PRIMARY KEY,
                                             [host_id] text ,
                                             [port] integer ,
                                             [is_tcp] integer default 1,
                                             [service] text default "other",
                                             [description] text default '',
                                             [user_id] text
                                              )''')

    # create table - Issues
    cursor.execute('''CREATE TABLE Issues
                                                 (
                                                 [id] text PRIMARY KEY,
                                                 [name] text default '',
                                                 [description] text default '',
                                                 [url_path] text default '',
                                                 [cvss] float default 0,
                                                 [cwe] int default 0,
                                                 [cve] text default '',
                                                 [user_id] text,
                                                 [services] text default '{}',
                                                 [status] text default '',
                                                 [project_id] text
                                                  )''')

    # create table - Networks
    cursor.execute('''CREATE TABLE Networks
                                                     (
                                                     [id] text PRIMARY KEY,
                                                     [ip] text ,
                                                     [mask] int,
                                                     [comment] text default '',
                                                     [project_id] text,
                                                     [user_id] text,
                                                     [is_ipv6] int default 0,
                                                     [asn] int default 0
                                                      )''')

    # create table - Files
    cursor.execute('''CREATE TABLE Files
                                                         (
                                                         [id] text PRIMARY KEY,
                                                         [project_id] text ,
                                                         [filename] text default '',
                                                         [description] text default '',
                                                         [services] text default '{}',
                                                         [type] text default 'binary',
                                                         [user_id] text
                                                          )''')

    # create table - Credentials
    cursor.execute('''CREATE TABLE Credentials
                                                             (
                                                             [id] text PRIMARY KEY,
                                                             [login] text default '',
                                                             [hash] text default '',
                                                             [hash_type] text default '',
                                                             [cleartext] text default '',
                                                             [description] text default '',
                                                             [source] text default '',
                                                             [services] text default '{}',
                                                             [user_id] text,
                                                             [project_id] text 
                                                              )''')

    # create table - Notes
    cursor.execute('''CREATE TABLE Notes
                                                                 (
                                                                 [id] text PRIMARY KEY,
                                                                 [project_id] text,
                                                                 [name] text default '',
                                                                 [text] text default '',
                                                                 [user_id] text
                                                                  )''')

    # create table - Chats
    cursor.execute('''CREATE TABLE Chats
                                                                     (
                                                                     [id] text PRIMARY KEY,
                                                                     [project_id] text,
                                                                     [name] text default '',
                                                                     [user_id] text
                                                                      )''')

    # create table - Messages
    cursor.execute('''CREATE TABLE Messages
                                                                         (
                                                                         [id] text PRIMARY KEY,
                                                                         [chat_id] text,
                                                                         [message] text default '',
                                                                         [user_id] text
                                                                          )''')

    conn.commit()
