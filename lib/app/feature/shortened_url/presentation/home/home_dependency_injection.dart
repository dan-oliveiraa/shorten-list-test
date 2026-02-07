import 'package:get_it/get_it.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/bloc/home_bloc.dart';

class HomeDependencyInjection {
  void configure() {
    final getIt = GetIt.instance;

    getIt.registerFactory(() => HomeBloc(
          getIt(),
          getIt(),
        ));
  }
}
