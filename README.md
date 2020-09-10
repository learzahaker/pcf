

<!-- TODO: PROJECT LOGO -->
<br />
<p align="center">
  <!--
  <a href="https://github.com/github_username/repo">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
  -->
  <h3 align="center">Web-Hack-Toolkit</h3>

  <p align="center">
    Web application to help security specialist manage and share project information.
    <br />
    <a href="https://gitlab.com/invuls/pentest-projects/web-hack-toolkits/-/wikis/home"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://199.192.28.132:55666/">View Demo</a>
    ·
    <a href="https://gitlab.com/invuls/pentest-projects/web-hack-toolkits/issues">Report Bug</a>
    ·
    <a href="https://gitlab.com/invuls/pentest-projects/web-hack-toolkits/issues">Request Feature</a>
  </p>
</p>






# 🤔 What is this?
1. Сreate personal account
2. Create security team
3. Add members to team
4. Create testing project
5. ???
6. Profit!

<p align="center">
    <img src="https://i.ibb.co/71Jc1Ly/main-page.png">
</p><br>

Web-Hack-Toolkit **only** job is to help security specialists to save project information and share it with your teammates.

# ✨ Features
* 🔬 You can create private or team projects!
* 💼 Team moderation.
* 🛠 Multiple tools integration support! Such as Nmap/Masscan, Nikto, Nessus and Acunetix! 
* 😁 Super-User-Friendly design.

## ‼️ Important Links

