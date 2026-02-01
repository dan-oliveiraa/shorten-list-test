class LinkEntity {
  final String originalUrl;
  final String shortenedUrl;
  bool get isEmpty => originalUrl.isEmpty && shortenedUrl.isEmpty;

  LinkEntity({
    required this.originalUrl,
    required this.shortenedUrl,
  });
}
