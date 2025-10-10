from pydantic import BaseModel, Field, validator
from typing import Optional
from datetime import datetime
from decimal import Decimal

class ProductBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)
    price: Decimal = Field(..., gt=0, decimal_places=2)

class ProductCreate(ProductBase):
    @validator('name')
    def name_must_not_be_empty(cls, v):
        if not v.strip():
            raise ValueError('Name cannot be empty')
        return v.strip()

class ProductUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=500)
    price: Optional[Decimal] = Field(None, gt=0, decimal_places=2)

class ProductInDBBase(ProductBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime]
    
    class Config:
        from_attributes = True

class Product(ProductInDBBase):
    pass

class ProductInDB(ProductInDBBase):
    pass
