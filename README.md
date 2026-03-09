# 🌟 دليلك - Dalilak App

تطبيق Flutter حديث لاستكشاف أفضل المتاجر والخدمات حول بك، دون الحاجة لتسجيل الدخول.

## 📱 الميزات الرئيسية

✅ **عرض الإعلانات** - عرض إعلانات ممولة بصيغة carousel  
✅ **التصنيفات الهرمية** - استعرض التصنيفات بشكل منظم مع البحث  
✅ **المحتويات والقوائم** - عرض المحتويات مع pagination وفلترة  
✅ **البحث المتقدم** - ابحث عن المحتويات مع فلاتر متعددة  
✅ **التفاصيل الكاملة** - عرض صور، بيانات الاتصال، الوسائل الاجتماعية  
✅ **المفضلة** - حفظ المحتويات المفضلة محلياً  
✅ **الإشعارات** - عرض الإشعارات من الـ backend  
✅ **الإعدادات** - تغيير اللغة والمظهر  
✅ **RTL/LTR Support** - دعم كامل للعربية والإنجليزية  
✅ **Dark Mode** - دعم الوضع الليلي  

## 🏗️ البنية المعمارية

```
lib/
├── config/              # إعدادات التطبيق
│   ├── app_theme.dart   # Theming (Light/Dark)
│   └── routing_config.dart # Navigation (GoRouter)
├── constants/           # الثوابت والقيم الثابتة
├── models/              # Freezed data models
├── services/            # API client و repositories
├── providers/           # Riverpod providers (state management)
├── screens/             # جميع شاشات التطبيق
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
├── widgets/             # Reusable widgets
├── utils/               # Utilities و exceptions
└── l10n/               # Localization files (ARB)
```

## 🚀 البدء السريع

### متطلبات النظام
- Flutter 3.4.4+
- Dart 3.4.4+
- Android SDK 21+ أو iOS 11+

### التثبيت والتشغيل

```bash
# الانتقال إلى مجلد المشروع
cd dalilak_app

# تثبيت المكتبات
flutter pub get

# توليد الملفات المولدة (Freezed, JSON Serializable)
flutter pub run build_runner build

# توليد ملفات الـ localization
flutter gen-l10n

# التشغيل على جهاز أو محاكي
flutter run

# للتشغيل على جهاز محدد
flutter run -d <device_id>

# الوضع الإصدار (optimized)
flutter run --release
```

## 📚 الهندسة والمكتبات

### State Management
- **Riverpod (2.6.1)** - إدارة الحالة الحديثة والـ Providers
- **Flutter Hooks (0.21.0)** - React-style hooks

### HTTP & API
- **Dio (5.9.1)** - HTTP client متقدم مع interceptors
- **Retrofit (4.5.0)** - REST API wrapper (جاهز للاستخدام)

### Navigation
- **GoRouter (13.2.5)** - Declarative routing مع deep linking

### Data Models
- **Freezed (2.5.2)** - Code generation للـ models immutable
- **JSON Serializable (6.8.0)** - تحويل JSON

### Storage
- **Hive (2.2.3)** - Local NoSQL database (للـ caching مستقبلاً)
- **SharedPreferences (2.3.3)** - للبيانات البسيطة (language, theme)

### UI & Design
- **Material 3** - Modern Material Design
- **Google Fonts (6.3.0)** - Cairo font للعربية

### Images & Media
- **Cached Network Image (3.4.1)** - تخزين مؤقت للصور
- **URL Launcher (6.3.1)** - فتح الروابط والاتصالات

### Localization
- **Flutter Localizations** - دعم RTL والعربية

## 🔌 تكامل الـ API

### إعدادات العميل

```dart
// في app_constants.dart
static const String apiBaseUrl = 'http://localhost:1996/api/v1';
static const String apiTimeout = '30000'; // milliseconds
```

### Endpoints المدعومة

