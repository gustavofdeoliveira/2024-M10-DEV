from dependency_injector.wiring import Provide, inject
from fastapi import APIRouter, Depends
from app.core.container import Container
from app.core.dependencies import get_current_super_user
from app.core.security import JWTBearer
from app.schema.base_schema import Blank
from app.schema.user_schema import FindUser, FindUserResult, UpsertUser, User
from app.services.user_service import UserService
import logging

router = APIRouter(
    prefix="/user", tags=["user"], dependencies=[Depends(JWTBearer())])

logger = logging.getLogger(__name__)


@router.get("", response_model=FindUserResult)
@inject
async def get_user_list(
    find_query: FindUser = Depends(),
    service: UserService = Depends(Provide[Container.user_service]),
    current_user: User = Depends(get_current_super_user),
):
    logger.info(f"Fetching user list with query: {find_query}")
    try:
        result = service.get_list(find_query)
        logger.info(f"Fetched {len(result.users)} users")
        return result
    except Exception as e:
        logger.error(f"Error fetching user list: {str(e)}")
        raise


@router.get("/{user_id}", response_model=User)
@inject
async def get_user(
    user_id: int,
    service: UserService = Depends(Provide[Container.user_service]),
    current_user: User = Depends(get_current_super_user),
):
    logger.info(f"Fetching user with ID: {user_id}")
    try:
        result = service.get_by_id(user_id)
        if result:
            logger.info(f"User found: {result}")
        else:
            logger.warning(f"User with ID {user_id} not found")
        return result
    except Exception as e:
        logger.error(f"Error fetching user with ID {user_id}: {str(e)}")
        raise


@router.post("", response_model=User)
@inject
async def create_user(
    user: UpsertUser,
    service: UserService = Depends(Provide[Container.user_service]),
    current_user: User = Depends(get_current_super_user),
):
    logger.info(f"Creating user with data: {user}")
    try:
        result = service.add(user)
        logger.info(f"User created successfully: {result}")
        return result
    except Exception as e:
        logger.error(f"Error creating user: {str(e)}")
        raise


@router.patch("/{user_id}", response_model=User)
@inject
async def update_user(
    user_id: int,
    user: UpsertUser,
    service: UserService = Depends(Provide[Container.user_service]),
    current_user: User = Depends(get_current_super_user),
):
    logger.info(f"Updating user with ID: {user_id} with data: {user}")
    try:
        result = service.patch(user_id, user)
        logger.info(f"User updated: {result}")
        return result
    except Exception as e:
        logger.error(f"Error updating user with ID {user_id}: {str(e)}")
        raise


@router.delete("/{user_id}", response_model=Blank)
@inject
async def delete_user(
    user_id: int,
    service: UserService = Depends(Provide[Container.user_service]),
    current_user: User = Depends(get_current_super_user),
):
    logger.info(f"Deleting user with ID: {user_id}")
    try:
        result = service.remove_by_id(user_id)
        if result:
            logger.info(f"User with ID {user_id} deleted successfully")
        else:
            logger.warning(f"User with ID {user_id} not found")
        return result
    except Exception as e:
        logger.error(f"Error deleting user with ID {user_id}: {str(e)}")
        raise
