# Contributing to Dalilak

Thank you for your interest in contributing to Dalilak! This document provides guidelines and instructions for contributing.

---

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Workflow](#development-workflow)
4. [Code Standards](#code-standards)
5. [Commit Guidelines](#commit-guidelines)
6. [Pull Request Process](#pull-request-process)
7. [Testing Guidelines](#testing-guidelines)
8. [Documentation](#documentation)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please read and adhere to our Code of Conduct:

- Be respectful in all interactions
- Provide constructive feedback
- Accept criticism gracefully
- Focus on solutions
- Respect diverse perspectives

### Enforcement

Violations of the Code of Conduct will result in immediate action by the project maintainers.

---

## Getting Started

### Prerequisites

```bash
# Required
- Flutter 3.4.4+
- Dart 3.4.4+
- Git
- Android Studio or Xcode (for mobile testing)
```

### Setup Development Environment

```bash
# 1. Fork the repository
# Go to https://github.com/karam/dalilak_app and click "Fork"

# 2. Clone your fork
git clone https://github.com/YOUR_USERNAME/dalilak_app.git
cd dalilak_app

# 3. Add upstream remote
git remote add upstream https://github.com/karam/dalilak_app.git

# 4. Install dependencies
flutter pub get

# 5. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 6. Verify setup
flutter analyze lib/
flutter test
```

---

## Development Workflow

### 1. Create Feature Branch

```bash
# Update main branch
git fetch upstream
git checkout main
git merge upstream/main

# Create feature branch
git checkout -b feature/your-feature-name
```

### 2. Make Changes

```bash
# Edit files
# Add new features/fix bugs
# Write tests

# Example structure for new feature:
lib/
├── screens/new_feature/
│   └── new_feature_screen.dart
├── widgets/new_feature/
│   └── new_feature_widget.dart
├── models/new_feature_model.dart
└── providers/new_feature_providers.dart

test/
├── screens/new_feature_screen_test.dart
└── models/new_feature_model_test.dart
```

### 3. Keep Branch Updated

```bash
# Fetch latest changes
git fetch upstream

# Rebase your branch
git rebase upstream/main

# If conflicts, resolve them
# Then force push (only for your branch)
git push origin feature/your-feature-name -f
```

---

## Code Standards

### Dart/Flutter Style Guide

1. **File Structure**
   - Use descriptive file names (snake_case)
   - One class/model per file
   - Max 400 lines per file (prefer < 300)

2. **Naming Conventions**
   - Classes: `PascalCase` (e.g., `ListingDetailScreen`)
   - Functions/variables: `camelCase` (e.g., `getListings()`)
   - Constants: `camelCase` (e.g., `apiTimeout`)
   - Files: `snake_case` (e.g., `listing_detail_screen.dart`)

3. **Code Formatting**
   ```bash
   # Format code
   dart format lib/ test/
   # Set line length if needed
   dart format --line-length=100 lib/
   
   # Verify formatting
   dart format --set-exit-if-changed lib/ test/
   ```

4. **Code Analysis**
   ```bash
   # Run analyzer
   flutter analyze lib/
   
   # Fix issues
   dart fix --apply lib/
   ```

5. **Import Organization**
   ```dart
   // 1. dart: imports
   import 'dart:async';
   
   // 2. flutter: imports
   import 'package:flutter/material.dart';
   
   // 3. package: imports
   import 'package:riverpod/riverpod.dart';
   
   // 4. relative imports
   import '../models/listing_model.dart';
   import '../../services/api_client.dart';
   ```

### Best Practices

1. **Use Constants**
   ```dart
   const Duration cacheTimeout = Duration(hours: 1);
   const String apiBaseUrl = 'https://api.dalilak.com';
   ```

2. **Null Safety**
   ```dart
   // Always specify nullability
   String? optionalValue;
   String requiredValue;
   
   // Use null coalescing
   final value = data ?? defaultValue;
   ```

3. **Error Handling**
   ```dart
   try {
     final data = await repository.getData();
   } on NetworkException catch (e) {
     // Handle network error
     logger.error('Network error: $e');
   } on ApiException catch (e) {
     // Handle API error
     logger.error('API error: $e');
   } catch (e) {
     // Handle unknown error
     logger.error('Unknown error: $e');
   }
   ```

4. **Documentation**
   ```dart
   /// Retrieves listings with optional filtering and pagination.
   ///
   /// Throws [NetworkException] if no internet connection.
   /// Throws [ApiException] if API request fails.
   Future<List<Listing>> getListings({
     required int page,
     required int limit,
     int? categoryId,
   }) async {
     // Implementation
   }
   ```

---

## Commit Guidelines

### Conventional Commits

Format: `type(scope): subject`

```
feat(home): add shimmer loading skeleton
fix(listings): resolve pagination offset bug
docs(readme): update deployment instructions
style(code): fix formatting in models
refactor(api): simplify error handling
perf(cache): optimize TTL validation
test(models): add CategoryModel tests
chore(deps): update flutter to 3.4.4
```

### Types

- **feat:** New feature
- **fix:** Bug fix
- **docs:** Documentation
- **style:** Code style (formatting, semicolons, etc.)
- **refactor:** Code refactoring
- **perf:** Performance improvement
- **test:** Add or update tests
- **chore:** Maintenance (deps, build, etc.)

### Commit Message Format

```
feat(home): add shimmer skeleton loading

- Added ShimmerSkeleton widget base class
- Implemented ListingCardSkeleton component
- Integrated shimmer in HomeScreen
- Added dark mode support
- Updated tests

Closes #123
```

### Commit Best Practices

1. Commit frequently (logical units)
2. Write clear messages
3. Reference related issues
4. Keep commits atomic (single responsibility)
5. Test before committing

---

## Pull Request Process

### 1. Before Creating PR

```bash
# Update branch
git fetch upstream
git rebase upstream/main

# Format code
dart format lib/ test/

# Run tests
flutter test --coverage

# Run analysis
flutter analyze lib/

# Build
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Create Pull Request

**Title Format:** `[TYPE] Description`

Examples:
- `[FEATURE] Add user authentication`
- `[FIX] Resolve cache expiration bug`
- `[DOCS] Update API documentation`

**Description Template:**

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New feature
- [ ] Bug fix
- [ ] Documentation
- [ ] Performance improvement
- [ ] Other

## Related Issues
Closes #123

## Changes Made
- Item 1
- Item 2
- Item 3

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed
- [ ] All tests passing

## Screenshots (if applicable)
<!-- Add images for UI changes -->

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated
- [ ] All tests passing locally
```

### 3. CI/CD Checks

Your PR will automatically run:
- ✅ Flutter analysis
- ✅ Unit tests
- ✅ Widget tests
- ✅ Code formatting
- ✅ Security scan

All checks must pass before merging.

### 4. Code Review

- At least one approval required
- Address feedback constructively
- Push updates without force-pushing (keeps conversation)
- Rebase only if necessary

### 5. Merge

After approval, maintainer will merge PR.

---

## Testing Guidelines

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName', () {
    test('should return expected result', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = function(input);
      
      // Assert
      expect(result, 'expected');
    });
  });
}
```

### Widget Tests

```dart
testWidgets('Widget displays correctly', (WidgetTester tester) async {
  // Arrange
  await tester.pumpWidget(MaterialApp(
    home: YourWidget(),
  ));

  // Act
  await tester.pump();

  // Assert
  expect(find.byType(YourWidget), findsOneWidget);
});
```

### Running Tests

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Watch mode
flutter test --watch

# Specific file
flutter test test/models/listing_model_test.dart

# Tests matching pattern
flutter test -k "ListingModel"
```

### Coverage Requirements

- **New code:** Minimum 80% coverage
- **Modified code:** Maintain existing coverage
- **Overall target:** 75%+

---

## Documentation

### Code Comments

```dart
// Bad
final x = 5; // x is 5

// Good
// Maximum items per API request
final maxItemsPerRequest = 20;

// Bad
void process() {
  // do stuff
}

// Good
/// Processes the data and updates the UI accordingly.
/// 
/// Returns null if data is empty.
void processAndDisplay(List<Data> items) {
  // Implementation
}
```

### README Updates

If your changes affect:
- Installation/setup
- Feature usage
- Architecture
- Dependencies

Update [README.md](./README_FINAL.md) accordingly.

### File Documentation

Add header comments to files:

```dart
/// Handles all listing-related API calls and caching.
///
/// This service implements the repository pattern with a 3-tier
/// caching strategy (cache -> connectivity check -> API fallback).
library dalilak_repository;

// ... rest of file
```

---

## Common Mistakes to Avoid

1. ❌ Don't commit to main branch directly
2. ❌ Don't force-push to shared branches
3. ❌ Don't skip writing tests
4. ❌ Don't ignore code analysis warnings
5. ❌ Don't add hardcoded secrets/credentials
6. ❌ Don't make huge PRs (keep < 500 lines)
7. ❌ Don't commit formatting changes with logic
8. ❌ Don't update dependencies unnecessarily

---

## Getting Help

### Resources

- **Documentation:** See [README_FINAL.md](./README_FINAL.md)
- **API Docs:** See [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)
- **Deployment:** See [DEPLOYMENT.md](./DEPLOYMENT.md)
- **Testing:** See [test/TESTING_GUIDE.md](./test/TESTING_GUIDE.md)

### Ask Questions

- **GitHub Issues:** For bugs and features
- **Discussions:** For questions and ideas
- **Email:** support@dalilak.com

---

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md file
- GitHub contributors page
- Release notes

---

## License

By contributing to Dalilak, you agree that your contributions will be licensed under the [MIT License](./LICENSE).

---

## Questions?

Feel free to reach out to the maintainers or community via:
- GitHub Issues
- Email: dev@dalilak.com
- WhatsApp: +20 1234567890

---

**Thank you for contributing to Dalilak! 🙏**