```
# التصنيفات
GET  /categories          - إحضار جميع التصنيفات
GET  /categories/:id      - تفاصيل تصنيف واحد

# المحتويات
GET  /listings            - إحضار المحتويات (مع pagination)
GET  /listings/:id        - تفاصيل محتوى واحد
POST /listings/:id/view   - تقسيل عدد المشاهدات

# البحث
GET  /search?q=...        - البحث عن محتويات

# البيانات الثابتة
GET  /governorates        - إحضار المحافظات
GET  /ads                 - إحضار الإعلانات
GET  /notifications       - إحضار الإشعارات
```

### أمثلة الاستخدام

```dart
// استخدام الـ repository
final repository = ref.watch(dalilakRepositoryProvider);

// جلب المحتويات
final listings = await repository.getListings(
  page: 1,
  limit: 20,
  categoryId: 5,
);

// جلب التفاصيل
final detail = await repository.getListingById(123);

// البحث
final results = await repository.searchListings(
  query: 'مطعم',
  page: 1,
);
```

## 🎨 الثيم والألوان

### الألوان الأساسية
```dart
Primary:   #2E7D32 (أخضر - للعناصر الرئيسية)
Secondary: #1565C0 (أزرق - للعناصر الثانوية)
Tertiary:  #FF6F00 (برتقالي - للمميز والنقاط اللافتة)
Error:     #D32F2F (أحمر - للأخطاء والحذف)
```

### الخطوط
- استخدام **Cairo** font من Google Fonts
- حجم العناوين المختلفة للمراتب المختلفة
- دعم كامل للنصوص العربية

## 📱 الشاشات الرئيسية

### 🟣 Splash Screen
- شاشة البداية مع logo التطبيق
- تحقق من تسجيل الدخول الأول

### 📖 Onboarding Screen
- 4 شاشات ترحيبية تشرح استخدام التطبيق
- PageView مع مؤشرات
- خيارات Skip و Next و Finish

### 🏠 Home Screen
- Carousel للإعلانات (auto-scroll)
- أفضل التصنيفات (grid)
- آخر الإضافات (cards)
- روابط سريعة لـ View All

### 📂 Categories Screen
- عرض التصنيفات بشكل هرمي
- توسيع/طي التصنيفات الفرعية
- بحث فوري عن التصنيفات
- تنقل مباشر إلى listings

### 📋 Listings Screen
- listView من المحتويات (cards)
- صورة + اسم + تصنيف + موقع
- pagination (التالي/السابق)
- فلاتر (مميز فقط)
- ترتيب (الأحدث، الأكثر شهرة، المميز)
- ديناميكي حسب categoryId و governorateId

### 🔍 Search Screen
- بحث فوري مع suggestions
- فلاتر (المحافظة)
- عرض النتائج وقتياً
- حالات فارغة وخطأ
- معاينات سريعة

### 📄 Listing Detail Screen
- عرض كامل للمحتوى
- PageView للصور مع مؤشرات
- بيانات الاتصال (هاتف، واتس، بريد، موقع)
- الوسائل الاجتماعية (إنستجرام، فيسبوك، تيك توك)
- العنوان والوصف
- إضافة/إزالة من المفضلة
- مشاركة (share intent)
- عدد المشاهدات

### ❤️ Favorites Screen
- عرض العناصر المفضلة المحفوظة محلياً
- إزالة من المفضلة
- روابط سريعة للتفاصيل

### 🔔 Notifications Screen
- عرض الإشعارات من الـ API
- صور و نصوص
- روابط ديناميكية (listing، URL)
- حالات فارغة

### ⚙️ Settings Screen
- **اللغة**: عربي / إنجليزي
- **المظهر**: فاتح / غامق / تلقائي
- **حول**: معلومات التطبيق والإصدار
- **روابط**: سياسة الخصوصية، شروط وأحكام
- **إجراءات**: قيّم التطبيق، مشاركة

## 🔄 State Management (Riverpod)

### صيغة الاستخدام

```dart
// مشاهدة البيانات (reading)
final data = ref.watch(listingsProvider(params));

// التعامل مع الحالات
data.when(
  loading: () => LoadingWidget(),
  error: (err, stack) => ErrorWidget(),
  data: (listings) => ListingsWidget(listings),
);

// تحديث البيانات (refreshing)
ref.refresh(listingsProvider(params));

// تعديل الحالة (المفضلة)
ref.read(favoritesProvider.notifier).toggleFavorite(id);
```

