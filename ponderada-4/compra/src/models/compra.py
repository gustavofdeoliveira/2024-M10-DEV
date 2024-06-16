# produtos.py
from sqlalchemy import Column, Integer, String, Double, DateTime
from sqlalchemy.ext.declarative import declarative_base
from .base import Base

class Compra(Base):
    __tablename__ = 'compra'

    id = Column(Integer, primary_key=True, autoincrement=True)
    usuario_id = Column(Integer)
    produto_id = Column(Integer)
    data_criacao = Column(DateTime)
    data_modificacao = Column(DateTime)

    def __repr__(self):
        return f"<Compra(id='{self.id}', usuario='{self.usuario_id}, produto={self.produto_id}', criado_em='{self.data_criacao}', modificado_em='{self.data_modificacao}')>"