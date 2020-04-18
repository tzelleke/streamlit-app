FROM python:3.7-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DEBUG 0

#RUN apk update \
#    && apk add --virtual build-deps gcc python3-dev musl-dev

# install psycopg2
#RUN apk update \
#    && apk add --virtual build-deps gcc python3-dev musl-dev \
#    && apk add postgresql-dev \
#    && pip install psycopg2 \
#    && apk del build-deps

COPY ./requirements.txt .
RUN pip install --disable-pip-version-check --no-cache-dir -r requirements.txt

COPY ./config /.streamlit
COPY ./app .

#RUN adduser -D streamlit
#USER streamlit

CMD streamlit hello
