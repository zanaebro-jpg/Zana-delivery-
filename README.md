# Zana Delivery — Flutter starter

This is the first customer-app UI scaffold for Zana Delivery. Initial launch city: Derik (Al-Malikiyah), Syria.

## Included
- Flutter app targeting Android and iOS
- Arabic-first UI with Arabic/English toggle
- Brand red/white visual theme
- Uploaded Zana logo asset
- Home screen, service categories, search field, and bottom navigation placeholders

## Run locally
1. Install Flutter SDK and Android Studio / Xcode.
2. Create a Flutter project or place these files in a Flutter project root.
3. Run `flutter pub get`.
4. Run `flutter run`.

## Important: not production-ready yet
This starter is the customer-facing UI foundation only. A real launch still needs:
- Secure backend, database, authentication and role permissions
- Merchant and courier apps/portals
- Admin dashboard
- Live order state machine and courier assignment
- Maps/geocoding and push notifications
- Payment provider integrations suitable for Syria, plus cash on delivery
- Hosting, backups, monitoring, privacy policy, terms and store deployment

Before integrating payment or maps providers, confirm availability and legal/commercial requirements in the Syrian launch city.


## Project planning documents
- `docs/PRODUCT_SPEC.md` — product scope and launch requirements
- `docs/DATA_MODEL.md` — suggested database entities and critical security rules
- `docs/API_PLAN.md` — suggested API endpoints and server-side validation

The city restriction is intended to be enforced by the backend service-area boundary, not by trusting the phone app alone.

- `docs/PAYMENT_POLICY.md` — cash-on-delivery-only launch workflow and reconciliation rules


## Build an Android APK from a phone (cloud build)
This project includes `.github/workflows/android-apk.yml`.
1. Create a GitHub repository.
2. Upload the *contents* of this project folder to the repository root (including the hidden `.github` folder).
3. Open the repository's Actions tab.
4. Select **Build Zana Delivery APK**, choose **Run workflow**, and run it on `main`.
5. When it completes, open the workflow run and download the `zana-delivery-android-apk` artifact.
6. Extract the downloaded artifact ZIP and install `app-release.apk` on your Android phone.

The workflow generates the Android platform folder in the cloud, resolves packages and builds a release APK. The resulting APK is an unsigned-for-store testing build; Play Store publishing requires a properly signed release and production readiness work.


## Update: Supabase client and Zana launcher icon
- Added the `supabase_flutter` package and initialized the app with the project's URL and publishable key.
- Added the provided red Zana Delivery logo as the Android/iOS launcher icon, generated during the GitHub Actions build.
- The secret key is intentionally not included.

## Important status
This is an integration foundation, not a production-ready backend. It does **not yet** implement admin login, role verification, store CRUD, customer registration, or order management. Before adding those, verify the actual `profiles`, `stores`, and `orders` schemas and RLS policies in Supabase. The publishable key is safe to ship only with correctly configured RLS and grants.
