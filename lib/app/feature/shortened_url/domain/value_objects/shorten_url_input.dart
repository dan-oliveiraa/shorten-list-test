import 'url_value_object.dart';

class ShortenUrlInput {
  URL url;

  ShortenUrlInput._({
    required this.url,
  });

  factory ShortenUrlInput({
    required URL url,
  }) {
    return ShortenUrlInput._(url: url);
  }

  factory ShortenUrlInput.empty() {
    return ShortenUrlInput._(url: URL.empty());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShortenUrlInput && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => 'ShortenUrlInput(url: $url)';
}
