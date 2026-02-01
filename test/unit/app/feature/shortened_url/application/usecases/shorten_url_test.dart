import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/models/result.dart';
import 'package:shorten_list_test/app/feature/shortened_url/application/usecases/shorten_url.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/ports/repositories/url_repository_port.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/url_value_object.dart';

class MockUrlRepository extends Mock implements UrlRepositoryPort {}

void main() {
  late MockUrlRepository repository;
  late ShortenUrlUseCase useCase;

  setUp(() {
    repository = MockUrlRepository();
    useCase = ShortenUrlUseCase(repository);
  });

  group('ShortenUrlUseCase', () {
    test('returns Success when repository provides non-empty entity', () async {
      final input = ShortenUrlInput(url: URL('https://example.com'));
      final entity = ShortenedLinkEntity(
        alias: 'abc123',
        link: LinkEntity(
          originalUrl: 'https://example.com',
          shortenedUrl: 'https://short.url/abc123',
        ),
      );

      when(() => repository.shortenUrl(input)).thenAnswer((_) async => entity);

      final result = await useCase.call(input);

      expect(result, isA<Success<ShortenedLinkEntity, String>>());
      verify(() => repository.shortenUrl(input)).called(1);
    });

    test('returns Failure when repository provides empty entity', () async {
      final input = ShortenUrlInput(url: URL('https://example.com'));
      final entity = ShortenedLinkEntity(
        alias: '',
        link: LinkEntity(
          originalUrl: '',
          shortenedUrl: '',
        ),
      );

      when(() => repository.shortenUrl(input)).thenAnswer((_) async => entity);

      final result = await useCase.call(input);

      expect(result, isA<Failure<ShortenedLinkEntity, String>>());
      verify(() => repository.shortenUrl(input)).called(1);
    });
  });
}
