from sqlmodel import Field

from app.model.base_model import BaseModel


class Photo(BaseModel, table=True):
    user_token: str = Field()
    id: int = Field(default=None, primary_key=True)
    file_name: str = Field()
    url: str = Field()
    is_black_and_white: bool = Field(default=False)
