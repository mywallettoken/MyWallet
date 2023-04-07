FROM python:3

WORKDIR /app

COPY ./src /app

RUN pip install --upgrade pip
RUN pip install python-dotenv
RUN pip install Flask
RUN pip install web3

CMD [ "python", "index.py" ]
