import datetime
import functools
import json
import os

import flask
import six
from connexion import request
from connexion.decorators.security import verify_apikey
from flask import redirect, make_response
from jose import JWTError, jwt
from werkzeug.exceptions import Unauthorized

from openapi_server import app


def validate_token_info():
    return 'i am'


@app.route('/oauth2-redirect.html')
def redirect_credentials():
    if not request.args.get('state', ''):
        response = make_response(json.dumps('Invalid state parameter.'), 401)
        response.headers['Content-Type'] = 'application/json'
        return response
    flask.session['state'] = request.args.get('state')
    flask.session['credentials'] = {
        'token_uri': 'https://oauth2.googleapis.com/token',
        'scopes': request.args.get('scope')}
    return redirect(f"/v1/ui/?{request.query_string.decode('utf-8')}")


def validate_scope():
    return 'OK', 200


def get_secret():
    return 'OK', 200


def validate_api_keys(key, scopes=None):
    return verify_apikey(key, loc= 'header', name='kirumba')


def validate_decode_token():
    return 'OK', 200


JWT_ISSUER = os.environ.get('JWT_ISSUER')
JWT_SECRET = os.environ.get('JWT_SECRET')
JWT_LIFETIME_SECONDS = 600
JWT_ALGORITHM = 'HS256'


def generate_token(user_id):
    timestamp = datetime.datetime.now().timestamp()
    payload = {
        "iss": JWT_ISSUER,
        "iat": int(timestamp),
        "exp": int(timestamp + JWT_LIFETIME_SECONDS),
        "sub": str(user_id),
    }

    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)


def decode_token(token):
    try:
        return jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
    except JWTError as e:
        six.raise_from(Unauthorized, e)
