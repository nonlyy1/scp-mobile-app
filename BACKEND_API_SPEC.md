# Backend API Specification for CaterChain SCP

## Базовая информация
- **Base URL**: `http://localhost:8000/api` (для разработки)
- **Content-Type**: `application/json`
- **Authentication**: Bearer Token (JWT)

---

## 🔐 Authentication Endpoints

### 1. Register Consumer
```
POST /auth/register/consumer

Request:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securepassword",
  "phone": "+77771234567",
  "company_name": "My Restaurant"
}

Response (201):
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+77771234567",
    "role": "consumer",
    "company_id": 1,
    "created_at": "2025-01-15T10:00:00Z",
    "updated_at": "2025-01-15T10:00:00Z"
  }
}
```

### 2. Login
```
POST /auth/login

Request:
{
  "email": "john@example.com",
  "password": "securepassword"
}

Response (200):
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": { ... }
}
```

### 3. Get Current User
```
GET /auth/me
Headers: Authorization: Bearer {token}

Response (200):
{
  "user": { ... }
}
```

### 4. Logout
```
POST /auth/logout
Headers: Authorization: Bearer {token}

Response (200):
{
  "message": "Logged out successfully"
}
```

---

## 🏢 Supplier Links Endpoints

### 1. Get All Links
```
GET /supplier-links
Headers: Authorization: Bearer {token}

Response (200):
{
  "links": [
    {
      "id": 1,
      "consumer_id": 1,
      "supplier_id": 10,
      "supplier_name": "Fresh Farm Supplies",
      "status": "accepted",
      "requested_at": "2025-01-10T10:00:00Z",
      "responded_at": "2025-01-11T10:00:00Z"
    },
    {
      "id": 2,
      "consumer_id": 1,
      "supplier_id": 11,
      "supplier_name": "Organic Vegetables",
      "status": "pending",
      "requested_at": "2025-01-15T10:00:00Z",
      "responded_at": null
    }
  ]
}
```

### 2. Request Supplier Link
```
POST /supplier-links/request
Headers: Authorization: Bearer {token}

Request:
{
  "supplier_id": 10,
  "message": "Hello, I'd like to order from your store"
}

Response (201):
{
  "id": 3,
  "consumer_id": 1,
  "supplier_id": 10,
  "supplier_name": "Fresh Farm Supplies",
  "status": "pending",
  "requested_at": "2025-01-15T10:00:00Z",
  "responded_at": null,
  "message": "Link request created successfully"
}
```

---

## 🛒 Products Endpoints

### 1. Get All Products
```
GET /products
GET /products?supplier_id=10
Headers: Authorization: Bearer {token}

Response (200):
{
  "products": [
    {
      "id": 1,
      "name": "Fresh Red Tomatoes",
      "description": "Organic fresh tomatoes",
      "price": 1500.0,
      "unit": "kg",
      "stock_quantity": 100,
      "min_order_quantity": 5,
      "supplier_id": 10,
      "image_url": "https://...",
      "is_active": true,
      "images": ["https://..."],
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-15T10:00:00Z"
    }
  ]
}
```

---

## 📦 Orders Endpoints

### 1. Create Order
```
POST /orders
Headers: Authorization: Bearer {token}

Request:
{
  "supplier_id": 10,
  "items": [
    {
      "product_id": 1,
      "quantity": 5,
      "unit_price": 1500.0
    },
    {
      "product_id": 2,
      "quantity": 10,
      "unit_price": 800.0
    }
  ],
  "notes": "Please deliver in the morning"
}

Response (201):
{
  "id": 100,
  "status": "submitted",
  "consumer_id": 1,
  "supplier_id": 10,
  "total_amount": 15500.0,
  "notes": "Please deliver in the morning",
  "items": [
    {
      "id": 1,
      "order_id": 100,
      "product_id": 1,
      "quantity": 5,
      "unit_price": 1500.0,
      "line_total": 7500.0
    }
  ],
  "submitted_at": "2025-01-15T10:00:00Z",
  "accepted_at": null,
  "completed_at": null,
  "created_at": "2025-01-15T10:00:00Z",
  "updated_at": "2025-01-15T10:00:00Z"
}
```

### 2. Get All Orders
```
GET /orders
Headers: Authorization: Bearer {token}

Response (200):
{
  "orders": [
    {
      "id": 100,
      "status": "submitted",
      "consumer_id": 1,
      "supplier_id": 10,
      "total_amount": 15500.0,
      "items": [...]
    }
  ]
}
```

---

## 💬 Chat Endpoints

### 1. Get Chats
```
GET /chats
Headers: Authorization: Bearer {token}

Response (200):
{
  "chats": [
    {
      "id": 1,
      "supplier_id": 10,
      "supplier_name": "Fresh Farm Supplies",
      "last_message": "Thanks for the order",
      "last_message_at": "2025-01-15T10:00:00Z",
      "unread_count": 2
    }
  ]
}
```

### 2. Send Message
```
POST /chats/{chat_id}/messages
Headers: Authorization: Bearer {token}

Request:
{
  "message": "Hello, do you have tomatoes in stock?",
  "file_url": null
}

Response (201):
{
  "id": 1,
  "chat_id": 1,
  "sender_id": 1,
  "message": "Hello, do you have tomatoes in stock?",
  "file_url": null,
  "created_at": "2025-01-15T10:00:00Z"
}
```

---

## ⚠️ Complaints Endpoints

### 1. Create Complaint
```
POST /complaints
Headers: Authorization: Bearer {token}

Request:
{
  "order_id": 100,
  "description": "Items arrived damaged"
}

Response (201):
{
  "id": 1,
  "order_id": 100,
  "consumer_id": 1,
  "supplier_id": 10,
  "description": "Items arrived damaged",
  "status": "open",
  "created_at": "2025-01-15T10:00:00Z",
  "updated_at": "2025-01-15T10:00:00Z"
}
```

### 2. Get Complaints
```
GET /complaints
Headers: Authorization: Bearer {token}

Response (200):
{
  "complaints": [
    {
      "id": 1,
      "order_id": 100,
      "consumer_id": 1,
      "supplier_id": 10,
      "description": "Items arrived damaged",
      "status": "open",
      "created_at": "2025-01-15T10:00:00Z",
      "updated_at": "2025-01-15T10:00:00Z"
    }
  ]
}
```

---

## ✅ Error Handling

All endpoints should return appropriate HTTP status codes:

- **200**: Success (GET, POST, PUT)
- **201**: Created (POST)
- **400**: Bad Request (validation error)
- **401**: Unauthorized (invalid token)
- **403**: Forbidden (no permission)
- **404**: Not Found
- **500**: Server Error

Error Response Format:
```json
{
  "message": "Error description",
  "errors": {
    "field_name": ["error message"]
  }
}
```

---

## 🔑 Authorization

All endpoints except `/auth/register` and `/auth/login` require Bearer token:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## 📝 Notes for Backend Developer:

1. **Password**: Hash and verify securely (bcrypt recommended)
2. **Token**: JWT with expiration (24-48 hours)
3. **Dates**: Use ISO 8601 format with timezone
4. **Validation**: Validate all inputs on backend
5. **Rate Limiting**: Implement to prevent abuse
6. **CORS**: Allow requests from mobile app
7. **Database**: Store all relationships and audit logs

---

Created: November 15, 2025
