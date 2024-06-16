import logging
from fastapi import FastAPI, Request
from src.logging_config import LoggerSetup
from src.routers import usuarios


# Cria um logger raiz
logger_setup = LoggerSetup()

# Adiciona o logger para o módulo
LOGGER = logging.getLogger(__name__)

app = FastAPI()

app.include_router(usuarios.router)

@app.get("/")
async def root(request:Request):
    LOGGER.info("Acessando a rota /")
    return {"message": "Hello World"}
