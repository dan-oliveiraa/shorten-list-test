import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shorten_list_test/app/core/contracts/helper/rest_client_helper_interface.dart';
import 'package:shorten_list_test/app/core/contracts/service/global_error_interface.dart';
import 'package:shorten_list_test/app/core/exceptions/custom_exception.dart';
import 'package:shorten_list_test/app/core/exceptions/unauthorized_exception.dart';

import '../client/response/rest_response.dart';
import '../enum/global_error_types.dart';
import '../exceptions/custom_http_exception.dart';
import 'dto/global_error_dto.dart';

class GlobalErrorService implements IGlobalErrorService {
  final IRestClientHelper _helper;

  GlobalErrorService(this._helper);

  @override
  GlobalErrorDTO exceptionHandling(
    String message, {
    required Object exception,
    StackTrace? stackTrace,
  }) {
    return switch (exception) {
      _ when exception is CustomException => GlobalErrorDTO(
          type: exception.type,
          message: exception.message,
        ),
      _ when exception is UnauthorizedException => GlobalErrorDTO(
          type: GlobalErrorTypes.unauthorized,
          message: exception.message ?? "Unauthorized",
        ),
      _ when exception is PlatformException => GlobalErrorDTO(
          type: GlobalErrorTypes.hardware,
          message: exception.toString(),
        ),
      _ when exception is TimeoutException => GlobalErrorDTO(
          type: GlobalErrorTypes.timeout,
          message: "RequestTimeOut",
        ),
      _ => GlobalErrorDTO(
          type: GlobalErrorTypes.exception,
          message: exception.toString().replaceAll("Exception", ""),
        ),
    };
  }

  @override
  RestResponse restExceptionHandling(Object exception) {
    return switch (exception) {
      _ when exception is DioException => _helper.dioExceptionToRestResponse(exception),
      _ when exception is CustomHttpException => _helper.httpExceptionToRestResponse(exception),
      _ => RestResponse(
          statusCode: 0,
          content: exception.toString(),
          contentBytes: Uint8List(8),
          url: '',
        ),
    };
  }
}
