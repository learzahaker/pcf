release: echo 'DELETE_ALL' | python new_initiation.py;
web: if [ ! -f ./configuration/database.sqlite3 ]; then python new_initiation.py heroku; fi; python app.py