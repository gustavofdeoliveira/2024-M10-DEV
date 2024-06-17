# src/databases/database.py
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
from src.repository.usuarios import UsuarioRepository
import redis

SQLALCHEMY_DATABASE_URL = "postgresql://usuario:senha@localhost:5432/ponderada_extra"

engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=True, bind=engine)
Base = declarative_base()

REDIS_HOST = 'localhost'
REDIS_PORT = 6379
redis_client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=0)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def main():
    db = next(get_db())
    usuario_repo = UsuarioRepository(db=db, redis_client=redis_client)
    
    # Exemplo de uso do repositório
    usuarios = usuario_repo.get_all()
    print(usuarios)

if __name__ == "__main__":
    main()