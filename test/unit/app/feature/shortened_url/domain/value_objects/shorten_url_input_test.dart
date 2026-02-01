import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/url_value_object.dart';

void main() {
  group('ShortenUrlInput Value Object', () {
    group('constructors', () {
      test('should create ShortenUrlInput with valid URL and uuid', () {
        final url = URL('https://example.com');
        final input = ShortenUrlInput(url: url, uuid: 'test-uuid-123');

        expect(input.url, equals(url));
        expect(input.uuid, equals('test-uuid-123'));
      });

      test('should create ShortenUrlInput with only URL (no uuid)', () {
        final url = URL('https://example.com');
        final input = ShortenUrlInput(url: url);

        expect(input.url, equals(url));
        expect(input.uuid, isNull);
      });

      test('should create empty ShortenUrlInput', () {
        final input = ShortenUrlInput.empty();

        expect(input.url.isEmpty, isTrue);
        expect(input.uuid, isNull);
      });
    });

    group('equality', () {
      test('should not be equal if URL is different', () {
        final input1 = ShortenUrlInput(url: URL('https://example.com'), uuid: 'uuid-1');
        final input2 = ShortenUrlInput(url: URL('https://different.com'), uuid: 'uuid-1');

        expect(input1 == input2, isFalse);
      });

      test('should be equal if both have no uuid', () {
        final url = URL('https://example.com');
        final input1 = ShortenUrlInput(url: url);
        final input2 = ShortenUrlInput(url: URL('https://example.com'));

        expect(input1 == input2, isTrue);
      });
    });

    group('url property mutation', () {
      test('should allow changing URL value', () {
        final input = ShortenUrlInput(url: URL('https://example.com'), uuid: 'uuid-1');
        final newUrl = URL('https://different.com');

        input.url = newUrl;

        expect(input.url, equals(newUrl));
        expect(input.url.value, equals('https://different.com'));
      });
    });

    group('composition with URL value object', () {
      test('should reflect URL validation in input', () {
        final input = ShortenUrlInput(url: URL('https://example.com'));
        expect(input.url.isValid, isTrue);

        input.url = URL('invalid');
        expect(input.url.isValid, isFalse);
      });
    });
  });
}
