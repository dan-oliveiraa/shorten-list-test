import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/mappers/link_mapper.dart';

void main() {
  group('LinkMapper', () {
    group('fromMap', () {
      test('should create mapper from valid map with all fields', () {
        final map = {
          'self': 'https://example.com',
          'short': 'https://short.url/abc123',
        };

        final result = LinkMapper.fromMap(map);

        expect(result.originalUrl, 'https://example.com');
        expect(result.shortenedUrl, 'https://short.url/abc123');
      });

      test('should handle empty map and null values with empty string fallback', () {
        final emptyMap = <String, dynamic>{};
        final nullMap = {'self': null, 'short': null};

        final emptyResult = LinkMapper.fromMap(emptyMap);
        final nullResult = LinkMapper.fromMap(nullMap);

        expect(emptyResult.originalUrl, '');
        expect(emptyResult.shortenedUrl, '');
        expect(nullResult.originalUrl, '');
        expect(nullResult.shortenedUrl, '');
      });

      test('should handle map with extra unexpected fields', () {
        final map = {
          'self': 'https://example.com',
          'short': 'https://short.url/abc123',
          'unexpectedField': 'value',
          'anotherField': 123,
        };

        final result = LinkMapper.fromMap(map);

        expect(result.originalUrl, 'https://example.com');
        expect(result.shortenedUrl, 'https://short.url/abc123');
      });
    });

    group('edge cases', () {
      test('should handle special characters in URLs', () {
        final map = {
          'self': 'https://example.com/path?query=value&id=123',
          'short': 'https://short.url/special-123',
        };

        final result = LinkMapper.fromMap(map);

        expect(result.originalUrl, 'https://example.com/path?query=value&id=123');
        expect(result.shortenedUrl, 'https://short.url/special-123');
      });

      test('should handle unicode characters in URLs', () {
        final map = {
          'self': 'https://example.com/café',
          'short': 'https://short.url/café',
        };

        final result = LinkMapper.fromMap(map);

        expect(result.originalUrl, contains('café'));
        expect(result.shortenedUrl, contains('café'));
      });
    });

    group('isEmpty', () {
      test('should return false when mapper has both URLs', () {
        final mapper = LinkMapper(
          originalUrl: 'https://example.com',
          shortenedUrl: 'https://short.url/abc123',
        );

        expect(mapper.isEmpty, isFalse);
      });

      test('should return false when only originalUrl is present', () {
        final mapper = LinkMapper(
          originalUrl: 'https://example.com',
          shortenedUrl: '',
        );

        expect(mapper.isEmpty, isFalse);
      });

      test('should return false when only shortenedUrl is present', () {
        final mapper = LinkMapper(
          originalUrl: '',
          shortenedUrl: 'https://short.url/abc123',
        );

        expect(mapper.isEmpty, isFalse);
      });

      test('should return true when both URLs are empty', () {
        final mapper = LinkMapper(
          originalUrl: '',
          shortenedUrl: '',
        );

        expect(mapper.isEmpty, isTrue);
      });
    });
  });
}
