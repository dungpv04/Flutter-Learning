from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from fastapi import HTTPException
from typing import List, Optional
from app.models.product import Product
from app.schemas.product import ProductCreate, ProductUpdate

class ProductCRUD:
    def get(self, db: Session, id: int) -> Optional[Product]:
        return db.query(Product).filter(Product.id == id).first()
    
    def get_multi(self, db: Session, skip: int = 0, limit: int = 100) -> List[Product]:
        return db.query(Product).offset(skip).limit(limit).all()
    
    def create(self, db: Session, obj_in: ProductCreate) -> Product:
        try:
            db_obj = Product(**obj_in.dict())
            db.add(db_obj)
            db.commit()
            db.refresh(db_obj)
            return db_obj
        except IntegrityError:
            db.rollback()
            raise HTTPException(status_code=400, detail="Product name already exists")
    
    def update(self, db: Session, db_obj: Product, obj_in: ProductUpdate) -> Product:
        try:
            update_data = obj_in.dict(exclude_unset=True)
            for field, value in update_data.items():
                setattr(db_obj, field, value)
            db.commit()
            db.refresh(db_obj)
            return db_obj
        except IntegrityError:
            db.rollback()
            raise HTTPException(status_code=400, detail="Product name already exists")
    
    def remove(self, db: Session, id: int) -> Product:
        obj = db.query(Product).get(id)
        if obj:
            db.delete(obj)
            db.commit()
        return obj

product = ProductCRUD()
