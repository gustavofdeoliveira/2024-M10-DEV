# schemas/usuarios.py

from pydantic import BaseModel
from datetime import datetime

class Usuario(BaseModel):
    id: int
    nome: str
    email: str
    senha: str
    criado_em: datetime
    atualizado_em: datetime

    class Config:
        orm_mode = True