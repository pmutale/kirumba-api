import os
from unittest import mock

import google.auth.credentials
from google.cloud import firestore


class DataAlreadyExistsException(Exception):
    """Already exist data"""
    pass


class FirestoreClient:
    def __init__(self, config):
        self.client = None
        self.config = config

    def get_client(self):
        if self.config.env.startswith('standard'):
            self.client = firestore.Client()
        else:
            os.environ["FIRESTORE_DATASET"] = "kirumba-app-dev"
            os.environ["FIRESTORE_EMULATOR_HOST"] = "localhost:7077"
            os.environ["FIRESTORE_EMULATOR_HOST_PATH"] = "localhost:7077/firestore"
            os.environ["FIRESTORE_HOST"] = "http://localhost:7077"
            os.environ["FIRESTORE_PROJECT_ID"] = "kirumba-app-dev"
            credentials = mock.Mock(spec=google.auth.credentials.Credentials)
            self.client = firestore.Client(project=os.environ.get('PROJECT_ID'), credentials=credentials)
        return self.client
