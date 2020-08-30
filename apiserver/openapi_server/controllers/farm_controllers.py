import secrets
import string
from datetime import datetime

import connexion
from flask import make_response, jsonify, redirect

from datalore.collections import Collections
from openapi_server.models import coordinate, farm


def add_farm():
    request = connexion.request
    if request.is_json:
        return Collections().add_data(request.get_json(), 'farm')


def add_new_lot():
    request = connexion.request
    if request.is_json:
        return Collections().add_data(request.get_json(), 'lot')


def get_farm():
    pass


def record_pick_routine():
    pass


def get_lot():
    pass


def edit_routine():
    pass


def delete_farm():
    pass


def get_egg():
    pass