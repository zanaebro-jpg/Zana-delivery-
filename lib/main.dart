import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Publishable key only. Never put an sb_secret key in a mobile app.
const supabaseUrl = 'https://znqdnpnxbamjgdilhnhw.supabase.co';
const supabasePublishableKey = 'sb_publishable_ka7iKeFB65WmB0YvFzcXEQ_g3WrZGoL';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabasePublishableKey);
  runApp(const ZanaDeliveryApp());
}

const brandRed = Color(0xFFC5161D);
const darkRed = Color(0xFF991015);
const paleRed = Color(0xFFFFF1F1);

class ZanaDeliveryApp extends StatefulWidget {
  const ZanaDeliveryApp({super.key});

  @override
  State<ZanaDeliveryApp> createState() => _ZanaDeliveryAppState();
}

class _ZanaDeliveryAppState extends State<ZanaDeliveryApp> {
  bool isArabic = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zana Delivery',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: brandRed),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        fontFamily: isArabic ? null : 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: darkRed,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: HomeScreen(
        isArabic: isArabic,
        onLanguageChanged: (value) => setState(() => isArabic = value),
      ),
    );
  }
}

class DeliveryCategory {
  final IconData icon;
  final String ar;
  final String en;
  const DeliveryCategory(this.icon, this.ar, this.en);
}

const categories = <DeliveryCategory>[
  DeliveryCategory(Icons.restaurant, 'مطاعم', 'Restaurants'),
  DeliveryCategory(Icons.shopping_basket, 'سوبر ماركت', 'Groceries'),
  DeliveryCategory(Icons.local_pharmacy, 'صيدليات', 'Pharmacies'),
  DeliveryCategory(Icons.inventory_2, 'طرود وشحن', 'Parcels'),
  DeliveryCategory(Icons.local_mall, 'متاجر', 'Shops'),
  DeliveryCategory(Icons.delivery_dining, 'توصيل سريع', 'Express'),
];

