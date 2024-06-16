# src/repository/produtos.py

from models.compra import Compra
from sqlalchemy.orm import Session
from datetime import datetime

class CompraRepository:
    def __init__(self, db: Session):
        self.db = db

    def get(self, compra_id):
        return self.db.query(Compra).get(compra_id)

    def get_all(self):
        return self.db.query(Compra).all()

    def add(self, compra: Compra):
        compra.id = None
        compra.data_criacao = datetime.now()
        self.db.add(compra)
        self.db.flush()
        self.db.commit()
        return {"message": "Compra cadastrado com sucesso"}

    def update(self, compra_id, compra):
        compradb = self.db.query(Compra).filter(Compra.id == compra_id).first()
        if compradb is None:
            return {"message": "Compra não encontrado"}
        compra.data_modificacao = datetime.now()
        compra = compra.__dict__
        compra.pop("_sa_instance_state")
        compra.pop("data_criacao")
        compra.pop("id")
        self.db.query(Compra).filter(Compra.id == compra_id).update(compra)
        self.db.flush()
        self.db.commit()
        return {"message": "Compra atualizado com sucesso"}

    def delete(self, compra_id):
        compradb = self.db.query(Compra).filter(Compra.id == compra_id).first()
        if compradb is None:
            return {"message": "Compra não encontrado"}
        self.db.query(Compra).filter(Compra.id == compra_id).delete()
        self.db.flush()
        self.db.commit()
        return {"message": "Compra deletado com sucesso"}
        