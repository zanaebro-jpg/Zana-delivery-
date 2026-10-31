# Suggested Backend Data Model

This is a starting schema for implementation. Apply database constraints, indexes, access policies and migrations before production.

## Core tables

### users
- id (UUID, primary key)
- phone_e164 (unique; store normalized phone)
- display_name
- preferred_language (`ar` or `en`)
- role (`customer`, `courier`, `merchant_user`, `admin`)
- status (`pending`, `active`, `suspended`)
- created_at, updated_at

### service_areas
- id
- name_ar, name_en
- city (`Derik`)
- country (`Syria`)
- boundary_geojson (approved service polygon)
- is_active
- created_at, updated_at

### customer_addresses
- id, customer_id
- label
- address_text
- latitude, longitude
- service_area_id
- delivery_instructions
- is_default
- created_at, updated_at

### merchants
- id
- name_ar, name_en
- category
- address_text, latitude, longitude
- phone
- is_approved, is_open
- commission_rate
- service_area_id
- created_at, updated_at

### products
- id, merchant_id
- name_ar, name_en
- description_ar, description_en
- price_minor_units, currency_code
- image_url
- is_available
- created_at, updated_at

### couriers
- id, user_id
- vehicle_type
- is_approved, is_available
- last_latitude, last_longitude
- service_area_id
- created_at, updated_at

### orders
- id, customer_id, merchant_id, courier_id (nullable until assigned)
- service_area_id
- status
- subtotal_minor_units, delivery_fee_minor_units, discount_minor_units, total_minor_units
- currency_code
- payment_method (`cash_on_delivery` only in first release)
- payment_status (`due`, `collected`, `discrepancy`, `refunded`)
- amount_collected_minor_units (nullable until collected)
- cash_collected_at (nullable)
- cash_handover_status
- delivery_address_snapshot
- customer_note
- created_at, accepted_at, delivered_at, updated_at

### order_items
- id, order_id, product_id
- product_name_snapshot
- quantity
- unit_price_minor_units
- line_total_minor_units

### order_events
- id, order_id
- old_status, new_status
- actor_user_id
- note
- created_at

### delivery_fee_rules
- id, service_area_id
- fee_minor_units
- minimum_order_minor_units
- is_active
- effective_from, effective_to

### notifications
- id, user_id, order_id
- channel, title, body, sent_at, read_at, delivery_status

## Critical rules
- Never trust totals sent by the mobile app; calculate prices, discounts, fees and totals on the server.
- Enforce Derik service-area membership during address save and again at checkout.
- A customer may read only their own orders; a courier may read only assigned orders; merchants may read orders belonging to their shop; admins require audited privileged access.
- Use server-side transactions for order creation and stock/availability checks.
- Keep order status history append-only.
- Store money as integer minor units plus an explicit currency code; do not use floating-point arithmetic for money.


## Cash reconciliation extension
Consider a `courier_cash_handover` table:
- id, courier_id, admin_user_id
- amount_minor_units, currency_code
- handed_over_at, received_at
- status (`pending`, `confirmed`, `disputed`)
- notes and audit timestamps

Cash collection records must be immutable or append-only and traceable to an order.
