# Phase 6 - Caching & Offline Support

## نظرة عامة

تم إضافة دعم شامل للـ Caching و Offline Mode باستخدام Hive و Connectivity Plus.

## المكونات الرئيسية

### 1. **CacheService** (`lib/services/cache_service.dart`)

خدمة مركزية لإدارة جميع عمليات التخزين المؤقت.

**الميزات:**
- تخزين مؤقت ذكي مع TTL (Time To Live)
- Cache TTL الافتراضي: 1 ساعة (3600000ms)
- دعم تخزين مؤقت لـ:
  - التصنيفات
  - المحافظات
  - المحتويات (مع pagination)
  - الإعلانات
  - الإشعارات
  - نتائج البحث

**مثال الاستخدام:**
```dart
final cacheService = CacheService();
await cacheService.init();

// Cache data
await cacheService.cacheCategories(categories);

// Get cached data
final cached = await cacheService.getCachedCategories();

// Clear cache
await cacheService.clearAllCache();
```

**Cache Keys Format:**
- Categories: `categories`
- Governorates: `governorates`
- Listings: `listings_p1_l20` (page and limit)
- Listing Detail: `listing_detail_123` (بـ ID)
- Search: `search_query_p1` (query and page)
- Ads: `ads`
- Notifications: `notifications`

### 2. **ConnectivityService** (`lib/services/connectivity_service.dart`)

خدمة للتحقق من الاتصال بالإنترنت في الوقت الفعلي.

**الميزات:**
- التحقق الفوري من الاتصال
- مراقبة مستمرة لحالة الاتصال
- معالجة أخطاء آمنة

**مثال الاستخدام:**
```dart
final conectivityService = ConnectivityService();

// Check current connection status
final isConnected = await connectivityService.isConnected();

// Listen to connectivity changes
connectivityService.onConnectivityChanged.listen((isConnected) {
  print('Connected: $isConnected');
});
```

### 3. **Connectivity Providers** (`lib/providers/connectivity_providers.dart`)

Riverpod providers للتعامل مع الـ connectivity و cache.

**الـ Providers الرئيسية:**
- `isConnectedProvider` - StreamProvider يتابع تغييرات الاتصال
- `connectivityStatusProvider` - FutureProvider للتحقق الفوري
- `offlineModeProvider` - StateProvider لتتبع وضع Offline
- `cacheServiceProvider` - توفر CacheService
- `connectivityServiceProvider` - توفر ConnectivityService

**مثال الاستخدام في Widgets:**
```dart
final isConnectedAsync = ref.watch(isConnectedProvider);

isConnectedAsync.when(
  loading: () => const LoadingWidget(),
  error: (error, stack) => const SizedBox.shrink(),
  data: (isConnected) {
    if (!isConnected) {
      return const Text('No Internet Connection');
    }
    return const Text('Online');
  },
);
```

### 4. **Offline Indicator Widget** (`lib/widgets/offline_indicator.dart`)

رسالة بصرية تظهر عند انقطاع الإنترنت.

- يظهر تحت الـ AppBar عند انقطاع الاتصال
- يختفي تلقائياً عند استعادة الاتصال
- يعرض رسالة واضحة عن استخدام البيانات المحفوظة

## تكامل Repository

تم تحديث `DalilakRepository` لاستخدام الـ caching و offline detection:

```dart
Future<List<Category>> getCategories() async {
  // 1. محاولة استرجاع من الـ cache أولاً
  final cached = await _cacheService.getCachedCategories();
  if (cached != null) {
    return cached;
  }

  // 2. التحقق من الاتصال
  final isConnected = await _connectivityService.isConnected();
  if (!isConnected) {
    throw NetworkException(
      message: 'No internet connection',
      code: 'NO_INTERNET',
    );
  }

  // 3. محاولة جلب البيانات من API
  try {
    final response = await _apiClient.get(...);
    final data = _parseResponse(response);
    
    // 4. تخزين مؤقت للبيانات
    await _cacheService.cacheCategories(data);
    
    return data;
  } catch (e) {
    // 5. الرجوع للـ cache كحل بديل في حالة الخطأ
    final fallback = await _cacheService.getCachedCategories();
    if (fallback != null) {
      return fallback;
    }
    rethrow;
  }
}
```

## Flow الـ Offline Mode

```
┌─────────────────────────────────────────┐
│ User requests data (from UI)            │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│ Check cache validity                    │
│ (TTL < 1 hour?)                        │
└─────────────┬───────────────────────────┘
              │
         Yes  │ No
         ├────┴────┐
         │         │
         ▼         ▼
      Return   Check connectivity
      Cache    ┌──────────────┐
              │ Connected?   │
              └──┬────────┬──┘
                 │ No     │ Yes
                 │        │
          Exception  API Call
          ┌──────────────┐
          │ Online→Cache?│
          │ (If success) │
          └──────┬───────┘
                 │
                 ▼
            Return Data
```

