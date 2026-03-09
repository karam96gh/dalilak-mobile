# 🚀 دليلك Flutter - دليل المطور

## المقدمة

تطبيق Flutter حديث ومتطور لاستكشاف أفضل المتاجر والخدمات. التطبيق يوفر تجربة مستخدم سلسة مع دعم كامل للعربية والإنجليزية.

## المتطلبات

- Flutter 3.4.4+
- Dart 3.4.4+
- Android SDK 21+ أو iOS 11+
- VS Code أو Android Studio

## البدء السريع

### 1. التثبيت

```bash
# استنساخ المشروع
git clone <repo-url>
cd dalilak_app

# تثبيت المكتبات
flutter pub get

# توليد الملفات المولدة
flutter pub run build_runner build

# (اختياري) توليد ملفات الـ localization
flutter gen-l10n

# التشغيل
flutter run
```

### 2. المتغيرات البيئية

لا توجد متغيرات بيئة مطلوبة - جميع الإعدادات في `lib/constants/app_constants.dart`

### 3. التشغيل على أجهزة مختلفة

```bash
# عرض الأجهزة المتاحة
flutter devices

# التشغيل على جهاز محدد
flutter run -d <device_id>

# الوضع الإصدار (optimized)
flutter run --release

# إنشاء APK للأندرويد
flutter build apk --release

# إنشاء IPA لـ iOS
flutter build ios --release
```

## البنية المعمارية

### الهيكل الأساسي

```
lib/
├── config/                  # الإعدادات والتكوينات
│   ├── app_theme.dart      # Theming (Colors, TextStyles)
│   └── routing_config.dart # Go Router Configuration
│
├── constants/              # الثوابت
│   └── app_constants.dart  # API URLs, Keys, etc.
│
├── models/                 # Freezed Data Models
│   ├── category_model.dart
│   ├── listing_model.dart
│   ├── governorate_model.dart
│   ├── notification_model.dart
│   ├── ad_model.dart
│   ├── review_model.dart
│   └── api_response_model.dart
│
├── services/               # API & Business Logic
│   ├── api_client.dart           # Dio HTTP Client
│   ├── cache_service.dart        # Hive Storage
│   ├── connectivity_service.dart # Network Check
│   └── dalilak_repository.dart   # API Repository
│
├── providers/              # Riverpod State Management
│   ├── app_providers.dart          # Locale, Theme, Prefs
│   ├── data_providers.dart         # Data & API Providers
│   └── connectivity_providers.dart # Network Providers
│
├── screens/                # جميع الشاشات
│   ├── splash/
│   ├── onboarding/
│   ├── home/
│   ├── categories/
│   ├── listings/
│   ├── search/
│   ├── listing_detail/
│   ├── favorites/
│   ├── notifications/
│   └── settings/
│
├── widgets/                # Reusable Widgets
│   ├── shimmer_skeletons.dart  # Loading Skeletons
│   └── offline_indicator.dart   # Network Status
│
├── utils/                  # Utilities
│   └── exceptions.dart     # Custom Exceptions
│
├── l10n/                   # Localization
│   ├── app_en.arb         # English
│   └── app_ar.arb         # العربية
│
└── main.dart              # Entry Point
```

### نمط العممارة

```
User Interface Layer (Screens + Widgets)
         ↓
State Management Layer (Riverpod Providers)
         ↓
Service Layer (Repository + Caching)
         ↓
API Client Layer (Dio + Interceptors)
         ↓
Backend API
```

## الميزات الرئيسية

### 1. المصادقة والأمان
- ✅ No authentication required (public viewing)
- ✅ JWT token handling ready (for future admin features)
- ✅ Secure local storage with Hive

### 2. إدارة البيانات
- ✅ Real-time data fetching
- ✅ Local caching with TTL
- ✅ Offline mode support
- ✅ Pagination support
- ✅ Advanced filtering

### 3. واجهة المستخدم
- ✅ Material Design 3
- ✅ RTL/LTR support (العربية/English)
- ✅ Dark Mode support
- ✅ Smooth animations
- ✅ Loading skeletons
- ✅ Error handling

### 4. الإدخالات والبحث
- ✅ عرض الإدخالات مع pagination
- ✅ تصفية حسب التصنيف والمحافظة
- ✅ بحث متقدم
- ✅ ترتيب (latest, popular, featured)
- ✅ عرض التفاصيل الكاملة

### 5. المفضلة
- ✅ حفظ محليً في SharedPreferences
- ✅ إدارة سهلة (إضافة/حذف)
- ✅ عرض صفحة منفصلة للمفضلة

### 6. الإشعارات
- ✅ عرض الإشعارات من الـ Backend
- ✅ فتح الروابط الخارجية
- ✅ التنقل لـ Listing إذا كان لديها linkId

### 7. وسائل التواصل
- ✅ الاتصال بالهاتف
- ✅ رسالة عبر WhatsApp
- ✅ بريد إلكتروني
- ✅ فتح الموقع الإلكتروني
- ✅ قنوات التواصل الاجتماعي

### 8. المشاركة
- ✅ Share listing details with others
- ✅ Native share sheet

## استخدام الـ API

### جلب البيانات