class HomeScreen extends StatefulWidget {
  final bool isArabic;
  final ValueChanged<bool> onLanguageChanged;
  const HomeScreen({
    super.key,
    required this.isArabic,
    required this.onLanguageChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  String search = '';

  String t(String ar, String en) => widget.isArabic ? ar : en;
  TextDirection get pageDirection =>
      widget.isArabic ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: pageDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset(
                  'assets/zana_logo.png',
                  width: 43,
                  height: 43,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.delivery_dining, color: brandRed, size: 34,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Zana Delivery',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                  Text('زانا دليفري',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => widget.onLanguageChanged(!widget.isArabic),
              child: Text(widget.isArabic ? 'EN' : 'عربي',
                style: const TextStyle(color: brandRed, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              tooltip: t('الإشعارات', 'Notifications'),
              onPressed: () => _notice(t('الإشعارات ستتوفر بعد ربط الخادم.',
                  'Notifications will be enabled after backend integration.')),
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: IndexedStack(
          index: selectedTab,
          children: [
            _homeContent(),
            _simplePage(Icons.receipt_long, t('طلباتي', 'My orders'),
                t('ستظهر طلباتك هنا بعد تسجيل الدخول.', 'Your orders will appear here after sign-in.')),
            _simplePage(Icons.favorite_border, t('المفضلة', 'Favorites'),
                t('احفظ متاجرك ومنتجاتك المفضلة هنا.', 'Save your favorite shops and products here.')),
            _simplePage(Icons.person_outline, t('حسابي', 'My account'),
                t('ملفك الشخصي وعناوينك ووسائل الدفع.', 'Your profile, addresses and payment methods.')),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedTab,
          onDestinationSelected: (i) => setState(() => selectedTab = i),
          indicatorColor: paleRed,
          destinations: [
            NavigationDestination(icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: brandRed),
              label: t('الرئيسية', 'Home')),
            NavigationDestination(icon: const Icon(Icons.receipt_long_outlined),
              label: t('طلباتي', 'Orders')),
            NavigationDestination(icon: const Icon(Icons.favorite_border),
              label: t('المفضلة', 'Favorites')),
            NavigationDestination(icon: const Icon(Icons.person_outline),
              label: t('حسابي', 'Account')),
          ],
        ),
      ),
    );
  }

  Widget _homeContent() {
    final visible = categories.where((c) =>
      (widget.isArabic ? c.ar : c.en).toLowerCase().contains(search.toLowerCase())
    ).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [brandRed, darkRed],
              begin: Alignment.topRight, end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('أهلاً بك في زانا!', 'Welcome to Zana!'),
                style: const TextStyle(color: Colors.white, fontSize: 22,
                  fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(t('كل ما تحتاجه، يصلك لباب بيتك.',
                  'Everything you need, delivered to your door.'),
                style: const TextStyle(color: Colors.white, fontSize: 13)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(13)),
                child: TextField(
                  onChanged: (v) => setState(() => search = v),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: t('ابحث عن مطعم أو متجر أو منتج',
                        'Search restaurants, shops or products'),
                    prefixIcon: const Icon(Icons.search, color: brandRed),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t('تسوّق حسب القسم', 'Shop by category'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text(t('عرض الكل', 'See all'),
              style: const TextStyle(color: brandRed, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visible.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final item = visible[index];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StoresPage(
                  isArabic: widget.isArabic,
                  category: widget.isArabic ? item.ar : item.en,
                ),
              )),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0E2E2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25, backgroundColor: paleRed,
                      child: Icon(item.icon, color: brandRed, size: 27),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.isArabic ? item.ar : item.en,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF0E2E2))),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: brandRed, size: 30),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('مدينة التوصيل', 'Delivery city'),
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text(t('ديرك (المالكية) – سوريا',
                      'Derik (Al-Malikiyah) – Syria'),
                    style: const TextStyle(color: brandRed, fontSize: 13,
                      fontWeight: FontWeight.w700)),
                  Text(t('سيتم تحديد الأحياء ونطاق التوصيل عند الإعداد.',
                      'Neighborhoods and delivery zones will be configured next.'),
                    style: const TextStyle(color: Colors.black54, fontSize: 11)),
                ],
              )),
              const Icon(Icons.chevron_left, color: brandRed),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(t('قريباً على زانا', 'Coming soon to Zana'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(t('عروض المتاجر، تتبع مباشر، والدفع الإلكتروني عند توفر مزودي الخدمة.',
            'Store offers, live tracking and online payments as providers become available.'),
          style: const TextStyle(color: Colors.black54, height: 1.5)),
      ],
    );
  }

  Widget _simplePage(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: brandRed, size: 58),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54)),
        ]),
      ),
    );
  }

  void _notice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class StoresPage extends StatefulWidget {
  final bool isArabic;
  final String category;
  const StoresPage({super.key, required this.isArabic, required this.category});

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
  late Future<List<Map<String, dynamic>>> storesFuture;

  @override
  void initState() {
    super.initState();
    storesFuture = _loadStores();
  }

  Future<List<Map<String, dynamic>>> _loadStores() async {
    final rows = await Supabase.instance.client
        .from('stores')
        .select('id,name,category,description,address,image_url')
        .eq('is_active', true)
        .order('name');
    return List<Map<String, dynamic>>.from(rows);
  }

  String tr(String ar, String en) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.category)),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: storesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: brandRed));
            }
            if (snapshot.hasError) {
              return _message(Icons.wifi_off, tr('تعذر تحميل المتاجر. تحقق من الاتصال ثم أعد المحاولة.', 'Could not load stores. Check your connection and retry.'));
            }
            final stores = snapshot.data ?? [];
            if (stores.isEmpty) {
              return _message(Icons.storefront_outlined, tr('لا توجد متاجر مضافة حالياً في ديرك. ستظهر هنا بعد أن يضيفها المدير.', 'No stores have been added in Derik yet. They will appear here when the administrator adds them.'));
            }
            return RefreshIndicator(
              color: brandRed,
              onRefresh: () async => setState(() => storesFuture = _loadStores()),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: stores.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: paleRed,
                        child: Icon(Icons.storefront, color: brandRed),
                      ),
                      title: Text((store['name'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text([
                        (store['category'] ?? '').toString(),
                        (store['address'] ?? '').toString()
                      ].where((v) => v.isNotEmpty).join(' • ')),
                      trailing: const Icon(Icons.chevron_left, color: brandRed),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ProductsPage(
                          isArabic: widget.isArabic,
                          store: store,
                        ),
                      )),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _message(IconData icon, String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 54, color: brandRed),
        const SizedBox(height: 14),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(height: 1.5)),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => setState(() => storesFuture = _loadStores()),
          icon: const Icon(Icons.refresh),
          label: Text(tr('إعادة المحاولة', 'Retry')),
        ),
      ]),
    ),
  );
}

class ProductsPage extends StatefulWidget {
  final bool isArabic;
  final Map<String, dynamic> store;
  const ProductsPage({super.key, required this.isArabic, required this.store});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Map<String, dynamic>>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = _loadProducts();
  }

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    final rows = await Supabase.instance.client
        .from('products')
        .select('id,name,description,price,image_url')
        .eq('store_id', widget.store['id'])
        .eq('is_available', true)
        .order('name');
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Widget build(BuildContext context) {
    final ar = widget.isArabic;
    return Directionality(
      textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text((widget.store['name'] ?? '').toString())),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: brandRed));
            }
            if (snapshot.hasError) {
              return Center(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(ar ? 'تعذر تحميل المنتجات. حاول مرة أخرى.' : 'Could not load products. Please retry.'),
              ));
            }
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return Center(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(ar ? 'لا توجد منتجات متاحة في هذا المتجر حالياً.' : 'No available products in this store yet.', textAlign: TextAlign.center),
              ));
            }
            return RefreshIndicator(
              color: brandRed,
              onRefresh: () async => setState(() => productsFuture = _loadProducts()),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final p = products[index];
                  final price = p['price'];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: paleRed,
                        child: Icon(Icons.fastfood_outlined, color: brandRed),
                      ),
                      title: Text((p['name'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text((p['description'] ?? '').toString()),
                      trailing: Text(price == null ? '' : '$price', style: const TextStyle(color: brandRed, fontWeight: FontWeight.w800)),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
