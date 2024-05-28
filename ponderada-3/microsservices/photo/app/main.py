import logging
from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from app.api.v1.endpoints.photo import router as photo_router

from app.core.config import configs
from app.core.container import Container
from app.util.class_object import singleton

# Configuração básica do logger
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Adicionar handler para exibir logs no console
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
console_handler.setFormatter(formatter)
logger.addHandler(console_handler)

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
        
        self.app.include_router(photo_router)


app_creator = AppCreator()
app = app_creator.app
db = app_creator.db
container = app_creator.container

@app.on_event("startup")
async def startup_event():
    print("Starting up")
    container.init_resources()
    container.wire(modules=[__name__])
    logger.info("Application startup")

@app.on_event("shutdown")
async def shutdown_event():
    logger.info("Application shutdown")
