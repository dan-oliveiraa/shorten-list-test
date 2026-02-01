abstract class IAppResolveUri {
  Uri resolveApi(String api);
  Uri resolveWeb(String prefix);
  String resolveUri({
    required String api,
    required String url,
  });
}
