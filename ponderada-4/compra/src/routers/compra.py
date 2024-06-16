# src/routers/compras.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from schemas.compra import Compra as CompraSchema
from services.compra import CompraService
from databases import database
import logging

LOGGER = logging.getLogger(__name__)

router = APIRouter()

@router.get("/compras/{compra_id}")
async def get_compra(compra_id: int, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /compras/{compra_id}", "compra_id": compra_id, "method": "GET"})
    compraService = CompraService(db)
    return compraService.get(compra_id)

@router.get("/compras")
async def get_compras(db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /compras", "method": "GET"})
    compraService = CompraService(db)
    return compraService.get_all()

@router.post("/compras")
async def create_compra(compra: CompraSchema, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /compras", "method": "POST", "compra": compra.dict()})
    compraService = CompraService(db)
    return compraService.add(compra=compra)

@router.put("/compras/{compra_id}")
async def update_compra(compra_id: int, compra: CompraSchema, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /compras/{compra_id}", "method": "PUT", "compra_id": compra_id, "compra": compra.dict()})
    compraService = CompraService(db)
    return compraService.update(compra_id, compra=compra)
    

@router.delete("/compras/{compra_id}")
async def delete_compra(compra_id: int, db: Session = Depends(database.get_db)):
    LOGGER.info({"message": "Acessando a rota /compras/{compra_id}", "method": "DELETE", "compra_id": compra_id})
    compraService = CompraService(db)
    return compraService.delete(compra_id)