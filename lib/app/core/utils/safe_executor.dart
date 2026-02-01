import 'package:shorten_list_test/app/core/contracts/guards/safe_executor_interface.dart';

import '../../common/typedef/typedef.dart';
import '../contracts/service/global_error_interface.dart';

class SafeExecutor implements ISafeExecutor {
  final IGlobalErrorService _errorService;

  SafeExecutor(this._errorService);

  @override
  Future<T?> guard<T>(
    AsyncCallback<T> action, {
    required String contextErrorMessage,
    required GlobalErrorCallback onError,
  }) async {
    try {
      return await action();
    } catch (e, stack) {
      final globalError = _errorService.exceptionHandling(
        contextErrorMessage,
        exception: e,
        stackTrace: stack,
      );

      onError(globalError);
    }
    return null;
  }
}
