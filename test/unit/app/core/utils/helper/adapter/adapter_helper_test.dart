import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/client/dto/rest_object.dart';
import 'package:shorten_list_test/app/core/exceptions/custom_http_exception.dart';
import 'package:shorten_list_test/app/core/utils/helper/adapter/adapter_helper.dart';

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class FakeHttpHeaders extends Fake implements HttpHeaders {
  final Map<String, String> _values = {};
  ContentType? _contentType;

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _values[name] = value.toString();
  }

  @override
  String? value(String name) => _values[name];

  @override
  ContentType? get contentType => _contentType;

  @override
  set contentType(ContentType? value) => _contentType = value;
}

class FakeRedirectInfo extends Fake implements RedirectInfo {
  @override
  Uri get location => Uri.parse('http://redirect');
}

void main() {
  late AdapterHelper helper;
  late MockHttpClientRequest request;
  late MockHttpClientResponse response;

  setUp(() {
    helper = AdapterHelper();
    request = MockHttpClientRequest();
    response = MockHttpClientResponse();
  });

  test('applyOptions sets headers and json content type', () {
    final headers = FakeHttpHeaders();
    when(() => request.headers).thenReturn(headers);

    final options = RestOptions(
      headers: {'x': '1'},
      receiveTimeout: const Duration(seconds: 1),
      sendTimeout: const Duration(seconds: 1),
    );

    helper.applyOptions(request, options);

    expect(headers.value('x'), '1');
    expect(headers.contentType, isNotNull);
    expect(headers.contentType?.mimeType, 'application/json');
  });

  test('writeBody writes json when body is provided', () {
    when(() => request.write(any())).thenReturn(null);

    helper.writeBody(request, {'a': 1});

    verify(() => request.write(json.encode({'a': 1}))).called(1);
  });

  test('readResponse returns decoded json for successful response', () async {
    when(() => response.statusCode).thenReturn(200);
    when(() => response.transform<String>(utf8.decoder)).thenAnswer(
      (_) => Stream<String>.value('{"a":1}'),
    );

    final result = await helper.readResponse(response);

    expect(result, {'a': 1});
  });

  test('readResponse throws CustomHttpException on error status', () async {
    when(() => response.statusCode).thenReturn(400);
    when(() => response.redirects).thenReturn([FakeRedirectInfo()]);
    when(() => response.transform<String>(utf8.decoder)).thenAnswer(
      (_) => Stream<String>.value('bad-request'),
    );

    expect(
      () => helper.readResponse(response),
      throwsA(
        isA<CustomHttpException>()
            .having((e) => e.statusCode, 'statusCode', 400)
            .having((e) => e.body, 'body', 'bad-request')
            .having((e) => e.uri.toString(), 'uri', 'http://redirect'),
      ),
    );
  });
}
