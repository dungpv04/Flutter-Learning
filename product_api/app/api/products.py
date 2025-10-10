from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.crud.product import product
from app.schemas.product import Product, ProductCreate, ProductUpdate
from app.utils.cache import cache

router = APIRouter()

@router.get("/", response_model=List[Product])
def read_products(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    # Try to get from cache first
    cache_key = f"products:{skip}:{limit}"
    cached_products = cache.get(cache_key)
    
    if cached_products:
        return cached_products
    
    # If not in cache, get from database
    products = product.get_multi(db, skip=skip, limit=limit)
    
    # Convert to dict for caching
    products_dict = [Product.from_orm(p).dict() for p in products]
    cache.set(cache_key, products_dict)
    
    return products

@router.post("/", response_model=Product, status_code=201)
def create_product(
    product_in: ProductCreate,
    db: Session = Depends(get_db)
):
    created_product = product.create(db=db, obj_in=product_in)
    # Clear products cache
    cache.clear_pattern("products:*")
    return created_product

@router.get("/{product_id}", response_model=Product)
def read_product(
    product_id: int,
    db: Session = Depends(get_db)
):
    # Try cache first
    cache_key = f"product:{product_id}"
    cached_product = cache.get(cache_key)
    
    if cached_product:
        return cached_product
    
    db_product = product.get(db, id=product_id)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Cache the product
    product_dict = Product.from_orm(db_product).dict()
    cache.set(cache_key, product_dict)
    
    return db_product

@router.put("/{product_id}", response_model=Product)
def update_product(
    product_id: int,
    product_in: ProductUpdate,
    db: Session = Depends(get_db)
):
    db_product = product.get(db, id=product_id)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    updated_product = product.update(db=db, db_obj=db_product, obj_in=product_in)
    
    # Clear cache
    cache.delete(f"product:{product_id}")
    cache.clear_pattern("products:*")
    
    return updated_product

@router.delete("/{product_id}", status_code=204)
def delete_product(
    product_id: int,
    db: Session = Depends(get_db)
):
    db_product = product.get(db, id=product_id)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    
    product.remove(db=db, id=product_id)
    
    # Clear cache
    cache.delete(f"product:{product_id}")
    cache.clear_pattern("products:*")
    
    return None
