import logging
from dependency_injector.wiring import Provide, inject
from fastapi import APIRouter, Depends
from app.core.container import Container
from app.core.dependencies import get_current_active_user
from app.schema.auth_schema import SignIn, SignInResponse, SignUp
from app.schema.user_schema import User
from app.services.auth_service import AuthService

router = APIRouter(
    prefix="/auth",
    tags=["auth"],
)

# Configuração do logger
logger = logging.getLogger(__name__)



@router.post("/sign-in", response_model=SignInResponse)
@inject
async def sign_in(user_info: SignIn, service: AuthService = Depends(Provide[Container.auth_service])):
    logger.info(f"Attempting to sign in user: {user_info.email__eq}")
    try:
        result = service.sign_in(user_info)
        logger.info(f"User {user_info.email__eq} signed in successfully")
        return result
    except Exception as e:
        logger.error(f"Error signing in user {user_info.email__eq}: {str(e)}")
        raise

@router.post("/sign-up", response_model=User)
@inject
async def sign_up(user_info: SignUp, service: AuthService = Depends(Provide[Container.auth_service])):
    logger.info(f"Attempting to sign up user: {user_info.email}")
    try:
        result = service.sign_up(user_info)
        logger.info(f"User {user_info.email} signed up successfully")
        return result
    except Exception as e:
        logger.error(f"Error signing up user {user_info.email}: {str(e)}")
        raise

@router.get("/me", response_model=User)
@inject
async def get_me(current_user: User = Depends(get_current_active_user)):
    logger.info(f"Fetching current user: {current_user.email}")
    try:
        return current_user
    except Exception as e:
        logger.error(f"Error fetching current user: {str(e)}")
        raise
