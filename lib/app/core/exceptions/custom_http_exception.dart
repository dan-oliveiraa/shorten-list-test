class CustomHttpException implements Exception {
  final int statusCode;
  final String body;
  final Uri? uri;

  CustomHttpException({
    required this.statusCode,
    required this.body,
    required this.uri,
  });

  @override
  String toString() => 'CustomHttpException: $statusCode | URI: $uri | Body: $body';
}
