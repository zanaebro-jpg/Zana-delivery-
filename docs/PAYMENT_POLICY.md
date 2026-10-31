# Zana Delivery — Initial Payment Policy

## Approved launch payment method
**Cash on delivery only** for the first release in Derik (Al-Malikiyah), Syria.

## Customer checkout
- Show one payment method: Cash on delivery.
- Clearly show item subtotal, delivery fee, discounts (if any), and final amount due.
- The customer pays the courier in cash at delivery.
- Do not collect card, wallet, or bank details in the first release.
- Do not show electronic payment options until a provider is vetted, integrated, tested, and enabled by an administrator.

## Courier collection workflow
1. Courier sees the exact amount due before accepting/collecting the delivery.
2. Courier marks the order as delivered only after handing over the order and collecting the cash, subject to the configured proof-of-delivery procedure.
3. Record amount collected, collection timestamp, courier ID and order ID.
4. If the customer cannot pay or the amount differs, courier must flag the order for admin review rather than silently closing it.

## Admin reconciliation
- Admin can review cash due, cash collected, outstanding amounts, and courier cash handovers.
- Each cash collection and handover must have an audit record.
- Do not let couriers edit order totals.
- Refunds, partial deliveries, failed deliveries and cash discrepancies need explicit admin workflows.

## Money and currency
The business owner must confirm the operating currency and cash denomination rules before launch. Store all amounts as integer minor units with an explicit currency code; never use floating-point arithmetic for money. Do not assume a currency conversion rate.

## Production safeguards
- Server calculates final order total and delivery fee.
- Courier app receives read-only amount due.
- Cash collection is tied to a specific order.
- Role-based access prevents customers, merchants and couriers from changing financial records.
- Daily reconciliation report is available to authorized admins.