## Cache TTL Management

### تعيين TTL مخصص:

الـ TTL الحالي ثابت في `CacheService`:
```dart
static const int cacheTtlMs = 3600000; // 1 ساعة
```

لتغييره، عدّل هذا الثابت:
```dart
// لـ 30 دقيقة
static const int cacheTtlMs = 1800000;

// لـ 24 ساعة
static const int cacheTtlMs = 86400000;
```

### تنظيف الـ Cache المنتهي الصلاحية:

```dart
// في initstate أو عند بدء التطبيق
await cacheService.clearExpiredCache();
```

## معالجة الأخطاء

### أنواع الاستثناءات:

```dart
try {
  final listings = await repository.getListings();
} on NetworkException catch (e) {
  // لا يوجد إنترنت - استخدم الـ cache أو أظهر رسالة
  print('Network error: ${e.message}');
} on ApiException catch (e) {
  // خطأ من الـ API
  print('API error: ${e.message}');
} on CacheException catch (e) {
  // مشكلة في الـ cache
  print('Cache error: ${e.message}');
}
```

## Best Practices

### 1. **استخدام الـ Offline Indicator**
```dart
// أضفها في أعلى Scaffold
appBar: PreferredSize(
  preferredSize: const Size.fromHeight(40),
  child: const OfflineIndicator(),
),
```

### 2. **التحقق من الاتصال قبل العمليات الحساسة**
```dart
final isConnected = ref.watch(connectivityStatusProvider);

isConnected.when(
  data: (connected) {
    if (!connected) {
      // اعرض رسالة خطأ
      return const Text('Please connect to internet to perform this action');
    }
    // نفّذ العملية
  },
);
```

### 3. **تحديث الـ Cache يدوياً عند الحاجة**
```dart
// بعد تحديث البيانات
await cacheService.cacheCategories(newCategoriesData);

// أو مسح الـ cache وإعادة جلب البيانات
await cacheService.clearAllCache();
ref.refresh(categoriesProvider);
```

### 4. **استخدام Fallback Data**
```dart
// في حالة فشل الاتصال، الـ Repository يحاول استرجاع الـ cached data
// إذا لم يكن هناك cache، سيُرفع استثناء
```

## ملاحظات مهمة

⚠️ **Cache Persistence:**
- البيانات المحفوظة توجد في Hive boxes محليّة على الجهاز
- يتم ذلك بشكل آمن بدون تشفير خصوصي

⚠️ **TTL Management:**
- الـ TTL الافتراضي ساعة واحدة
- يمكن تكييفه حسب احتياجات التطبيق

⚠️ **Memory Usage:**
- Cache التخزين محدود بحجم الذاكرة المتاحة
- يمكن مسح الـ cache يدوياً عند الحاجة

## التطبيق العملي

### مثال كامل:

```dart
// 1. في main.dart - تهيئة الـ Cache
Future<void> _initializeApp() async {
  final cacheService = CacheService();
  await cacheService.init();
}

// 2. في Provider - استخدام الـ Connectivity
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getCategories();
  // التخزين المؤقت يحدث تلقائياً داخل Repository
});

// 3. في Widget - عرض البيانات
Widget build(BuildContext context, WidgetRef ref) {
  final categoriesAsync = ref.watch(categoriesProvider);
  
  return categoriesAsync.when(
    loading: () => const Loading(),
    error: (error, stack) => ErrorWidget(error: error),
    data: (categories) => ListView(
      children: categories.map((c) => ListTile(title: Text(c.name))).toList(),
    ),
  );
}
```

## ملخص الملفات المضافة

| الملف | الوصف |
|------|-------|
| `lib/services/cache_service.dart` | خدمة الـ Caching |
| `lib/services/connectivity_service.dart` | خدمة الاتصال |
| `lib/providers/connectivity_providers.dart` | Riverpod providers |
| `lib/widgets/offline_indicator.dart` | واجهة الـ Offline |

## ما التالي؟

✅ **Phase 6 مكتملة!**

المرحلة القادمة:
- **Phase 7**: Polish & RTL Testing - تحسين الـ UI والـ RTL
- **Phase 8**: Unit & Widget Tests - اختبار الوحدات
- **Phase 9**: CI/CD & Documentation - التوثيق النهائي

---

**الحالة:** جاهز للإنتاج مع دعم كامل للـ Offline Mode ✨
