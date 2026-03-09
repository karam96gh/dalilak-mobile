# API Documentation - Dalilak Backend

**Version:** 1.0.0  
**Last Updated:** February 23, 2026  
**Base URL:** `https://api.dalilak.com/api`

---

## Table of Contents

1. [Authentication](#authentication)
2. [Endpoints](#endpoints)
3. [Response Format](#response-format)
4. [Error Handling](#error-handling)
5. [Rate Limiting](#rate-limiting)
6. [Webhooks](#webhooks)
7. [SDKs & Examples](#sdks--examples)

---

## Authentication

Currently, the app uses **stateless** authentication with optional headers for future implementation.

### Future: API Key Authentication

```
Header: Authorization: Bearer {api_key}
```

### Future: JWT Authentication

```
Header: Authorization: Bearer {jwt_token}
```

---

## Endpoints

### Categories

#### GET /categories

Retrieve all product/service categories with hierarchical structure.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | integer | 100 | Max items to return |
| `offset` | integer | 0 | Pagination offset |
| `parentId` | integer | null | Filter by parent category |

**Request:**

```bash
curl -X GET "https://api.dalilak.com/api/categories" \
  -H "Accept: application/json"
```

**Response (200 OK):**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Real Estate",
      "icon": "🏠",
      "image": "https://...",
      "parentId": null,
      "level": 0,
      "children": [
        {
          "id": 2,
          "name": "Apartments",
          "icon": "🏢",
          "parentId": 1,
          "level": 1,
          "children": []
        }
      ]
    }
  ],
  "total": 15,
  "timestamp": "2024-02-23T10:30:00Z"
}
```

#### GET /categories/:id

Retrieve single category with details.

**Response (200 OK):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Real Estate",
    "description": "Property listings and real estate services",
    "icon": "🏠",
    "image": "https://...",
    "itemCount": 1250,
    "level": 0,
    "children": []
  },
  "timestamp": "2024-02-23T10:30:00Z"
}
```

---

### Governorates

#### GET /governorates

Retrieve all Egyptian governorates.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `active` | boolean | true | Filter by active status |
| `sort` | string | "order" | Sort field (order, name) |

**Response (200 OK):**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Cairo",
      "isActive": true,
      "order": 1,
      "centerLat": 30.0444,
      "centerLng": 31.2357
    },
    {
      "id": 2,
      "name": "Giza",
      "isActive": true,
      "order": 2,
      "centerLat": 30.0131,
      "centerLng": 31.2089
    }
  ],
  "total": 27,
  "timestamp": "2024-02-23T10:30:00Z"
}
```

---

### Listings

#### GET /listings

Retrieve listings with optional filtering and pagination.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | integer | 1 | Page number |
| `limit` | integer | 20 | Items per page |
| `categoryId` | integer | null | Filter by category |
| `governorateId` | integer | null | Filter by governorate |
| `isFeatured` | boolean | null | Featured only |
| `sort` | string | "newest" | Sort field |

**Request:**

```bash
curl -X GET "https://api.dalilak.com/api/listings?page=1&limit=20&categoryId=1" \
  -H "Accept: application/json"
```

**Response (200 OK):**

```json
{
  "success": true,
  "data": [
    {
      "id": 101,
      "name": "Modern Apartment in Downtown",
      "description": "3-bedroom apartment with amazing views",
      "categoryId": 2,
      "governorateId": 1,
      "phone": "+201001234567",
      "whatsapp": "+201001234567",
      "email": "owner@example.com",
      "website": "https://example.com",
      "instagram": "example_account",
      "facebook": "example_page",
      "tiktok": "example_tiktok",
      "locationLat": 30.0444,
      "locationLng": 31.2357,
      "address": "Downtown, Cairo",
      "isFeatured": true,
      "isActive": true,
      "viewCount": 1250,
      "images": [
        {
          "id": 1,
          "listingId": 101,
          "imageUrl": "https://...",
          "order": 0
        }
      ],
      "createdAt": "2024-02-20T10:00:00Z",
      "updatedAt": "2024-02-23T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 1250,
    "pages": 63
  },
  "timestamp": "2024-02-23T10:30:00Z"
}
```

#### GET /listings/:id

Retrieve single listing with full details.

**Response (200 OK):**

```json
{
  "success": true,
  "data": {
    "id": 101,
    "name": "Modern Apartment in Downtown",
    "description": "Full detailed description...",
    "categoryId": 2,
    "governorateId": 1,
    "category": { /* full category object */ },
    "governorate": { /* full governorate object */ },
    "phone": "+201001234567",
    "email": "owner@example.com",
    "address": "Downtown, Cairo",
    "locationLat": 30.0444,
    "locationLng": 31.2357,
    "images": [],
    "rating": {
      "average": 4.5,
      "totalReviews": 125,
      "distribution": {
        "5": 95,
        "4": 22,
        "3": 6,
        "2": 2,
        "1": 0
      }
    },
    "reviews": [
      {
        "id": 1,
        "rating": 5,
        "comment": "Great service!",
        "userName": "John Doe",
        "verifiedBuyer": true,
        "createdAt": "2024-02-20T10:00:00Z"
      }
    ],
    "viewCount": 1250,
    "createdAt": "2024-02-20T10:00:00Z"
  },
  "timestamp": "2024-02-23T10:30:00Z"
}
```

#### GET /listings/search

Search listings by query string.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `q` | string | required | Search query |
| `page` | integer | 1 | Page number |
| `limit` | integer | 20 | Items per page |
| `categoryId` | integer | null | Filter by category |
| `governorateId` | integer | null | Filter by governorate |

**Request:**

```bash
curl -X GET "https://api.dalilak.com/api/search?q=apartment&categoryId=2" \
  -H "Accept: application/json"
```

**Response (200 OK):**

```json
{
  "success": true,
  "data": [ /* array of listings */ ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 125,
    "pages": 7
  },
  "timestamp": "2024-02-23T10:30:00Z"
}
```

---

### Reviews

#### GET /listings/:id/reviews

Retrieve reviews for a listing.

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | integer | 1 | Page number |
| `limit` | integer | 10 | Items per page |
| `sort` | string | "newest" | Sort order |

**Response (200 OK):**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "listingId": 101,
      "rating": 5,
      "comment": "Excellent service!",
      "userName": "Ahmed Hassan",
      "userImage": "https://...",
      "verifiedBuyer": true,
      "createdAt": "2024-02-20T10:00:00Z",
      "updatedAt": "2024-02-20T10:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 125,
    "pages": 13
  },
  "timestamp": "2024-02-23T10:30:00Z"
}
```

#### POST /listings/:id/reviews

Submit a new review.

**Request Body:**

```json
{
  "rating": 5,
  "comment": "Great service and friendly staff!",
  "userName": "John Doe",
  "userEmail": "john@example.com"
}
```

**Response (201 Created):**

```json
{
  "success": true,
  "message": "Review created successfully",
  "data": {
    "id": 126,
    "listingId": 101,
    "rating": 5,
    "comment": "Great service and friendly staff!",
    "userName": "John Doe",
    "verifiedBuyer": false,
    "createdAt": "2024-02-23T10:30:00Z"
  },
  "timestamp": "2024-02-23T10:30:00Z"
}
```

---

### Notifications

#### GET /notifications

Retrieve user notifications (future implementation).

**Response (200 OK):**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "New Reply to Your Listing",
      "body": "Someone replied to your apartment listing",
      "image": "https://...",
      "linkType": "listing",
      "linkId": 101,
      "linkUrl": null,
      "createdAt": "2024-02-23T10:30:00Z",
      "read": false
    }
  ],
  "unreadCount": 5,
  "timestamp": "2024-02-23T10:30:00Z"
}
```

---

### Advertisements

#### GET /ads

Retrieve advertisement banners.

**Response (200 OK):**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "image": "https://...",
      "linkType": "url",
      "linkId": null,
      "linkUrl": "https://advertiser.com",
      "startDate": "2024-02-20",
      "endDate": "2024-03-20",
      "position": "home_top"
    }
  ],
  "timestamp": "2024-02-23T10:30:00Z"
}
```

