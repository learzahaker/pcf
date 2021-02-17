FROM python:3.9
ADD . /code
WORKDIR /code
RUN pip install -r requirements_unix.txt
RUN if [ ! -e "/code/configuration/database.sqlite3" ]; then echo 'DELETE_ALL' | python new_initiation.py; fi
RUN touch 1234
CMD python app.py