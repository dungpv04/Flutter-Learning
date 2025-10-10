# FastAPI Product Management System

A complete product management system with FastAPI backend, PostgreSQL database, Redis caching, and Docker containerization.

## Technology Stack
- **Backend**: Python FastAPI
- **Package Manager**: uv
- **Database**: PostgreSQL (Docker)
- **Cache**: Redis (Docker)
- **Containerization**: Docker & Docker Compose

## Setup and Running Instructions

### 1. Initial Setup

```bash
# Build and run with Docker Compose
docker-compose up -d --build
```

### 2. Testing the API

Use the following endpoints:

- **GET** `/api/v1/products/` - Get all products
- **POST** `/api/v1/products/` - Create a new product
- **GET** `/api/v1/products/{id}` - Get a specific product
- **PUT** `/api/v1/products/{id}` - Update a product
- **DELETE** `/api/v1/products/{id}` - Delete a product

Example POST request body:
```json
{
  "name": "Laptop Pro Max",
  "description": "A powerful laptop for professionals",
  "price": 1500.99
}
```

### 3. Flutter Integration

Update your Flutter `ApiService` to point to:
- **Android Emulator**: `http://10.0.2.2:8000/api/v1`
- **Physical Device**: `http://YOUR_COMPUTER_IP:8000/api/v1`
- **Desktop**: `http://localhost:8000/api/v1`

## Features

### Caching Strategy
- Products list is cached for 5 minutes
- Individual products are cached until updated
- Cache is automatically invalidated on create/update/delete operations

### Error Handling
- Comprehensive validation with Pydantic
- Database constraint violations handled gracefully
- Detailed error messages for debugging

### Performance Features
- Redis caching for frequently accessed data
- Connection pooling with SQLAlchemy
- Async-ready architecture
