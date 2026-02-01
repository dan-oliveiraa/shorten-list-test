import 'package:get_it/get_it.dart';
import 'package:shorten_list_test/app/core/contracts/guards/safe_executor_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/controller/home_controller_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/usecases/shorten_url_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/home_controller.dart';

class PresentationModules {
  final getIt = GetIt.instance;

  void configure() {
    getIt.registerSingleton<IHomeController>(
      HomeController(
        getIt<IShortenUrlUseCase>(),
        getIt<ISafeExecutor>(),
      ),
    );
  }
}
