import logging
import time

logger = logging.getLogger(__name__)


def track_start_en_stop(fn):
    def wrapper(slf, data, resource):
        timer_start = time.perf_counter()
        fn(slf, data, resource)
        timer_end = time.perf_counter()
        logger.info(f'Elapsed in {timer_end - timer_start:0.4f} seconds')
    return wrapper