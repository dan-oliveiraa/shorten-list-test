import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/link_entity.dart';

void main() {
  group('LinkEntity', () {
    group('constructor and properties', () {
      test('should create LinkEntity with valid URLs', () {
        final entity = LinkEntity(
          originalUrl: 'https://example.com/very/long/path',
          shortenedUrl: 'https://short.com/abc123',
        );

        expect(entity.originalUrl, equals('https://example.com/very/long/path'));
        expect(entity.shortenedUrl, equals('https://short.com/abc123'));
      });
    });

    group('isEmpty getter', () {
      test('should return true when both URLs are empty', () {
        final entity = LinkEntity(
          originalUrl: '',
          shortenedUrl: '',
        );

        expect(entity.isEmpty, isTrue);
      });

      test('should return false when originalUrl has value', () {
        final entity = LinkEntity(
          originalUrl: 'https://example.com',
          shortenedUrl: '',
        );

        expect(entity.isEmpty, isFalse);
      });

    });
  });
}
