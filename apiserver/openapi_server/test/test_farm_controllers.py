import json
from unittest.mock import patch, MagicMock

from openapi_server.test import BaseTestCase


# URL = "https://www.google.com"
# SHORT_CODE = "gooL1_"


class CustomAssertMethods(BaseTestCase):
    def assert409(self, response, message):
        """ Already in use"""
        self.assertStatus(response, 409, message)

    def assert412(self, response, message):
        """ Invalid short code"""
        self.assertStatus(response, 412, message)


class TestDefaultController(BaseTestCase):
    """DefaultController integration test stubs"""

    @patch('openapi_server.datalore.client.FirestoreClient.get_client')
    @patch('connexion.decorators.security.get_authorization_info')
    def test_add_farm(self, get_authorization_info_mock, get_client):
        """Test case for shortening a url"""

        headers = {"Content-Type": "application/json"}
        data = {
            "category": {"id": 0, "name": "string"},
            "location": {"lat": 23.45945, "lon": -34.25435},
            "name": "Hacienda Kirumba",
            "tags": [{"id": 0, "name": "string"}]
        }
        response = self.client.open(
            "/v1/farms",
            method="POST",
            headers=headers,
            data=json.dumps(data),
            content_type="application/json",
        )
        if response.status_code == 409:
            CustomAssertMethods().assert409(
                response=response,
                message=f'Response body is: {response.data.decode("utf-8")}',
            )
        elif response.status_code == 400:
            self.assert400(
                response, f'Response body is : {response.data.decode("utf-8")}'
            )
        elif response.status_code == 412:
            CustomAssertMethods().assert412(
                response, f'Response body is : {response.data.decode("utf-8")}'
            )
        elif response.status_code == 200:
            self.assert200(
                response, f'Response body is : {response.data.decode("utf-8")}'
            )
