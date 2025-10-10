from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    # Database
    postgres_host: str
    postgres_port: int = 5432
    postgres_db: str
    postgres_user: str
    postgres_password: str
    database_url: str
    
    # Redis
    redis_host: str
    redis_port: int = 6379
    redis_db: int = 0
    redis_url: str
    
    # Application
    app_name: str = "Product Management API"
    app_version: str = "1.0.0"
    debug: bool = False
    secret_key: str
    
    # API
    api_v1_str: str = "/api/v1"
    cors_origins: List[str] = []
    
    # Cache
    cache_expire_time: int = 300
    
    class Config:
        env_file = ".env"

settings = Settings()
