import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:shorten_list_test/app/core/client/adapters/http_rest_adapter.dart';
import 'package:shorten_list_test/app/core/client/rest_client/app_rest_client/app_resolve_url.dart';
import 'package:shorten_list_test/app/core/client/rest_client/app_rest_client/app_rest_client.dart';
import 'package:shorten_list_test/app/core/client/rest_client/rest/rest_client.dart';
import 'package:shorten_list_test/app/core/contracts/adapter/rest_adapter_interface.dart';
import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_resolve_interface.dart';
import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_rest_client_interface.dart';
import 'package:shorten_list_test/app/core/contracts/guards/safe_executor_interface.dart';
import 'package:shorten_list_test/app/core/contracts/helper/adapter_helper_interface.dart';
import 'package:shorten_list_test/app/core/contracts/helper/rest_client_helper_interface.dart';
import 'package:shorten_list_test/app/core/contracts/rest_client/rest_client_interface.dart';
import 'package:shorten_list_test/app/core/contracts/service/global_error_interface.dart';
import 'package:shorten_list_test/app/core/service/global_error.dart';
import 'package:shorten_list_test/app/core/utils/helper/adapter/adapter_helper.dart';
import 'package:shorten_list_test/app/core/utils/helper/client/rest_client_helper.dart';
import 'package:shorten_list_test/app/core/utils/safe_executor.dart';

class CoreModules {
  void configure() {
    final getIt = GetIt.instance;
    getIt
      ..registerSingleton<IAdapterHelper>(AdapterHelper())
      ..registerSingleton<IRestClientHelper>(RestClientHelper())
      ..registerSingleton<IGlobalErrorService>(GlobalErrorService(getIt.get()))
      ..registerSingleton<IRestAdapter>(HttpRestAdapter(
        HttpClient(),
        getIt.get(),
      ))
      ..registerSingleton<IAppResolveUri>(
          AppResolveUri(() => "https://url-shortener-server.onrender.com/api/alias"))
      ..registerSingleton<IRestClient>(RestClient(getIt.get()))
      ..registerSingleton<IAppRestClient>(AppRestClient(
        getIt.get(),
        getIt.get(),
        getIt.get(),
        getIt.get(),
      ))
      ..registerSingleton<ISafeExecutor>(SafeExecutor(getIt.get()));
  }
}
