import 'package:get_it/get_it.dart';
import 'package:shorten_list_test/app/feature/shortened_url/application/usecases/shorten_url.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/usecases/shorten_url_interface.dart';

class ApplicationModules {
  void configure() {
    final getIt = GetIt.instance;

    getIt.registerFactory<IShortenUrlUseCase>(() => ShortenUrlUseCase(getIt.get()));
  }
}
