from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.database import engine, Base
from app.api.products import router as products_router

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    debug=settings.debug
)

# Set up CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(
    products_router,
    prefix=f"{settings.api_v1_str}/products",
    tags=["products"]
)

@app.get("/")
def read_root():
    return {"message": f"Welcome to {settings.app_name}"}

@app.get("/health")
def health_check():
    return {"status": "healthy", "version": settings.app_version}
