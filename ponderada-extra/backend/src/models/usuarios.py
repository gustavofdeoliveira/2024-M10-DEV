# usuarios.py
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from .base import Base

class Usuario(Base):
    __tablename__ = 'usuarios'

    id = Column(Integer, primary_key=True, autoincrement=True)
    nome = Column(String)
    email = Column(String)
    senha = Column(String)
    criado_em = Column(DateTime)
    atualizado_em = Column(DateTime)

    def __repr__(self):
        return f"<Usuario(nome='{self.nome}', email='{self.email}, id={self.id}', criado_em='{self.criado_em}', atualizado_em='{self.atualizado_em}')>"