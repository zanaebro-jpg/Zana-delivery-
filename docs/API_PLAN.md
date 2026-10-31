# Suggested API Contract

All endpoints require TLS. Authenticated endpoints require a short-lived access token and role authorization. Names are illustrative and should be finalized with the backend implementation.

## Customer
- `POST /v1/auth/request-code`
- `POST /v1/auth/verify-code`
- `GET /v1/service-area/check?lat={lat}&lng={lng}`
- `GET /v1/categories`
- `GET /v1/merchants?category={category}&area_id={area_id}`
- `GET /v1/merchants/{merchant_id}/products`
- `POST /v1/addresses`
- `GET /v1/addresses`
- `POST /v1/orders`
- `GET /v1/orders/{order_id}`
- `GET /v1/orders`
- `POST /v1/orders/{order_id}/cancel` (only if policy permits)

## Courier
- `POST /v1/courier/availability`
- `GET /v1/courier/jobs`
- `POST /v1/orders/{order_id}/accept-delivery`
- `POST /v1/orders/{order_id}/pickup`
- `POST /v1/orders/{order_id}/complete`

## Merchant
- `GET /v1/merchant/orders`
- `POST /v1/merchant/orders/{order_id}/accept`
- `POST /v1/merchant/orders/{order_id}/ready`
- `PATCH /v1/merchant/products/{product_id}`

## Admin
- `GET /v1/admin/orders`
- `POST /v1/admin/merchants/{merchant_id}/approve`
- `POST /v1/admin/couriers/{courier_id}/approve`
- `PATCH /v1/admin/service-areas/{area_id}`
- `PATCH /v1/admin/delivery-fees/{rule_id}`

## Server-side validation
- Confirm user role and account status.
- Confirm merchant is approved and open.
- Confirm each product belongs to the selected merchant and is available.
- Confirm delivery address is inside an active service area (initially Derik only).
- Recalculate all prices and fees on the server.
- Apply valid order-state transitions only.
- Record an immutable order event for each transition.
