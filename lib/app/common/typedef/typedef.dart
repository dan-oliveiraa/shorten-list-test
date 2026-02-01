import 'package:shorten_list_test/app/core/service/dto/global_error_dto.dart';

typedef JsonParser<T> = T Function(dynamic data);
typedef AsyncCallback<T> = Future<T> Function();
typedef GlobalErrorCallback = void Function(GlobalErrorDTO globalError);
