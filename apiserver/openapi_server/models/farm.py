# {
#   "category": {
#     "id": 0,
#     "name": "string"
#   },
#   "id": 0,
#   "location": [
#     {
#       "lat": 23.45945,
#       "lon": -34.25435
#     }
#   ],
#   "name": "Hacienda Kirumba",
#   "tags": [
#     {
#       "id": 0,
#       "name": "string"
#     }
#   ]
# }

# coding: utf-8

from __future__ import absolute_import

from datalore.client import FirestoreClient, DataAlreadyExistsException
from openapi_server.models.base_model_ import Model
from openapi_server import util


class Farm(Model):
    """
        Model to transpire URL data
    """

    def __init__(self, category=None, location=None, name=None, tags=None):
        """
        Coordinates
        Args:
            category:
            location:
        """
        self.openapi_types = dict(category=dict, location=dict, name=str, tags=list)
        self.attribute_map = dict(category='category', location='location', name='name', tags='tags')
        self._category = category
        self._location = location
        self._name = name
        self._tags = tags

    @classmethod
    def from_dict(cls, dictionary) -> 'Farm':
        """
        Serialise to a dictionary
        Args:
            dictionary:
        Returns: A dict object dict()
        """
        return util.deserialize_model(dictionary, cls)

    @property
    def category(self):
        return self._category

    @category.setter
    def category(self, category):
        self._category = category

    @property
    def location(self):
        return self._location

    @location.setter
    def location(self, location):
        self._location = location

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        self._name = name

    @property
    def tags(self):
        return self._tags

    @tags.setter
    def tags(self, tags):
        self._tags = tags
