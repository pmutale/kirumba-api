import os
from unittest import mock

import google.auth.credentials
from google.cloud import firestore


class DataAlreadyExistsException(Exception):
    """Already exist data"""
    pass


class FirestoreClient:
    def __init__(self, config):
        self.config = config

    def get_client(self):
        if self.config.env and self.config.env.startswith('standard'):
            return firestore.Client()
        credentials = mock.Mock(spec=google.auth.credentials.Credentials)
        return firestore.Client(project=os.environ.get('PROJECT_ID'), credentials=credentials)