| Installation Guide | Documentation | Telegram |
| ------------------ | ------------- | ------- |
| 📖 [Installation Guide](https://gitlab.com/invuls/pentest-projects/web-hack-toolkits#-full-installation-guide) | 📚 [Documentation](https://github.com/RustScan/RustScan/issues/89) | 💬 [Telegram](https://t.me/pentect_collab_tool)

## 🙋 Table of Contents
* 📖 [Installation Guide](https://gitlab.com/invuls/pentest-projects/web-hack-toolkits#-full-installation-guide)
* 🐋 [Docker Usage](https://gitlab.com/invuls/pentest-projects/web-hack-toolkits#-full-installation-guide)
* 🦜 [Telegram](https://t.me/pentect_collab_tool)
* 🤸 [Usage](https://gitlab.com/invuls/pentest-projects/web-hack-toolkits#-usage)
* 🎪 [Community](https://gitlab.com/invuls/pentest-projects/web-hack-toolkits#-community)

# 🔭 Why PCF?
Why use notepad? <br>
Why scatter files into folders, and then remember what file it is? <br>
Why send a lot of messages to colleagues on the project, and then try to find the right one? <br><br> 
![image](https://i.ibb.co/f4d2RgQ/issues.png)

**Indeed, for all this, you can use the Pentest Collaboration Framework - an opensource and portable toolkit for automating routine processes when carrying out various works for testing!**

## 📊 PCF vs Lair vs Dradis vs Faraday vs AttackForge

| **Name**  | PCF | Lair | Dradis | Faraday | AttackForge
| -------------- | --- | -------- | ---- | ------- | ------
| Portable | ✅ | ❌ | ❌ | ❌ | ❌    
| Cross-platform | ✅ | ✅ | ✅ | ✅ | ❌
| Free | ✅ | ✅ | ❌✅ | ❌✅ | ❌✅  
| Data export | ✅ | ❌✅ | ✅ | ✅ | ✅
| Chat | ✅ | ❌ | ❌ | ❌ | ✅ 
| Made for sec specialists, not managers | ✅ | ✅ | ✅ | ✅ | ❌
| Report generation | ❌(TODO)| ❌ | ✅ | ✅ | ✅
| API | ❌(TODO) | ❌✅ | ✅ | ✅ | ✅
# 📖 Full Installation Guide
**You need only Python3**. 

## 🖥️ Windows / Linux

Download project:
```sh
git clone https://gitlab.com/invuls/pentest-projects/web-hack-toolkits/
```

Go to folder:
```bash
cd web-hack-toolkit
```

Install deps:
```bash
pip3 install -r requirements.txt
```

Run initiation script:
```bash
python3 new_initiation.py
```

Edit configuration:
```bash
nano configuration/settings.ini
```

Run:
```bash
python3 app.py
```

## ☁️ Heroku



### 👍 Easy way

Deploy from our github repository:

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new-app?template=https://gitlab.com/invuls/pentest-projects/web-hack-toolkits)

### 😓 Harder way

Clone this repository to github

Go to https://dashboard.heroku.com/new-app?template=your_github_repo_link

Careful! Check last commit github commit data.

### 💀 Impossible!

Full official tutorial: https://devcenter.heroku.com/articles/git

Install heroku CLI-app from https://devcenter.heroku.com/articles/heroku-cli


Authorize to heroku:
```bash
heroku login -i
```
Clone repository:
```bash
git clone https://gitlab.com/invuls/pentest-projects/web-hack-toolkits
```
Go to folder:
```bash
cd web-hack-toolkits
```
Create heroku repo (if you didn't do it before):
```bash
heroku create
```

.. or set repo name:
```bash
heroku git:remote -a heroku_repo_name
```
And push changes to heroku:
```bash
git push heroku master
```
Go to URL:
```
https://app_name.herokuapp.com/
```

## Docker :whale:

_Will be added later!_

#### To get started:

_Will be added later!_

#### To build your own image:

_Will be added later!_
## 🍺 HomeBrew

_Will be added later!_


## 🦊 Community Distributions

_Will be added later!_


# 🤸 Usage

Default port (check config): 5000
Default ip (if run at localhost): 127.0.0.1 




1. Register at http(s)://\<ip\>:\<port\>/register

2. Login at http(s)://\<ip\>:\<port\>/login

3. Create team (if need) at http(s)://\<ip\>:\<port\>/create_team

4. Create project at http(s)://\<ip\>:\<port\>/new_project

5. Enjoy your hacking process! 👨‍💻

## 🖼️ Gallery


|||
:-------------------------:|:-------------------------:
![image](https://i.ibb.co/y4qNYJr/team.png)|![image](https://i.ibb.co/8DyCK1J/2020-08-26-014024.png)
Team information|Projects list
![image](https://i.ibb.co/f4d2RgQ/issues.png)|![image](https://i.ibb.co/mDrNQYQ/2020-08-26-014024.png)
Project: issues|Project: host page
![image](https://i.ibb.co/rdCNZqv/2020-08-26-014024.png)|![image](https://i.ibb.co/r0PPbwV/2020-08-26-014024.png)
Project: hosts|Project:services
![image](https://i.ibb.co/17R9tjP/2020-08-26-021037.png)|![image](https://i.ibb.co/fMyfHmb/2020-08-26-021037.png)
Project: issue info|Project: issue info (PoC)
![image](https://i.ibb.co/CtFX3nD/2020-08-26-014024.png)|![image](https://i.ibb.co/6vSddfD/2020-08-26-021037.png)
Project: networks|Project: files
![image](https://i.ibb.co/P6HB4kD/2020-08-26-235628.png)|![image](https://i.ibb.co/6FBhh1p/2020-08-26-235628.png)
Project: tools (may be changed)|Project: found credentials
![image](https://i.ibb.co/8xmZyNL/2020-08-26-235628.png)|![image](https://i.ibb.co/g3rD3nj/2020-08-26-235628.png)
Project: testing notes|Project: chats
![image](https://i.ibb.co/3Y1psdS/2020-08-26-235628.png)|![image](https://i.ibb.co/NCmRJf9/2020-08-26-235628.png)
Project: settings|Project: reports (in development process)



## ⚠️ WARNING

This program, by default, uses 5000 port and allows everyone to register and use it, so you need to set correct firewall & network rules.



#### 🚨 Default settings

This program, by default, uses 5000 port and allows everyone to register and use it, so you need to set correct firewall & network rules.

#### 🔌 Initiation logic

Careful with new_initiation script! It makes some important changes with filesystem:

1. Renames database /configuration/database.sqlite3 
2. Regenerates SSL certificates
3. Regenerates session key.
4. Creates new empty /configuration/database.sqlite3 database
5. Creates /tmp_storage/ folder


# 🎪 Community

We are always looking for contributors. Whether that's spelling mistakes or major changes, your help is **wanted** and welcomed here.

Before contributing, read our [code of conduct](CODE_OF_CONDUCT.md).

TL;DR if you abuse members of our community you will be **perma-banned** 🤗


If you want to, solve the issue or comment on the issue for help.

The flow for contributing to open source software is:
* Fork the repo
* Make changes
* Pull request to the repo

And then comment on the issue that you've done.

Toolkit also has some `# TODO`'s in the codebase, which are meant more for the core team but we wouldn't say no to help with these issues.

If you have any feature suggestions or bugs, leave a GitLab issue. We welcome any and all support :D

We communicate over Telegram. [Click here](https://t.me/pentect_collab_tool) to join our Telegram community!



## Contributors ✨
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-0-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://site.com/"><img src="https://svgur.com/i/PTC.svg" width="100px;" alt=""/><br /><sub><b>Your name!</b></sub></a><br /></td>
      </tr>
  <tr>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
