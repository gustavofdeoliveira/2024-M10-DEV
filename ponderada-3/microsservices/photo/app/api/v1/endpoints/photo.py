from dependency_injector.wiring import Provide, inject
from fastapi import APIRouter, Depends, File, UploadFile

from app.core.container import Container
from app.core.dependencies import get_current_active_user
from app.model.user import User
from app.schema.base_schema import Blank
from app.schema.photo_schema import FindPhoto, FindPhotoResult, Photo, UpsertPhoto
from app.services.photo_service import PhotoService

router = APIRouter(
    prefix="/photo",
    tags=["photo"],
)


@router.get("", response_model=FindPhotoResult)
@inject
async def get_photo_list(
    find_query: FindPhoto = Depends(),
    service: PhotoService = Depends(Provide[Container.photo_service]),
):
    return service.get_list(find_query)


@router.get("/{photo_id}", response_model=Photo)
@inject
async def get_photo(
    photo_id: int,
    service: PhotoService = Depends(Provide[Container.photo_service]),
):
    return service.get_by_id(photo_id)


@router.post("", response_model=Photo)
@inject
async def create_photo(
    photo: UpsertPhoto,
    UploadFile = File(...),
    service: PhotoService = Depends(Provide[Container.photo_service]),
    current_user: User = Depends(get_current_active_user),
):
    return service.add(photo)


@router.patch("/{photo_id}", response_model=Photo)
@inject
async def update_photo(
    photo_id: int,
    photo: UpsertPhoto,
    service: PhotoService = Depends(Provide[Container.photo_service]),
    current_user: User = Depends(get_current_active_user),
):
    return service.patch(photo_id, photo)


@router.delete("/{photo_id}", response_model=Blank)
@inject
async def delete_photo(
    photo_id: int,
    service: PhotoService = Depends(Provide[Container.photo_service]),
    current_user: User = Depends(get_current_active_user),
):
    return service.remove_by_id(photo_id)
