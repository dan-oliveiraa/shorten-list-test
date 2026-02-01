import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shorten_list_test/app/core/client/response/rest_response.dart';
import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_rest_client_interface.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/datasource/url_datasource.dart';
import 'package:shorten_list_test/app/feature/shortened_url/data/mappers/shortened_link_mapper.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/shorten_url_input.dart';
import 'package:shorten_list_test/app/feature/shortened_url/domain/value_objects/url_value_object.dart';

class MockAppRestClient extends Mock implements IAppRestClient {}

void main() {
  late MockAppRestClient mockClient;
  late UrlDatasource datasource;

  setUp(() {
    mockClient = MockAppRestClient();
    datasource = UrlDatasource(mockClient);
  });

  group('UrlDatasource', () {
    group('shortenUrl', () {
      test('should send POST request with correct URL and body', () async {
        final input = ShortenUrlInput(url: URL('https://example.com'));
        final responseData = {
          'alias': 'abc123',
          '_links': {
            'self': 'https://example.com',
            'short': 'https://short.url/abc123',
          }
        };
        final responseContent = jsonEncode(responseData);
        final response = RestResponse(
          statusCode: 200,
          content: responseContent,
          contentBytes: Uint8List.fromList(responseContent.codeUnits),
          url: 'https://url-shortener-server.onrender.com/api/alias',
        );

        when(() => mockClient.sendPost(
              url: any(named: 'url'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => response);

        await datasource.shortenUrl(input);

        verify(() => mockClient.sendPost(
              url: 'https://url-shortener-server.onrender.com/api/alias',
              body: {'url': 'https://example.com'},
            )).called(1);
      });

      test('should parse successful response and return ShortenedLinkMapper', () async {
        final input = ShortenUrlInput(url: URL('https://example.com'));
        final responseData = {
          'alias': 'abc123',
          '_links': {
            'self': 'https://example.com',
            'short': 'https://short.url/abc123',
          }
        };
        final responseContent = jsonEncode(responseData);
        final response = RestResponse(
          statusCode: 200,
          content: responseContent,
          contentBytes: Uint8List.fromList(responseContent.codeUnits),
          url: 'https://url-shortener-server.onrender.com/api/alias',
        );

        when(() => mockClient.sendPost(
              url: any(named: 'url'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => response);

        final result = await datasource.shortenUrl(input);

        expect(result, isA<ShortenedLinkMapper>());
        expect(result.alias, 'abc123');
        expect(result.link.originalUrl, 'https://example.com');
        expect(result.link.shortenedUrl, 'https://short.url/abc123');
      });
      test('should handle malformed JSON response', () async {
        final input = ShortenUrlInput(url: URL('https://example.com'));
        const responseContent = 'invalid json {{{';
        final response = RestResponse(
          statusCode: 200,
          content: responseContent,
          contentBytes: Uint8List.fromList(responseContent.codeUnits),
          url: 'https://url-shortener-server.onrender.com/api/alias',
        );

        when(() => mockClient.sendPost(
              url: any(named: 'url'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => response);

        expect(
          () => datasource.shortenUrl(input),
          throwsA(isA<FormatException>()),
        );
      });

      test('should throw when ensureSuccess fails for non-2xx status', () async {
        final input = ShortenUrlInput(url: URL('https://example.com'));
        const responseContent = 'Bad Request';
        final response = RestResponse(
          statusCode: 400,
          content: responseContent,
          contentBytes: Uint8List.fromList(responseContent.codeUnits),
          url: 'https://url-shortener-server.onrender.com/api/alias',
        );

        when(() => mockClient.sendPost(
              url: any(named: 'url'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => response);

        expect(
          () => datasource.shortenUrl(input),
          throwsA(anything),
        );
      });

      test('should propagate network exceptions from client', () async {
        final input = ShortenUrlInput(url: URL('https://example.com'));

        when(() => mockClient.sendPost(
              url: any(named: 'url'),
              body: any(named: 'body'),
            )).thenThrow(Exception('Network error'));

        expect(
          () => datasource.shortenUrl(input),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
