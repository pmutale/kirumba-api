FROM python:3.11.0a5-alpine AS base
# g++ => grpcio, rest are for other python and google related packages
RUN apk update && apk add gcc libc-dev make git libffi-dev openssl-dev python3-dev libxml2-dev libxslt-dev g++

# Getting organised
WORKDIR /usr/src/app
RUN mkdir -p /usr/src/app
COPY ./requirements.txt /usr/src/app/

# Load the service account
RUN mkdir -p /usr/src/app/service_accounts
COPY ./service_accounts/kirumba-app-dev.json /usr/src/app/service_accounts/

# Install requirements with 2020 resolver and copy codebase to app/*
RUN python3 -m  pip install -r requirements.txt --no-binary :grpcio: --use-feature=2020-resolver
COPY ./apiserver /usr/src/app

EXPOSE 7000
ENTRYPOINT ["python3"]

# Run the flask application
CMD ["-m", "openapi_server", "main"]
