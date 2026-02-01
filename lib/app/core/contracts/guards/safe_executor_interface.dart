import 'package:shorten_list_test/app/common/typedef/typedef.dart';

abstract class ISafeExecutor {
  Future<T?> guard<T>(
    AsyncCallback<T> action, {
    required String contextErrorMessage,
    required GlobalErrorCallback onError,
  });
}
