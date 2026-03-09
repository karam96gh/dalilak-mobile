# Testing Guide - Phase 8

This document outlines the comprehensive testing strategy for the Dalilak Flutter application, including unit tests, integration tests, and widget tests.

## Test Structure

```
test/
├── services/
│   ├── api_client_test.dart       # API client unit tests
│   ├── repository_test.dart        # Repository pattern tests with caching
│   └── cache_service_test.dart     # Cache service TTL & storage tests
├── models/
│   └── models_test.dart            # Data model serialization tests
├── screens/
│   ├── home_screen_test.dart       # Home screen widget tests
│   └── listings_screen_test.dart   # Listings screen widget tests
└── TESTING_GUIDE.md                # This file
```

## Unit Tests

### 1. API Client Tests (`test/services/api_client_test.dart`)

Tests for the Dio-based HTTP client with interceptors.

**Test Coverage:**
- ✅ GET request success (200 response)
- ✅ POST request with data
- ✅ PUT request for updates
- ✅ DELETE request
- ✅ Error handling (404 Not Found)
- ✅ Timeout handling (ConnectionTimeout)
- ✅ Server errors (500 Internal Server Error)
- ✅ Bad request handling (400 Bad Request)

**Run Command:**
```bash
flutter test test/services/api_client_test.dart -v
```

### 2. Repository Tests (`test/services/repository_test.dart`)

Tests for the DalilakRepository with caching and offline support.

**Test Coverage:**
- ✅ Returns cached data when available
- ✅ Fetches from API when cache is empty
- ✅ Throws NetworkException when offline
- ✅ Falls back to cache when API fails
- ✅ TTL-based cache expiration
- ✅ Refreshes expired cache from API
- ✅ Categories caching
- ✅ Governorates caching

**Run Command:**
```bash
flutter test test/services/repository_test.dart -v
```

### 3. Cache Service Tests (`test/services/cache_service_test.dart`)

Tests for Hive-based caching with TTL management.

**Test Coverage:**
- ✅ Caching and retrieving data
- ✅ Invalid JSON handling
- ✅ TTL validation (1 hour default)
- ✅ Expired cache detection
- ✅ Pagination cache key generation
- ✅ Search result caching

**Run Command:**
```bash
flutter test test/services/cache_service_test.dart -v
```

### 4. Models Tests (`test/models/models_test.dart`)

Tests for data model serialization and deserialization.

**Test Coverage:**
- ✅ Category fromJson/toJson
- ✅ Governorate fromJson/toJson
- ✅ Listing fromJson/toJson
- ✅ ListingImage serialization
- ✅ Category hierarchy (parent-child relationships)
- ✅ Model equality
- ✅ Field validation

**Run Command:**
```bash
flutter test test/models/models_test.dart -v
```

## Widget Tests

### 1. Home Screen Tests (`test/screens/home_screen_test.dart`)

Tests for HomeScreen widget functionality and layout.

**Test Coverage:**
- ✅ Loading state initially
- ✅ Multiple sections display
- ✅ Navigation bar presence
- ✅ Responsiveness on different screen sizes
- ✅ Arabic text localization
- ✅ Dark mode rendering
- ✅ Shimmer skeletons display (Phase 7 integration)

**Run Command:**
```bash
flutter test test/screens/home_screen_test.dart -v
```

### 2. Listings Screen Tests (`test/screens/listings_screen_test.dart`)

Tests for ListingsScreen widget functionality.

**Test Coverage:**
- ✅ App bar with title
- ✅ Filter and sort controls
- ✅ Filter button tappable
- ✅ Sort dropdown options
- ✅ Scrollable content area
- ✅ RTL mode rendering
- ✅ Responsive layout (small/large screens)
- ✅ Dark theme rendering

**Run Command:**
```bash
flutter test test/screens/listings_screen_test.dart -v
```

## Running All Tests

### Run all tests with coverage:
```bash
flutter test --coverage
```

### Run all tests with verbose output:
```bash
flutter test -v
```

### Run tests matching a pattern:
```bash
flutter test -k "HomeScreen"
```

### Run tests with specific reporter:
```bash
flutter test --reporter=json > test_results.json
```

## Test Output and Reports

### Generate coverage report:
```bash
flutter test --coverage
lcov --list coverage/lcov.info
```

### Generate HTML coverage report (Dart):
```bash
flutter test --coverage
# Then use pub get and pub global run to run a coverage analyzer
```

## Mocking Strategy

The tests use the following mocking libraries:

- **mockito**: For creating mock objects of services and clients
- **mocktail**: For mock builder and verification utilities

### Mock Examples:

```dart
// Mocking ApiClient
class MockApiClient extends Mock implements ApiClient {}

// Mocking CacheService
class MockCacheService extends Mock implements CacheService {}

// Mocking ConnectivityService
class MockConnectivityService extends Mock implements ConnectivityService {}
```

## Test Best Practices

1. **Arrange-Act-Assert (AAA) Pattern**
   - Organize tests into three clear sections
   - Makes tests easy to understand and maintain

2. **Isolated Tests**
   - Each test is independent
   - No shared state between tests
   - setUp() and tearDown() for initialization

3. **Meaningful Test Names**
   - Describe what is being tested
   - Include expected behavior
   - Example: `test('returns cached categories when cache is valid')`

4. **Comprehensive Coverage**
   - Test success paths
   - Test error cases
   - Test edge cases (empty data, null values)

## Continuous Integration

These tests are designed to run in CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test
```

## Performance Testing

Monitor test execution time:

```bash
flutter test --verbose 2>&1 | grep -E "(Exited|took [0-9]+ms)"
```

Current benchmark:
- Unit tests: ~200-300ms total
- Widget tests: ~1-2s each
- Full test suite: ~5-10s

## Future Test Additions

Phase 9 will add:
- Integration tests with real API calls
- Performance benchmarks
- Accessibility (a11y) tests
- End-to-end (E2E) user flow tests

## Troubleshooting

### Tests fail with "No element" errors:
- Ensure widgets are rendered with `await tester.pumpAndSettle()`
- Check widget tree with `tester.printToConsole()`

### Mocking not working:
- Verify Mock classes inherit from `Mock` and implement the service interface
- Use `when().thenAnswer()` or `when().thenThrow()` for behavior

### Timeout errors:
- Increase timeout: `await tester.pumpAndSettle(Duration(seconds: 5))`
- Check for infinite loops or unclosed futures

## Coverage Goals

Target coverage:
- Services: 80%+
- Models: 90%+
- Screens: 70%+
- Overall: 75%+

Track coverage:
```bash
flutter test --coverage
open coverage/index.html  # View HTML report
```

---

**Last Updated:** February 23, 2026
**Phase:** 8 - Unit & Widget Tests
