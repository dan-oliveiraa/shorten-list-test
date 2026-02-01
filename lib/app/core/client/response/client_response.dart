class ClientResponse<T> {
  final T? data;
  final int statusCode;
  final Map<String, String> headers;
  final String url;

  const ClientResponse({
    required this.statusCode,
    required this.headers,
    required this.url,
    this.data,
  });
}
