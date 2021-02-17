FROM python:3.9
WORKDIR /code
COPY . .
RUN pip install -r /code/requirements_unix.txt
RUN if [ ! -e "/code/configuration/database.sqlite3" ]; then echo 'DELETE_ALL' | python new_initiation.py; fi
CMD python app.py