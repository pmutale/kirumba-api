# API: KIRUMBA

## Requirements
Python 3.5.2+

## App Online, Lazy?

To test live server

 visit [Google App Engine AppSpot](https://kirumba.appspot.com/v1/ui/)

## Usage
To run the server, please execute the following from the root directory:

```
$ git clone git@github.com:pmutale/kirumba-api.git
$ cd shorten-url/
$ python3 -m venv venv
$ . venv/bin/activate
$ pip install -r requirements.txt
$ python3 -m openapi_server
```

and open your browser to here:

```
http://localhost:8080/v1/ui/
```

To run unit tests:

```
$ python3 -m unittest openapi_server.test.test_shorten_url_controllers.TestDefaultController
```


## Running with Docker

To run the server on a Docker container, please execute the following from the root directory:

```bash
# building the image
$ docker build -t openapi_server .

# starting up a container
$ docker run -p 8080:8080 openapi_server

# Using the make file [builds and runs the docker instance]
$ make build && make run
```

## Creating an `.env` file

If you intend to use the API, you will definately need to create an environmental variables file before you 
run the instance
Please include the following environment keys

```dotenv
GOOGLE_APPLICATION_CREDENTIALS=/usr/src/app/service_accounts/service-account-example.json  # Replace
GAE_ENV=default
GAE_SERVICE=gae
JWT_ISSUER=issuer_name@example.gserviceaccount.com  # Replace with isuer
JWT_SECRET=secret12key # Replace with secret
JWT_LIFETIME_SECONDS=600
PROJECT_ID=kirumba-app-dev 
```