---

## Response Format

### Success Response

```json
{
  "success": true,
  "data": { /* the actual data */ },
  "message": "Optional success message",
  "timestamp": "2024-02-23T10:30:00Z"
}
```

### Paginated Response

```json
{
  "success": true,
  "data": [ /* array of items */ ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 1250,
    "pages": 63
  },
  "timestamp": "2024-02-23T10:30:00Z"
}
```

---

## Error Handling

### Error Response

```json
{
  "success": false,
  "message": "Error description",
  "code": "ERROR_CODE",
  "data": null,
  "timestamp": "2024-02-23T10:30:00Z"
}
```

### HTTP Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| 200 | OK | Successful GET request |
| 201 | Created | Successful POST request |
| 204 | No Content | Successful DELETE request |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Missing/invalid authentication |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource doesn't exist |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Server Error | Internal server error |
| 503 | Service Unavailable | Server temporarily down |

### Error Codes

| Code | HTTP | Description |
|------|------|-------------|
| `INVALID_REQUEST` | 400 | Invalid request parameters |
| `INVALID_QUERY` | 400 | Invalid query parameters |
| `MISSING_FIELD` | 400 | Required field missing |
| `UNAUTHORIZED` | 401 | Authentication required |
| `FORBIDDEN` | 403 | Access denied |
| `NOT_FOUND` | 404 | Resource not found |
| `DUPLICATE` | 409 | Resource already exists |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily unavailable |

