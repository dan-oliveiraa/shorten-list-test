import '../../../common/typedef/typedef.dart';

class RestOptions {
  final Duration sendTimeout;
  final Duration receiveTimeout;
  Map<String, dynamic>? headers;
  final JsonParser? parser;

  RestOptions({
    required this.headers,
    required this.receiveTimeout,
    required this.sendTimeout,
    this.parser,
  });
}
