import 'dart:convert';

import 'package:shorten_list_test/app/core/contracts/rest_client/rest_body_content_interface.dart';

class RestBodyContentJson implements IRestBodyContent {
  final Object value;
  RestBodyContentJson.parse(Object json) : value = json;

  @override
  String get contentType => "application/json";

  @override
  render() {
    return jsonEncode(value);
  }
}
