import 'package:get_it/get_it.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/home/home_dependency_injection.dart';

class PresentationDependencyInjection {
  final getIt = GetIt.instance;

  void configure() {
    HomeDependencyInjection().configure();
  }
}
