import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/mappers/link_mapper.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/mappers/shortened_link_mapper.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';

void main() {
  group('ShortenedLinkMapper', () {
    group('fromMap', () {
      test('should create mapper from valid map with all fields', () {
        final map = {
          'alias': 'abc123',
          '_links': {
            'self': 'https://example.com',
            'short': 'https://short.url/abc123',
          }
        };

        final result = ShortenedLinkMapper.fromMap(map);

        expect(result.alias, 'abc123');
        expect(result.link.originalUrl, 'https://example.com');
        expect(result.link.shortenedUrl, 'https://short.url/abc123');
      });

      test('should handle missing or null alias/links fields with empty fallbacks', () {
        final missingAliasMap = {
          '_links': {
            'self': 'https://example.com',
            'short': 'https://short.url/abc123',
          }
        };
        final nullAliasMap = {
          'alias': null,
          '_links': {
            'self': 'https://example.com',
            'short': 'https://short.url/abc123',
          }
        };
        final missingLinksMap = {'alias': 'abc123'};
        final nullLinksMap = {'alias': 'abc123', '_links': null};
        final nullLinksValuesMap = {
          'alias': 'abc123',
          '_links': {'self': null, 'short': null}
        };

        for (final map in [missingAliasMap, nullAliasMap]) {
          final result = ShortenedLinkMapper.fromMap(map);
          expect(result.alias, '');
        }

        for (final map in [missingLinksMap, nullLinksMap, nullLinksValuesMap]) {
          final result = ShortenedLinkMapper.fromMap(map);
          expect(result.alias, 'abc123');
          expect(result.link.originalUrl, '');
          expect(result.link.shortenedUrl, '');
        }
      });

      test('should handle map with extra unexpected fields', () {
        final map = {
          'alias': 'abc123',
          '_links': {
            'self': 'https://example.com',
            'short': 'https://short.url/abc123',
          },
          'unexpectedField': 'value',
          'anotherField': 123,
        };

        final result = ShortenedLinkMapper.fromMap(map);

        expect(result.alias, 'abc123');
        expect(result.link.originalUrl, 'https://example.com');
        expect(result.link.shortenedUrl, 'https://short.url/abc123');
      });
    });
    group('edge cases', () {
      test('should handle special characters in URLs', () {
        final map = {
          'alias': 'special-123',
          '_links': {
            'self': 'https://example.com/path?query=value&id=123',
            'short': 'https://short.url/special-123',
          }
        };

        final result = ShortenedLinkMapper.fromMap(map);

        expect(result.alias, 'special-123');
        expect(result.link.originalUrl, 'https://example.com/path?query=value&id=123');
        expect(result.link.shortenedUrl, 'https://short.url/special-123');
      });

      test('should handle unicode characters in alias and URLs', () {
        final map = {
          'alias': 'café-link',
          '_links': {
            'self': 'https://example.com/café',
            'short': 'https://short.url/café',
          }
        };

        final result = ShortenedLinkMapper.fromMap(map);

        expect(result.alias, contains('café'));
        expect(result.link.originalUrl, contains('café'));
        expect(result.link.shortenedUrl, contains('café'));
      });

      test('should handle very long URLs', () {
        final longPath = 'path/${'segment/' * 200}';
        final map = {
          'alias': 'long-url',
          '_links': {
            'self': 'https://example.com/$longPath',
            'short': 'https://short.url/tiny',
          }
        };

        final result = ShortenedLinkMapper.fromMap(map);

        expect(result.link.originalUrl.length, greaterThan(1000));
        expect(result.link.shortenedUrl, 'https://short.url/tiny');
      });
    });

    group('isEmpty', () {
      test('should return false when mapper has both alias and link', () {
        final mapper = ShortenedLinkMapper(
          alias: 'abc123',
          link: LinkMapper(
            originalUrl: 'https://example.com',
            shortenedUrl: 'https://short.url/abc123',
          ),
        );

        expect(mapper.isEmpty, isFalse);
      });

      test('should return false when only alias is present', () {
        final mapper = ShortenedLinkMapper(
          alias: 'abc123',
          link: LinkMapper(
            originalUrl: '',
            shortenedUrl: '',
          ),
        );

        expect(mapper.isEmpty, isFalse);
      });

      test('should return false when only link is present', () {
        final mapper = ShortenedLinkMapper(
          alias: '',
          link: LinkMapper(
            originalUrl: 'https://example.com',
            shortenedUrl: 'https://short.url/abc123',
          ),
        );

        expect(mapper.isEmpty, isFalse);
      });

      test('should return true when both alias and link are empty', () {
        final mapper = ShortenedLinkMapper(
          alias: '',
          link: LinkMapper(
            originalUrl: '',
            shortenedUrl: '',
          ),
        );

        expect(mapper.isEmpty, isTrue);
      });
    });

    group('toEntity', () {
      test('should convert mapper to entity with all values', () {
        final mapper = ShortenedLinkMapper(
          alias: 'abc123',
          link: LinkMapper(
            originalUrl: 'https://example.com',
            shortenedUrl: 'https://short.url/abc123',
          ),
        );

        final result = mapper.toEntity;

        expect(result, isA<ShortenedLinkEntity>());
        expect(result.alias, 'abc123');
        expect(result.link, isA<LinkEntity>());
        expect(result.link.originalUrl, 'https://example.com');
        expect(result.link.shortenedUrl, 'https://short.url/abc123');
      });

      test('should convert mapper with empty values to entity', () {
        final mapper = ShortenedLinkMapper(
          alias: '',
          link: LinkMapper(
            originalUrl: '',
            shortenedUrl: '',
          ),
        );

        final result = mapper.toEntity;

        expect(result.alias, '');
        expect(result.link.originalUrl, '');
        expect(result.link.shortenedUrl, '');
        expect(result.isEmpty, isTrue);
      });

      test('should preserve all data during entity conversion', () {
        final mapper = ShortenedLinkMapper(
          alias: 'special-123_test',
          link: LinkMapper(
            originalUrl: 'https://example.com/path?query=value&id=123',
            shortenedUrl: 'https://short.url/special-123_test',
          ),
        );

        final result = mapper.toEntity;

        expect(result.alias, 'special-123_test');
        expect(result.link.originalUrl, 'https://example.com/path?query=value&id=123');
        expect(result.link.shortenedUrl, 'https://short.url/special-123_test');
      });

      test('should create independent entity instance', () {
        final linkMapper = LinkMapper(
          originalUrl: 'https://example.com',
          shortenedUrl: 'https://short.url/abc123',
        );
        final mapper = ShortenedLinkMapper(
          alias: 'abc123',
          link: linkMapper,
        );

        final entity = mapper.toEntity;

        expect(entity.link, isNot(same(linkMapper)));
        expect(entity.link.originalUrl, linkMapper.originalUrl);
        expect(entity.link.shortenedUrl, linkMapper.shortenedUrl);
      });
    });
  });
}
