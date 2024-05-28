import logging
from fastapi import UploadFile
from fastapi.responses import StreamingResponse
from PIL import Image
import io

# Configuração do logger
logger = logging.getLogger(__name__)

class BaseService:
    def __init__(self, repository) -> None:
        self._repository = repository

    def get_list(self, schema):
        logger.info(f"Fetching list with schema: {schema}")
        result = self._repository.read_by_options(schema)
        logger.info(f"Fetched {len(result)} items")
        return result

    def get_by_id(self, id: int):
        logger.info(f"Fetching item with ID: {id}")
        result = self._repository.read_by_id(id)
        if result:
            logger.info(f"Item found: {result}")
        else:
            logger.warning(f"Item with ID {id} not found")
        return result

    def add(self, schema):
        logger.info(f"Adding item with schema: {schema}")
        result = self._repository.create(schema)
        logger.info(f"Item added: {result}")
        return result

    def patch(self, id: int, schema):
        logger.info(f"Patching item with ID: {id} and schema: {schema}")
        result = self._repository.update(id, schema)
        logger.info(f"Item patched: {result}")
        return result

    def patch_attr(self, id: int, attr: str, value):
        logger.info(f"Patching attribute '{attr}' of item with ID: {id} to value: {value}")
        result = self._repository.update_attr(id, attr, value)
        logger.info(f"Attribute patched: {result}")
        return result

    def put_update(self, id: int, schema):
        logger.info(f"Updating item with ID: {id} with schema: {schema}")
        result = self._repository.whole_update(id, schema)
        logger.info(f"Item updated: {result}")
        return result

    def remove_by_id(self, id):
        logger.info(f"Removing item with ID: {id}")
        result = self._repository.delete_by_id(id)
        if result:
            logger.info(f"Item with ID {id} removed successfully")
        else:
            logger.warning(f"Item with ID {id} not found")
        return result

    def black_and_white_photo(self, file: UploadFile) -> io.BytesIO:
        logger.info(f"Converting photo to black and white for file: {file.filename}")
        try:
            image = Image.open(file.file)
            black_and_white_image = image.convert('L')
            img_byte_arr = io.BytesIO()
            black_and_white_image.save(img_byte_arr, format=image.format)
            img_byte_arr.seek(0)
            logger.info(f"Photo converted successfully for file: {file.filename}")
            return img_byte_arr
        except Exception as e:
            logger.error(f"Error converting photo to black and white: {e}")
            return {"error": "Error converting photo"}
