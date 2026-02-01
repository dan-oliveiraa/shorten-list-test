class MapHelper {
  static Map<String, String> mergeMaps(List<Map<String, String>?> params) {
    Map<String, String>? finalHeaders;

    for (var element in params) {
      if (element != null) {
        finalHeaders ??= <String, String>{};

        finalHeaders.addAll(element);
      }
    }

    return finalHeaders ?? {};
  }
}
