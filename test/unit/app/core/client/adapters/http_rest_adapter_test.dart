import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/client/adapters/http_rest_adapter.dart';
import 'package:shorten_list_test/app/core/client/dto/rest_object.dart';
import 'package:shorten_list_test/app/core/client/response/client_response.dart';
import 'package:shorten_list_test/app/core/contracts/helper/adapter_helper_interface.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockAdapterHelper extends Mock implements IAdapterHelper {}

void main() {
  late MockHttpClient client;
  late MockHttpClientRequest request;
  late MockHttpClientResponse response;
  late MockAdapterHelper helper;
  late HttpRestAdapter adapter;

  final options = RestOptions(
    headers: {'a': 'b'},
    receiveTimeout: const Duration(seconds: 1),
    sendTimeout: const Duration(seconds: 1),
  );

  setUpAll(() {
    registerFallbackValue(Uri.parse('http://example.com'));
    registerFallbackValue(options);
  });

  setUp(() {
    client = MockHttpClient();
    request = MockHttpClientRequest();
    response = MockHttpClientResponse();
    helper = MockAdapterHelper();
    adapter = HttpRestAdapter(client, helper);
  });

  Future<void> setUpCommon() async {
    when(() => helper.applyOptions(request, options)).thenReturn(request);
    when(() => response.statusCode).thenReturn(200);
    when(() => request.close()).thenAnswer((_) async => response);
    when(() => helper.readResponse(response)).thenAnswer((_) async => {'ok': true});
    when(() => helper.buildClientResponse<dynamic>(
          any(),
          response,
          options,
          any(),
        )).thenReturn(
      const ClientResponse<dynamic>(
        data: {'ok': true},
        statusCode: 200,
        headers: {},
        url: 'http://example.com',
      ),
    );
  }

  test('post writes body and returns response', () async {
    await setUpCommon();

    when(() => client.postUrl(any())).thenAnswer((_) async => request);
    when(() => helper.writeBody(request, any())).thenReturn(request);

    final result = await adapter.post(
      'http://example.com',
      body: {'x': 1},
      options: options,
    );

    expect(result.statusCode, 200);
    verify(() => helper.writeBody(request, {'x': 1})).called(1);
    verify(() => helper.applyOptions(request, options)).called(1);
  });
}
