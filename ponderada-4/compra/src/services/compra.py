# src/services/produtos.py

from fastapi import HTTPException
from sqlalchemy.orm import Session
from repository.compra import CompraRepository
from models.compra import Compra
from schemas.compra import Compra as CompraSchema

class CompraService:
    def __init__(self, db: Session):
        self.repository = CompraRepository(db)

    def get(self, produto_id):
        produto = self.repository.get(produto_id)
        if produto is None:
            raise HTTPException(status_code=404, detail="Produto não encontrado")
        return produto

    def get_all(self):
        return self.repository.get_all()

    def add(self, produto : CompraSchema):
        produto = Compra(**produto.dict())
        return self.repository.add(produto)

    def update(self, produto_id, produto : CompraSchema):
        produto = Compra(**produto.dict())
        return self.repository.update(produto_id, produto)

    def delete(self, produto_id):
        return self.repository.delete(produto_id)