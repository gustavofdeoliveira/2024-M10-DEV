# schemas/produtos.py

from pydantic import BaseModel
from datetime import datetime

class Compra(BaseModel):
    id: int
    usuario_id: int
    produto_id: int
    data_criacao: datetime
    data_modificacao: datetime

    class Config:
        orm_mode = True