import 'url_value_object.dart';

class ShortenUrlInput {
  URL url;
  final String? uuid;

  ShortenUrlInput._({
    required this.url,
    this.uuid,
  });

  factory ShortenUrlInput({
    required URL url,
    String? uuid,
  }) {
    return ShortenUrlInput._(url: url, uuid: uuid);
  }

  factory ShortenUrlInput.empty() {
    return ShortenUrlInput._(url: URL.empty());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShortenUrlInput && other.url == url && other.uuid == uuid;
  }

  @override
  int get hashCode => url.hashCode ^ uuid.hashCode;

  @override
  String toString() => 'ShortenUrlInput(url: $url, uuid: $uuid)';
}