### الـ Providers المتوفرة

```dart
// Data providers
categoriesProvider
governoratesProvider
listingsProvider(params)
listingByIdProvider(id)
searchListingsProvider(params)
notificationsProvider
adsProvider

// Favorites provider
favoritesProvider

// App providers
localeProvider          # تخزين اللغة
themeModeProvider       # تخزين المظهر
appInitializerProvider  # تهيئة التطبيق
```

## 🌍 دعم اللغات

### اللغات المدعومة
- **العربية** (RTL)
- **الإنجليزية** (LTR)

### ملفات الـ Localization
```
lib/l10n/
├── app_ar.arb  - النصوص العربية
└── app_en.arb  - النصوص الإنجليزية
```

### إضافة نصوص جديدة

1. عدّل `lib/l10n/app_ar.arb` و `app_en.arb`:
```json
{
  "myNewKey": "القيمة العربية"
}
```

2. شغّل الأمر:
```bash
flutter gen-l10n
```

3. استخدم في الكود:
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// في build method
AppLocalizations.of(context)?.myNewKey
```

## 🔐 معالجة الأخطاء

### أنواع الـ Exceptions

```dart
AppException         - خطأ عام
└─ ApiException      - خطأ من الـ API
   NetworkException  - مشاكل الشبكة
   CacheException    - مشاكل التخزين المؤقت
```

### مثال على معالجة الأخطاء

```dart
try {
  final listings = await repository.getListings();
} on ApiException catch (e) {
  print('API Error: ${e.message}');
} on NetworkException catch (e) {
  print('Network Error: ${e.message}');
} catch (e) {
  print('Unknown Error: $e');
}
```

## 📦 البناء والنشر

### بناء الملفات المولدة

```bash
# بناء كامل
flutter pub run build_runner build --delete-conflicting-outputs

# الوضع المراقب (يعيد البناء عند التغيير)
flutter pub run build_runner watch
```

### بناء APK (Android)

```bash
# development
flutter build apk

# release (optimized)
flutter build apk --release
```

### بناء App Bundle (Google Play)

```bash
flutter build appbundle --release
```

### بناء iOS

```bash
flutter build ios --release
```

## ✅ الاختبار والجودة

```bash
# تحليل الكود
flutter analyze

# تشغيل اختبارات الوحدة
flutter test

# إصلاح الكود تلقائياً
dart format lib/

# فحص المشاكل
flutter doctor
```

## 🚧 المميزات القادمة (Phase 5-9)

- [ ] **Phase 5**: Listing Detail (مكتملة بنسبة 90%)
- [ ] **Phase 6**: Caching مع Hive، Offline support
- [ ] **Phase 7**: تحسين الـ theming والـ accessibility
- [ ] **Phase 8**: Polish، animations، UX improvements
- [ ] **Phase 9**: Unit tests، widget tests، CI/CD

## 🐛 استكشاف الأخطاء

### المشكلة: Build Runner خطأ
```bash
# الحل
flutter clean
rm -rf pubspec.lock
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### المشكلة: Package not imported
```bash
# تأكد من تشغيل
flutter pub get
flutter pub run build_runner build
```

### المشكلة: Localization لا تعمل
```bash
# تأكد من تشغيل
flutter gen-l10n
```

## 📄 الترخيص

جميع الحقوق محفوظة © 2026 **دليلك**

## 👥 المساهمة

للمساهمة في المشروع:
1. انسخ المشروع (`git clone`)
2. أنشئ فرع جديد (`git checkout -b feature/AmazingFeature`)
3. التزم التغييرات (`git commit -m 'وصف الميزة'`)
4. ادفع الفرع (`git push origin feature/AmazingFeature`)
5. افتح Pull Request

## 📞 التواصل والدعم

للأسئلة والاقتراحات:
- البريد: support@dalilak.app
- الموقع: https://dalilak.app

---

**تم بناء هذا التطبيق بـ ❤️ مع Flutter**

آخر تحديث: فبراير 2026
