# coding: utf-8

from __future__ import absolute_import

from datalore.client import FirestoreClient, DataAlreadyExistsException
from openapi_server.models.base_model_ import Model
from openapi_server import util


class Coordinate(Model):
    """
        Model to transpire URL data
    """

    def __init__(self, lat=None, lon=None):
        """
        Coordinates
        Args:
            lat:
            lon:
        """
        self.openapi_types = dict(lat=float, lon=float)
        self.attribute_map = dict(lat='lat', lon='lon')
        self._lat = lat
        self._lon = lon

    @classmethod
    def from_dict(cls, dictionary) -> 'Coordinate':
        """
        Serialise to a dictionary
        Args:
            dictionary:
        Returns: A dict object dict()
        """
        return util.deserialize_model(dictionary, cls)

    @property
    def lat(self):
        return self._lat

    @lat.setter
    def lat(self, lat):
        self._lat = lat

    @property
    def lon(self):
        return self._lon

    @lon.setter
    def lon(self, lon):
        self._lon = lon
