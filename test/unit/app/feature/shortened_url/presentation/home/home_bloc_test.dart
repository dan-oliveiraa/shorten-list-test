import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/contracts/guards/safe_executor_interface.dart';
import 'package:shorten_list_test/app/core/models/result.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/usecases/shorten_url_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/entities/shortened_link_entity.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/url_value_object.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_bloc.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_event.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_state.dart';

class MockShortenUrlUseCase extends Mock implements IShortenUrlUseCase {}

class MockSafeExecutor extends Mock implements ISafeExecutor {}

void main() {
  late MockShortenUrlUseCase useCase;
  late MockSafeExecutor safeExecutor;

  setUpAll(() {
    registerFallbackValue(ShortenUrlInput.empty());
  });

  setUp(() {
    useCase = MockShortenUrlUseCase();
    safeExecutor = MockSafeExecutor();
  });

  void stubGuardSuccess() {
    when(
      () => safeExecutor.guard<void>(
        any(),
        contextErrorMessage: any(named: 'contextErrorMessage'),
        onError: any(named: 'onError'),
      ),
    ).thenAnswer((invocation) async {
      final action = invocation.positionalArguments[0] as Future<void> Function();
      await action();
      return;
    });
  }

  group('HomeBloc', () {
    test('initial state is HomeLoaded', () {
      final bloc = HomeBloc(useCase, safeExecutor);
      expect(bloc.state, isA<HomeLoaded>());
    });

    blocTest<HomeBloc, HomeState>(
      'emits loading then loaded on success',
      build: () {
        stubGuardSuccess();
        final bloc = HomeBloc(useCase, safeExecutor);
        bloc.input.url = URL('https://example.com');

        final entity = ShortenedLinkEntity(
          alias: 'abc123',
          link: LinkEntity(
            originalUrl: 'https://example.com',
            shortenedUrl: 'https://short.io/abc',
          ),
        );

        when(() => useCase.call(any())).thenAnswer((_) async => Success(entity));
        return bloc;
      },
      act: (bloc) => bloc.add(HomeSendEvent()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeLoaded>().having(
          (state) => state.recentUrls.length,
          'recentUrls length',
          1,
        ),
      ],
      verify: (bloc) {
        verify(() => useCase.call(bloc.input)).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits loading then error on failure',
      build: () {
        stubGuardSuccess();
        final bloc = HomeBloc(useCase, safeExecutor);
        bloc.input.url = URL('https://example.com');

        when(() => useCase.call(any())).thenAnswer(
          (_) async => Failure('Invalid URL'),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(HomeSendEvent()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeError>().having(
          (state) => state.message,
          'message',
          'Invalid URL',
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'refresh emits loaded with current list',
      build: () {
        final bloc = HomeBloc(useCase, safeExecutor);
        bloc.recentUrls.add(
          ShortenedLinkEntity(
            alias: 'abc123',
            link: LinkEntity(
              originalUrl: 'https://example.com',
              shortenedUrl: 'https://short.io/abc',
            ),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(HomeRefreshEvent()),
      expect: () => [
        isA<HomeLoaded>().having(
          (state) => state.recentUrls.length,
          'recentUrls length',
          1,
        ),
      ],
    );
  });
}
