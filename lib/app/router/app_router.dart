import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_bloc.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/home_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => GetIt.instance<HomeBloc>(),
            child: const HomeView(),
          );
        },
      ),
    ],
  );
}
