class URL {
  String value;

  URL._(this.value);

  factory URL(String value) {
    return URL._(value);
  }

  factory URL.empty() {
    return URL._('');
  }

  bool get isEmpty => value.isEmpty;
  bool get isValid => validate(value) == null;

  static String? validate(String url) {
    if (url.isEmpty) {
      return 'URL cannot be empty';
    }

    final validExtensions = ['.com', '.br', '.dev', '.gov'];
    final hasValidExtension = validExtensions.any((ext) => url.endsWith(ext));

    if (!hasValidExtension) {
      return 'Invalid URL format.';
    }

    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );

    if (!urlPattern.hasMatch(url)) {
      return 'Invalid URL format.';
    }

    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is URL && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
