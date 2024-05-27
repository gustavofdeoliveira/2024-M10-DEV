from app.repository.photo_repository import PhotoRepository
from app.services.base_service import BaseService


class PhotoService(BaseService):
    def __init__(self, photo_repository: PhotoRepository):
        self.photo_repository = photo_repository
        super().__init__(photo_repository)
