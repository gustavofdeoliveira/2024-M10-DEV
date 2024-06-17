# src/repository/usuarios.py

from src.models.usuarios import Usuario
from sqlalchemy.orm import Session
from datetime import datetime
import redis
import json

class UsuarioRepository:
    def __init__(self, db: Session, redis_client: redis.Redis):
        self.db = db
        self.redis_client = redis_client

    def get(self, usuario_id):
        cache_key = f"usuario:{usuario_id}"
        usuario = self.redis_client.get(cache_key)
        
        if usuario:
            return json.loads(usuario)
        
        usuario = self.db.query(Usuario).get(usuario_id)
        if usuario:
            self.redis_client.set(cache_key, json.dumps(usuario.__dict__), ex=300)  # Cache por 5 minutos
        return usuario

    def get_all(self):
        cache_key = "usuarios:all"
        usuarios = self.redis_client.get(cache_key)
        
        if usuarios:
            return json.loads(usuarios)
        
        usuarios = self.db.query(Usuario).all()
        if usuarios:
            usuarios_list = [usuario.__dict__ for usuario in usuarios]
            self.redis_client.set(cache_key, json.dumps(usuarios_list), ex=300)  # Cache por 5 minutos
        return usuarios

    def add(self, usuario: Usuario):
        usuario.id = None
        usuario.data_criacao = datetime.now()
        self.db.add(usuario)
        self.db.flush()
        self.db.commit()
        
        # Invalida cache
        self.redis_client.delete("usuarios:all")
        return {"message": "Usuário cadastrado com sucesso"}

    def update(self, usuario_id, usuario):
        usuariodb = self.db.query(Usuario).filter(Usuario.id == usuario_id).first()
        if usuariodb is None:
            return {"message": "Usuário não encontrado"}
        
        usuario.data_modificacao = datetime.now()
        usuario_dict = usuario.__dict__
        usuario_dict.pop("_sa_instance_state", None)
        usuario_dict.pop("data_criacao", None)
        usuario_dict.pop("id", None)
        
        self.db.query(Usuario).filter(Usuario.id == usuario_id).update(usuario_dict)
        self.db.flush()
        self.db.commit()
        
        # Invalida cache
        cache_key = f"usuario:{usuario_id}"
        self.redis_client.delete(cache_key)
        self.redis_client.delete("usuarios:all")
        
        return {"message": "Usuário atualizado com sucesso"}

    def delete(self, usuario_id):
        usuariodb = self.db.query(Usuario).filter(Usuario.id == usuario_id).first()
        if usuariodb is None:
            return {"message": "Usuário não encontrado"}
        
        self.db.query(Usuario).filter(Usuario.id == usuario_id).delete()
        self.db.flush()
        self.db.commit()
        
        # Invalida cache
        cache_key = f"usuario:{usuario_id}"
        self.redis_client.delete(cache_key)
        self.redis_client.delete("usuarios:all")
        
        return {"message": "Usuário deletado com sucesso"}
