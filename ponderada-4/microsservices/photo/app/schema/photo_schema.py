# many to many schemas must be contained at one schema file to prevent cyclic reference
from typing import List, Optional

from pydantic import BaseModel

from app.schema.base_schema import FindBase, ModelBaseInfo, SearchOptions
from app.util.schema import AllOptional


class BasePhoto(BaseModel):
    user_token: str
    id: int
    file_name: str
    url: str
    is_black_and_white: bool

    class Config:
        orm_mode = True

class Photo(ModelBaseInfo, BasePhoto, metaclass=AllOptional):
    ...


class FindPhoto(FindBase, BasePhoto, metaclass=AllOptional):
    id__in: str
    user_token__in: str


class UpsertPhoto(BasePhoto, metaclass=AllOptional):
    ...


class FindPhotoResult(BaseModel):
    founds: Optional[List[Photo]]
    search_options: Optional[SearchOptions]
