import 'package:flutter_test/flutter_test.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';

void main() {
  group('ShortenedLinkEntity', () {
    group('constructor and properties', () {
      test('should create ShortenedLinkEntity with alias and link', () {
        final link = LinkEntity(
          originalUrl: 'https://example.com/long/path',
          shortenedUrl: 'https://short.io/xyz',
        );

        final entity = ShortenedLinkEntity(
          alias: 'my-link',
          link: link,
        );

        expect(entity.alias, equals('my-link'));
        expect(entity.link, equals(link));
      });
    });

    group('isEmpty getter', () {
      test('should return true when both alias and link are empty', () {
        final link = LinkEntity(
          originalUrl: '',
          shortenedUrl: '',
        );

        final entity = ShortenedLinkEntity(
          alias: '',
          link: link,
        );

        expect(entity.isEmpty, isTrue);
      });

      test('should return false when alias has value', () {
        final link = LinkEntity(
          originalUrl: '',
          shortenedUrl: '',
        );

        final entity = ShortenedLinkEntity(
          alias: 'my-alias',
          link: link,
        );

        expect(entity.isEmpty, isFalse);
      });
    });

    group('link entity composition', () {
      test('should handle link with both URLs valid', () {
        final link = LinkEntity(
          originalUrl: 'https://github.com/flutter/flutter',
          shortenedUrl: 'https://gh.io/flutter',
        );

        final entity = ShortenedLinkEntity(
          alias: 'flutter-repo',
          link: link,
        );

        expect(entity.link.originalUrl, isNotEmpty);
        expect(entity.link.shortenedUrl, isNotEmpty);
        expect(entity.isEmpty, isFalse);
      });

      test('should use link isEmpty property correctly', () {
        final emptyLink = LinkEntity(
          originalUrl: '',
          shortenedUrl: '',
        );

        final entity = ShortenedLinkEntity(
          alias: 'my-alias',
          link: emptyLink,
        );

        expect(entity.link.isEmpty, isTrue);
        expect(entity.isEmpty, isFalse);
      });
    });
  });
}