---

## Rate Limiting

### Limits

- **Unauthenticated requests:** 100 per minute
- **Authenticated requests:** 1,000 per minute
- **Search requests:** 50 per minute

### Headers

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1708670400
```

### Exceeded Response (429)

```json
{
  "success": false,
  "message": "Rate limit exceeded",
  "code": "RATE_LIMIT_EXCEEDED",
  "data": {
    "retryAfter": 60
  }
}
```

---

## Webhooks

### Event Types

- `listing.created` - New listing published
- `listing.updated` - Listing updated
- `review.created` - New review submitted
- `notification.sent` - Notification sent to user

### Webhook Request

```json
{
  "id": "webhook_123",
  "event": "listing.created",
  "timestamp": "2024-02-23T10:30:00Z",
  "data": {
    "listingId": 101,
    "name": "New Apartment",
    "categoryId": 2
  }
}
```

### Webhook Response

Must return 200 status code within 30 seconds.

---

## SDKs & Examples

### Flutter (Dart)

```dart
import 'package:dio/dio.dart';
import 'package:dalilak_app/services/api_client.dart';

final apiClient = ApiClient();

// Get categories
final categories = await apiClient.get<List>('/categories');

// Get listings
final listings = await apiClient.get<Map>('/listings',
  queryParameters: {'page': 1, 'limit': 20});

// Search
final results = await apiClient.get<Map>('/search',
  queryParameters: {'q': 'apartment'});
```

### cURL

```bash
# Get categories
curl -X GET "https://api.dalilak.com/api/categories"

# Get listings
curl -X GET "https://api.dalilak.com/api/listings?page=1&limit=20"

# Search listings
curl -X GET "https://api.dalilak.com/api/search?q=apartment"

# Submit review
curl -X POST "https://api.dalilak.com/api/listings/101/reviews" \
  -H "Content-Type: application/json" \
  -d '{
    "rating": 5,
    "comment": "Great!",
    "userName": "John"
  }'
```

### JavaScript

```javascript
// Using fetch API
const response = await fetch('https://api.dalilak.com/api/listings', {
  method: 'GET',
  headers: {
    'Accept': 'application/json',
  }
});

const data = await response.json();
console.log(data);
```

---

## Changelog

### v1.0.0 (Released: Feb 23, 2026)
- Initial API release
- All endpoints operational
- Documentation complete

### Future: v1.1.0
- Authentication endpoints
- User profile endpoints
- Favorites management
- Saved searches

---

**Documentation Last Updated:** February 23, 2026  
**Next Review:** March 23, 2026

**Support Email:** api-support@dalilak.com
