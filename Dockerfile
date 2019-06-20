FROM python:3.7-alpine
WORKDIR /app
COPY requirements.txt requirements.txt
RUN apk add --no-cache --virtual virtual gcc musl-dev libffi-dev openssl-dev python3-dev && \
    pip install -r requirements.txt && \
    apk del virtual
