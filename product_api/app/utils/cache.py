import redis
import json
from typing import Any, Optional
from app.core.config import settings

redis_client = redis.from_url(settings.redis_url, decode_responses=True)

class CacheManager:
    def __init__(self, expire_time: int = settings.cache_expire_time):
        self.expire_time = expire_time
    
    def get(self, key: str) -> Optional[Any]:
        try:
            data = redis_client.get(key)
            return json.loads(data) if data else None
        except Exception:
            return None
    
    def set(self, key: str, value: Any) -> bool:
        try:
            redis_client.setex(
                key, 
                self.expire_time, 
                json.dumps(value, default=str)
            )
            return True
        except Exception:
            return False
    
    def delete(self, key: str) -> bool:
        try:
            redis_client.delete(key)
            return True
        except Exception:
            return False
    
    def clear_pattern(self, pattern: str) -> bool:
        try:
            keys = redis_client.keys(pattern)
            if keys:
                redis_client.delete(*keys)
            return True
        except Exception:
            return False

cache = CacheManager()
