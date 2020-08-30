import logging as logger
import os

from openapi_server import app

import googlecloudprofiler

try:
    if os.getenv('GAE_ENV', '').startswith('standard'):
        import google.cloud.logging as cloudlogging

        client = cloudlogging.Client()
        client.setup_logging(log_level=logger.INFO)
        cloud_handler = client.get_default_handler()

        googlecloudprofiler.start(verbose=3)
except (ValueError, NotImplementedError) as exc:
    print(str(exc))


if __name__ == '__main__':
    app.run(port=7070, host='localhost', debug=True
            ) if not os.getenv('GAE_ENV', '').startswith('standard') else app.run()


