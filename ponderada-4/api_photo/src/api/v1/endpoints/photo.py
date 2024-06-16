from dependency_injector.wiring import Provide, inject
from fastapi import APIRouter, Depends, File, UploadFile
from app.core.container import Container
from fastapi.responses import StreamingResponse
from app.core.dependencies import get_current_active_user
from app.model.user import User
from app.schema.base_schema import Blank
from app.schema.photo_schema import FindPhoto, FindPhotoResult, Photo, UpsertPhoto
from app.services.photo_service import PhotoService
import logging

router = APIRouter(
    prefix="/photo",
    tags=["photo"],
)

LOGGER = logging.getLogger(__name__)

@router.get("", response_model=FindPhotoResult)
@inject
async def get_photo_list(
    find_query: FindPhoto = Depends(),
    service: PhotoService = Depends(Provide[Container.photo_service]),
):
    LOGGER.info(f"Fetching photo list with query: {find_query}")
    result = service.get_list(find_query)
    LOGGER.info(f"Fetched {len(result)} photos")
    return result

@router.get("/{photo_id}", response_model=Photo)
@inject
async def get_photo(
    photo_id: int,
    service: PhotoService = Depends(Provide[Container.photo_service]),
):
    LOGGER.info(f"Fetching photo with ID: {photo_id}")
    result = service.get_by_id(photo_id)
    if result:
        LOGGER.info(f"Photo found: {result}")
    else:
        LOGGER.warning(f"Photo with ID {photo_id} not found")
    return result

@router.post("")
@inject
async def create_photo(
    file: UploadFile,
    user_token: str,
    file_name: str,
    url: str,
    service: PhotoService = Depends(Provide[Container.photo_service]),
    current_user: User = Depends(get_current_active_user),
):
    LOGGER.info(f"Creating photo for user {current_user.id}")
    try:
        LOGGER.info(f"Converting image to black and white")
        photo = Photo(user_token=user_token, file_name=file_name, url=url, is_black_and_white=True)
        resultImage = service.black_and_white_photo(file)
        if resultImage:
            imageInfo = service.add(photo)
            LOGGER.info(f"Photo created successfully: {imageInfo}")
            def iterfile():
                yield from resultImage
            
            return StreamingResponse(iterfile(), media_type="image/jpeg", headers={
                "Content-Disposition": f"inline; filename={file_name}"
            })
        else:
            LOGGER.error("Error converting image to black and white")
            return {"error": "Error on convert image"}
    except Exception as e:
        LOGGER.error(f"Exception while creating photo: {str(e)}")
        return {"error": "Error creating photo"}

@router.patch("/{photo_id}", response_model=Photo)
@inject
async def update_photo(
    photo_id: int,
    photo: UpsertPhoto,
    service: PhotoService = Depends(Provide[Container.photo_service]),
    current_user: User = Depends(get_current_active_user),
):
    LOGGER.info(f"Updating photo with ID: {photo_id}")
    result = service.patch(photo_id, photo)
    LOGGER.info(f"Photo updated: {result}")
    return result

@router.delete("/{photo_id}", response_model=Blank)
@inject
async def delete_photo(
    photo_id: int,
    service: PhotoService = Depends(Provide[Container.photo_service]),
    current_user: User = Depends(get_current_active_user),
):
    LOGGER.info(f"Deleting photo with ID: {photo_id}")
    result = service.remove_by_id(photo_id)
    if result:
        LOGGER.info(f"Photo deleted successfully")
    else:
        LOGGER.warning(f"Photo with ID {photo_id} not found")
    return result
