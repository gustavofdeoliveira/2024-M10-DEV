from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware


from app.api.v1.endpoints.auth import router as auth_router
from app.api.v1.endpoints.user import router as user_router

from app.core.config import configs
from app.core.container import Container
from app.util.class_object import singleton


@singleton
class AppCreator:
    def __init__(self):
        # set app default
        self.app = FastAPI(
            title=configs.PROJECT_NAME,
            openapi_url=f"{configs.API}/openapi.json",
            version="0.0.1",
            contact={
                "name": "Gustavo F. de Oliveira",
                "url": "https://github.com/gustavofdeoliveira/",
                "email": "gustavo.oliveira@sou.inteli.edu.br",
            },
            license_info={
                "name": "Apache 2.0",
                "url": "https://www.apache.org/licenses/LICENSE-2.0.html",
            },
        )

        # set db and container
        self.container = Container()
        self.db = self.container.db()
        # self.db.create_database()

        # set cors
        if configs.BACKEND_CORS_ORIGINS:
            self.app.add_middleware(
                CORSMiddleware,
                allow_origins=[str(origin) for origin in configs.BACKEND_CORS_ORIGINS],
                allow_credentials=True,
                allow_methods=["*"],
                allow_headers=["*"],
            )

        # set routes
        @self.app.get("/")
        def root():
            return "service is working"
        
        self.app.include_router(auth_router)
        self.app.include_router(user_router)


app_creator = AppCreator()
app = app_creator.app
db = app_creator.db
container = app_creator.container
