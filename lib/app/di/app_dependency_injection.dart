import 'package:shorten_list_test/app/core/core_modules.dart';
import 'package:shorten_list_test/app/feature/shortened_url/application/application_modules.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/data_modules.dart';
import 'package:shorten_list_test/app/feature/shortened_url/presentation/presentation_dependency_injection.dart';

class AppDependencyInjection {
  void configure() {
    CoreModules().configure();
    DataModules().configure();
    ApplicationModules().configure();
    PresentationDependencyInjection().configure();
  }
}
