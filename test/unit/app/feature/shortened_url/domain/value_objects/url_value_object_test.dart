import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/url_value_object.dart';

void main() {
  group('URL Value Object', () {
    /// ============================================
    /// VALIDATION TESTS - Core Business Logic (HIGH VALUE)
    /// ============================================

    group('validate - URL validation logic', () {
      test('should return error for empty URL', () {
        final result = URL.validate('');
        expect(result, equals('URL cannot be empty'));
      });

      test('should return error for URL without valid extension', () {
        final result = URL.validate('https://example.invalid');
        expect(result, equals('Invalid URL format.'));
      });

      test('should accept URL with .com extension', () {
        final result = URL.validate('https://example.com');
        expect(result, isNull);
      });

      test('should accept URL without protocol prefix', () {
        final result = URL.validate('example.com');
        expect(result, isNull);
      });

      test('should accept URL with path and query', () {
        final result = URL.validate('https://example.com/path?id=123#section');
        expect(result, isNull);
      });

      test('should return error for URL with invalid characters', () {
        final result = URL.validate('https://exam ple.com');
        expect(result, isNotNull);
      });
    });

    /// ============================================
    /// FACTORY CONSTRUCTORS (MEDIUM-HIGH VALUE)
    /// ============================================

    group('constructors', () {
      test('should create empty URL', () {
        final url = URL.empty();
        expect(url.value, isEmpty);
      });
    });

    /// ============================================
    /// COMPUTED PROPERTIES - Form Validation (MEDIUM-HIGH VALUE)
    /// ============================================

    group('isValid getter', () {
      test('should return false for invalid URL', () {
        final url = URL('invalid');
        expect(url.isValid, isFalse);
      });

      test('should return true for valid URL', () {
        final url = URL('https://example.com');
        expect(url.isValid, isTrue);
      });
    });

    /// ============================================
    /// VALUE MUTATION - UI Binding (MEDIUM-HIGH VALUE)
    /// ============================================

    group('value mutation', () {
      test('should allow changing URL value', () {
        final url = URL('https://example.com');
        url.value = 'https://different.com';
        expect(url.value, equals('https://different.com'));
      });
    });
  });
}