```dart
// في الـ Screen
final listingsAsync = ref.watch(listingsProvider(
  (page: 1, limit: 20, categoryId: 5, governorateId: null),
));

listingsAsync.when(
  loading: () => Shimmer.fromColors(...), // عرض skeleton
  error: (err, stack) => ErrorWidget(),
  data: (listings) => ListView(...), // عرض البيانات
);
```

### البحث

```dart
final searchAsync = ref.watch(searchListingsProvider(
  (
    query: 'مطعم',
    page: 1,
    limit: 20,
    categoryId: null,
    governorateId: 1,
  ),
));
```

### إدارة المفضلة

```dart
// إضافة/إزالة من المفضلة
ref.read(favoritesProvider.notifier).toggleFavorite(listingId);

// التحقق من هل هو مفضل
final isFavorite = ref.watch(
  favoritesProvider.select((fav) => fav.contains(listingId)),
);
```

## الـ Caching Strategy

### استراتيجية التخزين المؤقت

```dart
// الـ TTL: 1 ساعة (3600000 ملي ثانية)
// أي بيانات مخزنة مؤقتاً لمدة أكثر من ساعة يتم تحديثها

// عند الفشل:
1. محاولة جلب البيانات من الـ API
2. إذا فشلت: استخدام البيانات المخزنة مؤقتاً
3. إذا لم توجد بيانات محاطة: عرض خطأ
```

## الـ Offline Support

التطبيق يعمل بدون إنترنت مع البيانات المخزنة مؤقتاً:

```dart
// التحقق من الاتصال
final isConnected = await connectivityService.isConnected();

// عند عدم الاتصال:
- استخدام البيانات المخزنة مؤقتاً
- عرض رسالة "وضع بدون اتصال"
- محاولة الاتصال عند إعادة التحميل
```

## التطوير والإضافات

### إضافة شاشة جديدة

1. إنشاء المجلد: `lib/screens/new_screen/`
2. إنشاء الملف: `new_screen.dart`
3. إضافة المسار في `lib/config/routing_config.dart`

```dart
GoRoute(
  path: '/new-screen',
  builder: (context, state) => const NewScreen(),
),
```

### إضافة Provider جديد

```dart
// في lib/providers/data_providers.dart
final newDataProvider = FutureProvider<YourModel>((ref) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.fetchData();
});
```

### إضافة Service جديد

```dart
// في lib/services/
class MyService {
  Future<YourModel> fetchData() async {
    // Implementation
  }
}
```

## الـ Riverpod Patterns

### Pattern 1: Simple Future Provider

```dart
final dataProvider = FutureProvider<List<Item>>((ref) async {
  return await fetchData();
});
```

### Pattern 2: Family Provider (مع parameters)

```dart
final itemByIdProvider = FutureProvider.family<Item, int>((ref, id) async {
  return await fetchItem(id);
});
```

### Pattern 3: State Notifier (للحالة القابلة للتغيير)

```dart
final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<int>>((ref) {
  return FavoriteNotifier();
});
```

## اختبار التطبيق

### بمحاكي الـ Android

```bash
flutter emulators --launch Pixel_4_API_30
flutter run
```

### بمحاكي iOS

```bash
open -a Simulator
flutter run
```

### بجهاز حقيقي

```bash
flutter devices
flutter run -d <device_id>
```

## المشاكل الشائعة والحلول

### 1. خطأ في الاتصال بـ API
```
الحل:
- تأكد من تشغيل البكند على localhost:1996
- تأكد من الـ firewall لا يمنع الاتصال
- جرب على جهاز/محاكي مختلف
```

### 2. الصور لا تظهر
```
الحل:
- تأكد من الروابط صحيحة
- تحقق من الاتصال بالإنترنت
- امسح الـ cache وأعد التشغيل
```

### 3. المفضلة لا تحفظ
```
الحل:
- تأكد من SharedPreferences initialized
- تفقد أن الـ key صحيح
- امسح بيانات التطبيق وأعد
```

## أداء التطبيق

### نصائح التحسين

1. **استخدم `.select()`** لتقليل rebuilds
2. **استخدم `cached_network_image`** لتخزين مؤقت للصور
3. **استخدم `const` constructors** حيث أمكن
4. **تجنب القوائم الطويلة** بدون pagination
5. **استخدم Shimmer** بدلاً من spinners

## النشر

### Android

```bash
# إنشاء signing key
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# بناء APK
flutter build apk --release

# بناء App Bundle
flutter build appbundle --release
```

### iOS

```bash
# بناء IPA
flutter build ios --release

# إذا كنت تستخدم Xcode
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release
```

## المساهمة

1. Fork المشروع
2. إنشاء فرع: `git checkout -b feature/amazing-feature`
3. Commit التغييرات: `git commit -m 'Add amazing feature'`
4. Push الفرع: `git push origin feature/amazing-feature`
5. افتح Pull Request

## الترخيص

هذا المشروع مرخص تحت MIT License

## الدعم

للمساعدة والدعم، يرجى:
- فتح issue في GitHub
- التواصل عبر البريد الإلكتروني
- قراءة التوثيق الكاملة

---

**تم آخر تحديث:** 26 فبراير 2026
**الإصدار:** 1.0.0
