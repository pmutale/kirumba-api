import os
from logging.config import dictConfig
from unittest import mock
import connexion
from flask_cors import CORS
from google.cloud import firestore

from openapi_server import url_encoder

app = connexion.App(__name__, specification_dir='./openapi/')
app.app.secret_key = os.urandom(24)
app.app.config['SESSION_TYPE'] = 'filesystem'
app.add_api('openapi.yaml',
            arguments={'title': 'API: Kirumba'},
            pythonic_params=True)
app.app.json_encoder = url_encoder.JSONEncoder
CORS(app.app, resources={r"/*": {"origins": "*", "send_wildcard": "False"}})
