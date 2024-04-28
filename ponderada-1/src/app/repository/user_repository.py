from sqlalchemy.orm import Session

from app.model.user import User
from app.repository.base_repository import BaseRepository


class UserRepository(BaseRepository):
    def __init__(self, session_factory):
        self.session_factory = session_factory
        super().__init__(session_factory, User)
