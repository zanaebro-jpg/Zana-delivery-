# Zana Delivery — Product & Launch Specification

## Launch decision
- Brand: Zana Delivery (زانا دليفري)
- Initial market: Derik / Al-Malikiyah, Al-Hasakah Governorate, Syria
- Initial service boundary: inside Derik city only
- Platforms: Android and iOS
- Languages: Arabic (default, RTL) and English (LTR)
- Service scope: restaurants, groceries, pharmacies, shops, parcels and express delivery
- Initial payment approach: cash on delivery only; no electronic payment options in the first release

## Applications and roles
1. Customer app: browse, search, cart, addresses, checkout, order tracking, support and order history.
2. Courier app: onboarding, availability, assigned offers, pickup/drop-off workflow, navigation, delivery confirmation and earnings.
3. Merchant portal/app: catalog, availability, prices, incoming orders, preparation status and sales.
4. Admin dashboard: customers, merchants, couriers, service categories, city zones, delivery fees, commissions, orders, refunds/cancellations, support and reporting.

## Derik-only service boundary
- The launch city is configured as a service area in the backend, not hard-coded as a permanent app limitation.
- Checkout must validate the customer's delivery pin/address against the enabled Derik service polygon or approved neighborhoods.
- If outside the enabled area, explain that service is not yet available and prevent checkout.
- Admin can later enable additional areas without publishing a new customer app version.
- Exact neighborhood names, boundary polygon, delivery fees and operating hours must be confirmed by the local operator before launch.

## Order lifecycle
`created -> merchant_accepted -> preparing -> ready_for_pickup -> courier_assigned -> picked_up -> on_the_way -> delivered`
Alternative terminal states: `rejected`, `cancelled`, `failed_delivery`.
Every status change must be timestamped and attributed to the actor who made it.

## Minimum launch requirements
- Phone-based sign-in with secure verification
- Role-based permissions for customer, courier, merchant and admin
- Merchant and courier approval by admin
- Product/service catalog with availability and price
- Cart and order total calculation on the server
- Delivery fee and commission rules controlled by admin
- Order status notifications
- Courier assignment and proof of delivery (PIN or other approved method)
- Support/contact flow
- Privacy policy, terms, retention policy and operational procedures
- Backups, monitoring, audit log and abuse prevention

## Important launch dependencies
This starter is a UI and specification foundation, not a production service. Before real orders, the project needs a deployed backend/database, admin and merchant/courier interfaces, maps/geocoding, push notifications, security review, device testing and app-store release work. Payment, SMS, map and hosting providers must be checked for actual availability, compliance and reliability in Syria.
