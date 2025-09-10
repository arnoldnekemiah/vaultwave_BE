# Vaultwave API Testing Guide

## Base URL
```
http://localhost:3001
```

## API Endpoints

### 1. Create User (Join Waitlist)
**POST** `/api/v1/users`

**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "user": {
    "email": "john.doe@example.com",
    "wallet_address": "0x1234567890123456789012345678901234567890"
  }
}
```

**Response (201 Created):**
```json
{
  "user": {
    "id": 1,
    "email": "john.doe@example.com",
    "wallet_address": "0x1234567890123456789012345678901234567890",
    "waitlist_position": 1,
    "referral_code": "VW12AB34CD",
    "referral_link": "http://localhost:3001/join?ref=VW12AB34CD",
    "total_referrals": 0,
    "created_at": "2025-09-10T14:00:00.000Z"
  },
  "message": "Successfully joined waitlist!"
}
```

### 2. Create User with Referral Code
**POST** `/api/v1/users`

**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "user": {
    "email": "jane.smith@example.com",
    "wallet_address": "0x9876543210987654321098765432109876543210",
    "referred_by_code": "VW12AB34CD"
  }
}
```

**Response (201 Created):**
```json
{
  "user": {
    "id": 2,
    "email": "jane.smith@example.com",
    "wallet_address": "0x9876543210987654321098765432109876543210",
    "waitlist_position": 2,
    "referral_code": "VW56EF78GH",
    "referral_link": "http://localhost:3001/join?ref=VW56EF78GH",
    "total_referrals": 0,
    "created_at": "2025-09-10T14:05:00.000Z"
  },
  "message": "Successfully joined waitlist!"
}
```

### 3. Get User Details
**GET** `/api/v1/users/:id`

**Example:** `GET /api/v1/users/1`

**Response (200 OK):**
```json
{
  "id": 1,
  "email": "john.doe@example.com",
  "wallet_address": "0x1234567890123456789012345678901234567890",
  "waitlist_position": 1,
  "referral_code": "VW12AB34CD",
  "referral_link": "http://localhost:3001/join?ref=VW12AB34CD",
  "total_referrals": 1,
  "created_at": "2025-09-10T14:00:00.000Z"
}
```

### 4. Get User Waitlist Position
**GET** `/api/v1/users/:id/waitlist_position`

**Example:** `GET /api/v1/users/1/waitlist_position`

**Response (200 OK):**
```json
{
  "waitlist_position": 1,
  "total_users": 2,
  "referral_count": 1
}
```

### 5. Validate Referral Code
**GET** `/api/v1/referral/:code`

**Example:** `GET /api/v1/referral/VW12AB34CD`

**Response (200 OK):**
```json
{
  "valid": true,
  "referrer": {
    "id": 1,
    "email": "john.doe@example.com",
    "referral_code": "VW12AB34CD",
    "total_referrals": 1
  }
}
```

**Response (404 Not Found) - Invalid Code:**
```json
{
  "valid": false,
  "error": "Invalid referral code"
}
```

### 6. Create Referral Record
**POST** `/api/v1/referrals`

**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "referral": {
    "referrer_id": 1,
    "referred_id": 2
  }
}
```

**Response (201 Created):**
```json
{
  "referral": {
    "id": 1,
    "referrer": {
      "id": 1,
      "email": "john.doe@example.com",
      "referral_code": "VW12AB34CD"
    },
    "referred": {
      "id": 2,
      "email": "jane.smith@example.com"
    },
    "clicked_at": null,
    "converted_at": "2025-09-10T14:05:00.000Z",
    "created_at": "2025-09-10T14:05:00.000Z"
  },
  "message": "Referral tracked successfully!"
}
```

### 7. Get Referral Details
**GET** `/api/v1/referrals/:id`

**Example:** `GET /api/v1/referrals/1`

**Response (200 OK):**
```json
{
  "id": 1,
  "referrer": {
    "id": 1,
    "email": "john.doe@example.com",
    "referral_code": "VW12AB34CD"
  },
  "referred": {
    "id": 2,
    "email": "jane.smith@example.com"
  },
  "clicked_at": "2025-09-10T14:03:00.000Z",
  "converted_at": "2025-09-10T14:05:00.000Z",
  "created_at": "2025-09-10T14:05:00.000Z"
}
```

## Error Responses

### Validation Errors (422 Unprocessable Entity)
```json
{
  "errors": {
    "email": ["can't be blank", "has already been taken"],
    "wallet_address": ["can't be blank"]
  }
}
```

### Invalid Referral Code (422 Unprocessable Entity)
```json
{
  "errors": {
    "referral_code": ["Invalid referral code"]
  }
}
```

### Not Found (404 Not Found)
```json
{
  "error": "User not found"
}
```

## Testing Workflow

1. **Start the Rails server:**
   ```bash
   bundle exec rails server
   ```

2. **Create first user (no referral):**
   - POST to `/api/v1/users` with email and wallet_address
   - Note the `referral_code` from the response

3. **Create second user (with referral):**
   - POST to `/api/v1/users` with email, wallet_address, and `referred_by_code`
   - Use the referral_code from step 2

4. **Test user retrieval:**
   - GET `/api/v1/users/1` to see the first user's details
   - GET `/api/v1/users/1/waitlist_position` to see their position and referral count

5. **Test referral validation:**
   - GET `/api/v1/referral/{referral_code}` to validate a referral code

## Database Setup

If you encounter database connection errors, run:
```bash
# Create databases
bundle exec rails db:create

# Run migrations
bundle exec rails db:migrate

# Optional: Add seed data
bundle exec rails db:seed
```

## CORS Headers

The API includes CORS headers to allow frontend integration:
- `Access-Control-Allow-Origin: *`
- `Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD`
- `Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization`
