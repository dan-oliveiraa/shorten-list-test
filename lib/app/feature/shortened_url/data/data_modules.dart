import 'package:get_it/get_it.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/datasource/url_datasource.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/repositories/url_repository.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/ports/datasources/url_datasource_port.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/contracts/ports/repositories/url_repository_port.dart';

class DataModules {
  final getIt = GetIt.instance;

  void configure() {
    getIt.registerFactory<UrlDatasourcePort>(() => UrlDatasource(getIt.get()));
    getIt.registerFactory<UrlRepositoryPort>(
      () => UrlRepository(getIt<UrlDatasourcePort>()),
    );
  }
}
