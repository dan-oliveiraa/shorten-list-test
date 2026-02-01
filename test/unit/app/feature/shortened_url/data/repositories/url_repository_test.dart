import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/contracts/url_datasource_port.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/mappers/link_mapper.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/mappers/shortened_link_mapper.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/repositories/url_repository.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/url_value_object.dart';

class MockUrlDatasource extends Mock implements UrlDatasourcePort {}

void main() {
  late MockUrlDatasource mockDatasource;
  late UrlRepository repository;

  setUp(() {
    mockDatasource = MockUrlDatasource();
    repository = UrlRepository(mockDatasource);
  });

  group('UrlRepository', () {
    group('shortenUrl', () {
      test('should call datasource and convert mapper to entity', () async {
        final input = ShortenUrlInput(url: URL('https://example.com'));
        final mapper = ShortenedLinkMapper(
          alias: 'abc123',
          link: LinkMapper(
            originalUrl: 'https://example.com',
            shortenedUrl: 'https://short.url/abc123',
          ),
        );

        when(() => mockDatasource.shortenUrl(input)).thenAnswer((_) async => mapper);

        final result = await repository.shortenUrl(input);

        verify(() => mockDatasource.shortenUrl(input)).called(1);
        expect(result, isA<ShortenedLinkEntity>());
        expect(result.alias, 'abc123');
        expect(result.link.originalUrl, 'https://example.com');
        expect(result.link.shortenedUrl, 'https://short.url/abc123');
      });

      test('should propagate exceptions from datasource', () async {
        final input = ShortenUrlInput(url: URL('https://example.com'));

        when(() => mockDatasource.shortenUrl(input)).thenThrow(Exception('Network error'));

        expect(
          () => repository.shortenUrl(input),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
