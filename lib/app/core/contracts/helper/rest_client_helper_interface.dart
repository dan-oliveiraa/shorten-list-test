import 'package:dio/dio.dart';
import 'package:shorten_list_test/app/core/client/response/rest_response.dart';

import '../../client/response/client_response.dart';
import '../../exceptions/custom_http_exception.dart';

abstract class IRestClientHelper {
  RestResponse clientResponseToRestResponse(ClientResponse<dynamic> resp);
  RestResponse httpExceptionToRestResponse(CustomHttpException exception);
  RestResponse dioExceptionToRestResponse(DioException exception);
}
