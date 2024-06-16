from sqlalchemy.orm import Session

from app.model.photo import Photo
from app.repository.base_repository import BaseRepository


class PhotoRepository(BaseRepository):
    def __init__(self, session_factory):
        self.session_factory = session_factory
        super().__init__(session_factory, Photo)
