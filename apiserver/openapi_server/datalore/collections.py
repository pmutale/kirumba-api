import logging
import os


from openapi_server.datalore import track_start_en_stop
from openapi_server.datalore.client import DataAlreadyExistsException, FirestoreClient

logger = logging.getLogger(__name__)


class Config:
    def __init__(self, env):
        self.env = env


class Collections:
    config = Config(env=os.environ.get('GAE_ENV'))

    @track_start_en_stop
    def add_data(self, data, resource):
        data_id = '_'.join(data['name'].split(' ')).lower()
        reference = FirestoreClient(self.config).get_client().collection(resource).document(data_id)
        if reference.get().exists:
            raise DataAlreadyExistsException('Already exists')
        try:
            adding = reference.create(data)
            logger.info(adding)
            return f'{reference.id}', 200
        except Exception as err:
            logger.error(str(err), exc_info=True)
