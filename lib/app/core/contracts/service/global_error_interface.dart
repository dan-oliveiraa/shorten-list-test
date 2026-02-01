import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/service/dto/global_error_dto.dart';

abstract class IGlobalErrorService {
  GlobalErrorDTO exceptionHandling(
    String message, {
    required Object exception,
    StackTrace? stackTrace,
  });

  RestResponse restExceptionHandling(Object exception);
}
