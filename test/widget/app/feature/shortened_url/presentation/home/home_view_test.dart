import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/common/widgets/error/error_view.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_bloc.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_event.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_state.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/home_view.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/widgets/template/skeleton_home_url_template.dart';

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

class FakeHomeEvent extends Fake implements HomeEvent {}

void main() {
  late MockHomeBloc bloc;

  setUpAll(() {
    registerFallbackValue(FakeHomeEvent());
    registerFallbackValue(HomeLoading());
  });

  setUp(() {
    bloc = MockHomeBloc();
    when(() => bloc.input).thenReturn(ShortenUrlInput.empty());
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<HomeBloc>.value(
        value: bloc,
        child: const HomeView(),
      ),
    );
  }

  testWidgets('shows skeleton while loading', (tester) async {
    when(() => bloc.state).thenReturn(HomeLoading());
    whenListen(
      bloc,
      Stream<HomeState>.fromIterable([HomeLoading()]),
      initialState: HomeLoading(),
    );

    await tester.pumpWidget(buildSubject());

    expect(find.byType(SkeletonHomeUrlTemplate), findsOneWidget);
  });

  testWidgets('shows error message when error', (tester) async {
    when(() => bloc.state).thenReturn(const HomeError('Boom'));
    whenListen(
      bloc,
      Stream<HomeState>.fromIterable([const HomeError('Boom')]),
      initialState: const HomeError('Boom'),
    );

    await tester.pumpWidget(buildSubject());

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Boom'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('shows empty state when loaded with no urls', (tester) async {
    when(() => bloc.state).thenReturn(HomeLoaded(recentUrls: const []));
    whenListen(
      bloc,
      Stream<HomeState>.fromIterable([HomeLoaded(recentUrls: const [])]),
      initialState: HomeLoaded(recentUrls: const []),
    );

    await tester.pumpWidget(buildSubject());

    expect(find.text('No URLs yet'), findsOneWidget);
    expect(find.text('Recent Shortened URLs'), findsOneWidget);
  });
}
