import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/contracts/guards/safe_executor_interface.dart';
import 'package:shorten_list_test/app/core/enum/global_error_types.dart';
import 'package:shorten_list_test/app/core/models/result.dart';
import 'package:shorten_list_test/app/core/service/dto/global_error_dto.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/usecases/shorten_url_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/url_value_object.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/home_controller.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/model/home_model.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/model/home_state.dart';

class MockShortenUrlUseCase extends Mock implements IShortenUrlUseCase {}

class MockSafeExecutor extends Mock implements ISafeExecutor {}

void main() {
  late MockShortenUrlUseCase useCase;
  late MockSafeExecutor safeExecutor;
  late HomeController controller;

  setUpAll(() {
    registerFallbackValue(ShortenUrlInput.empty());
  });

  setUp(() {
    useCase = MockShortenUrlUseCase();
    safeExecutor = MockSafeExecutor();
    controller = HomeController(useCase, safeExecutor);
  });

  tearDown(() {
    controller.emitter.close();
  });

  group('HomeController', () {
    test('input starts as empty', () {
      expect(controller.input.url.isEmpty, isTrue);
      expect(controller.input.uuid, isNull);
    });

    test('recentUrls starts as empty list', () {
      expect(controller.recentUrls, isEmpty);
    });

    test('send executes guard with correct context', () async {
      when(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: any(named: 'contextErrorMessage'),
            onError: any(named: 'onError'),
          )).thenAnswer((_) async {});

      await controller.send();

      verify(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: 'Erro ao enviar URL',
            onError: any(named: 'onError'),
          )).called(1);
    });

    test('send emits loading state before calling use case', () async {
      final states = <HomeViewModel>[];

      controller.onState.listen(states.add);

      when(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: any(named: 'contextErrorMessage'),
            onError: any(named: 'onError'),
          )).thenAnswer((invocation) async {
        final action = invocation.positionalArguments[0] as Future<void> Function();
        await action();
      });

      controller.input.url = URL('https://example.com');

      final entity = ShortenedLinkEntity(
        alias: 'abc123',
        link: LinkEntity(
          originalUrl: 'https://example.com',
          shortenedUrl: 'https://short.io/abc',
        ),
      );

      when(() => useCase.call(any())).thenAnswer((_) async => Success(entity));

      await controller.send();
      await Future.delayed(Duration.zero);

      expect(states.length, greaterThanOrEqualTo(1));
      expect(states.first.state, isA<HomeLoading>());
    });

    test('send calls use case with input', () async {
      when(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: any(named: 'contextErrorMessage'),
            onError: any(named: 'onError'),
          )).thenAnswer((invocation) async {
        final action = invocation.positionalArguments[0] as Future<void> Function();
        await action();
      });

      controller.input.url = URL('https://example.com');

      final entity = ShortenedLinkEntity(
        alias: 'abc123',
        link: LinkEntity(
          originalUrl: 'https://example.com',
          shortenedUrl: 'https://short.io/abc',
        ),
      );

      when(() => useCase.call(any())).thenAnswer((_) async => Success(entity));

      await controller.send();

      verify(() => useCase.call(controller.input)).called(1);
    });

    test('send adds entity to recentUrls on Success', () async {
      when(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: any(named: 'contextErrorMessage'),
            onError: any(named: 'onError'),
          )).thenAnswer((invocation) async {
        final action = invocation.positionalArguments[0] as Future<void> Function();
        await action();
      });

      controller.input.url = URL('https://example.com');

      final entity = ShortenedLinkEntity(
        alias: 'abc123',
        link: LinkEntity(
          originalUrl: 'https://example.com',
          shortenedUrl: 'https://short.io/abc',
        ),
      );

      when(() => useCase.call(any())).thenAnswer((_) async => Success(entity));

      await controller.send();

      expect(controller.recentUrls.length, equals(1));
      expect(controller.recentUrls.first.alias, equals('abc123'));
    });

    test('send emits HomeLoaded with entity on Success', () async {
      final states = <HomeViewModel>[];

      controller.onState.listen(states.add);

      when(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: any(named: 'contextErrorMessage'),
            onError: any(named: 'onError'),
          )).thenAnswer((invocation) async {
        final action = invocation.positionalArguments[0] as Future<void> Function();
        await action();
      });

      controller.input.url = URL('https://example.com');

      final entity = ShortenedLinkEntity(
        alias: 'abc123',
        link: LinkEntity(
          originalUrl: 'https://example.com',
          shortenedUrl: 'https://short.io/abc',
        ),
      );

      when(() => useCase.call(any())).thenAnswer((_) async => Success(entity));

      await controller.send();
      await Future.delayed(Duration.zero);

      final loadedState = states.lastWhere((s) => s.state is HomeLoaded);
      expect(loadedState.state, isA<HomeLoaded>());
      expect(loadedState.shortenedLinks.length, equals(1));
      expect(loadedState.shortenedLinks.first.alias, equals('abc123'));
    });

    test('send accumulates multiple entities in recentUrls', () async {
      when(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: any(named: 'contextErrorMessage'),
            onError: any(named: 'onError'),
          )).thenAnswer((invocation) async {
        final action = invocation.positionalArguments[0] as Future<void> Function();
        await action();
      });

      controller.input.url = URL('https://example.com');

      final entity1 = ShortenedLinkEntity(
        alias: 'abc123',
        link: LinkEntity(
          originalUrl: 'https://example.com',
          shortenedUrl: 'https://short.io/abc',
        ),
      );

      final entity2 = ShortenedLinkEntity(
        alias: 'xyz789',
        link: LinkEntity(
          originalUrl: 'https://another.com',
          shortenedUrl: 'https://short.io/xyz',
        ),
      );

      when(() => useCase.call(any())).thenAnswer((_) async => Success(entity1));

      await controller.send();
      expect(controller.recentUrls.length, equals(1));

      when(() => useCase.call(any())).thenAnswer((_) async => Success(entity2));

      await controller.send();
      expect(controller.recentUrls.length, equals(2));
    });

    test('send emits error on Failure', () async {
      final errors = <Object>[];

      controller.onState.listen(
        (_) {},
        onError: errors.add,
      );

      when(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: any(named: 'contextErrorMessage'),
            onError: any(named: 'onError'),
          )).thenAnswer((invocation) async {
        final action = invocation.positionalArguments[0] as Future<void> Function();
        await action();
      });

      controller.input.url = URL('https://example.com');

      when(() => useCase.call(any())).thenAnswer(
        (_) async => Failure('Valores inválidos. Não adicionar na lista'),
      );

      await controller.send();
      await Future.delayed(Duration.zero);

      expect(errors, isNotEmpty);
      expect(errors.first, equals('Valores inválidos. Não adicionar na lista'));
    });

    test('send invokes onError callback when guard catches exception', () async {
      GlobalErrorDTO? capturedError;

      when(() => safeExecutor.guard<void>(
            any(),
            contextErrorMessage: any(named: 'contextErrorMessage'),
            onError: any(named: 'onError'),
          )).thenAnswer((invocation) async {
        final onError = invocation.namedArguments[Symbol('onError')] as Function;
        final error = GlobalErrorDTO(
          type: GlobalErrorTypes.exception,
          message: 'Test error',
        );
        onError(error);
        capturedError = error;
      });

      controller.input.url = URL('https://example.com');

      await controller.send();

      expect(capturedError, isNotNull);
      expect(capturedError?.message, equals('Test error'));
    });
  });
}
