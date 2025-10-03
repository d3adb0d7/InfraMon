# InfraMon API Documentation

## Base Information
- **Base URL:** http://localhost:5002/api
- **Authentication:** JWT Bearer Token
- **Content-Type:** application/json

---

## Authentication Endpoints

### Login
**POST /auth/login**
Authenticate user and receive JWT token.

**Request Body:**
```json
{
  "username": "admin",
  "password": "admin"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@inframon.app",
    "firstName": "System",
    "lastName": "Administrator",
    "phone": null,
    "role": "admin",
    "telegramChatId": null,
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

### Change Password
**POST /auth/change-password**
Change user password (requires authentication).

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "currentPassword": "oldpassword",
  "newPassword": "newpassword"
}
```

### Get Profile
**GET /auth/profile**
Get current user profile.

**Headers:**
```
Authorization: Bearer <token>
```

### Update Profile
**PUT /auth/profile**
Update user profile information.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "email": "newemail@example.com",
  "telegramChatId": "123456789",
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+1234567890",
  "username": "newusername"
}
```

### Verify Token
**GET /auth/verify**
Verify JWT token validity.

**Headers:**
```
Authorization: Bearer <token>
```

---

## Users Management (Admin Only)

### Get All Users
**GET /users**
Retrieve all users (admin only).

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
[
  {
    "id": 1,
    "username": "admin",
    "email": "admin@inframon.app",
    "firstName": "System",
    "lastName": "Administrator",
    "phone": null,
    "role": "admin",
    "telegramChatId": null,
    "isActive": true,
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
]
```

### Create User
**POST /users**
Create a new user (admin only).

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "username": "newuser",
  "email": "user@example.com",
  "password": "password123",
  "role": "user",
  "telegramChatId": "123456789",
  "isActive": true,
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+1234567890"
}
```

### Update User
**PUT /users/:id**
Update user information.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "email": "updated@example.com",
  "role": "monitoring_user",
  "isActive": false,
  "firstName": "Jane",
  "lastName": "Smith"
}
```

### Delete User
**DELETE /users/:id**
Delete a user (admin only, cannot delete own account).

**Headers:**
```
Authorization: Bearer <token>
```

---

## Websites Management

### Get All Websites
**GET /websites**
Get all websites (users see only their own, admins see all).

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
[
  {
    "id": 1,
    "url": "https://example.com",
    "name": "Example Website",
    "interval": 5,
    "httpMethod": "GET",
    "expectedStatusCodes": [200],
    "isActive": true,
    "userId": 1,
    "headers": [],
    "customCurlCommand": null,
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
]
```

### Get Website Details
**GET /websites/:id**
Get specific website details with logs and alerts.

**Headers:**
```
Authorization: Bearer <token>
```

### Create Website
**POST /websites**
Create a new website to monitor.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "url": "https://example.com",
  "name": "Example Website",
  "interval": 5,
  "httpMethod": "GET",
  "expectedStatusCodes": [200, 301],
  "isActive": true,
  "headers": [
    {
      "key": "Authorization",
      "value": "Bearer token123"
    }
  ],
  "customCurlCommand": null
}
```

### Update Website
**PUT /websites/:id**
Update website configuration.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:** (same as create, partial updates supported)

### Delete Website
**DELETE /websites/:id**
Delete a website and stop monitoring.

**Headers:**
```
Authorization: Bearer <token>
```

### Manual Check
**POST /websites/:id/check**
Manually check website status immediately.

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "status": "up",
  "responseTime": 245,
  "statusCode": 200,
  "message": "Website is up (HTTP 200)",
  "method": "HTTP GET"
}
```

### Test CURL Command
**POST /websites/test-curl**
Test a CURL command before saving.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "command": "curl -L -s -o /dev/null -w \"%{http_code}\" https://example.com"
}
```

**Response:**
```json
{
  "success": true,
  "output": "200",
  "error": ""
}
```

### Get Website Statistics
**GET /websites/:id/stats**
Get monitoring statistics for a website.

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "uptimePercentage": 99.85,
  "avgResponseTime": 156.32,
  "totalChecks": 1247,
  "upChecks": 1245,
  "downChecks": 2,
  "chartData": [
    {
      "date": "2024-01-01",
      "uptime": 100.0,
      "avgResponseTime": 145.2
    }
  ]
}
```

---

(Documentation continues with Alerts, Reports, Real-time Events, System Endpoints, Error Responses, and Environment Variables.)

