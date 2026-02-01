import 'package:shorten_list_test/app/core/contracts/app_rest_client/app_resolve_interface.dart';

class AppResolveUri implements IAppResolveUri {
  final String Function() onBaseUrl;

  AppResolveUri(this.onBaseUrl);

  Uri get _appUrl => Uri.parse(onBaseUrl());

  @override
  Uri resolveApi(String api) {
    return _appUrl.resolveUri(Uri(path: "api/$api/"));
  }

  @override
  Uri resolveWeb(String prefix) {
    return _appUrl.resolveUri(Uri(path: "/$prefix/"));
  }

  @override
  String resolveUri({required String api, required String url}) {
    final baseUrl = resolveApi(api);

    String auxUrl = url.trim();

    if (auxUrl.startsWith("/")) {
      auxUrl = auxUrl.substring(1);
    }

    Uri uri = baseUrl.resolveUri(Uri.parse(auxUrl));

    return uri.toString();
  }
}
