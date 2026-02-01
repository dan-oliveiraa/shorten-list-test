class LinkMapper {
  final String originalUrl;
  final String shortenedUrl;
  bool get isEmpty => originalUrl.isEmpty && shortenedUrl.isEmpty;

  LinkMapper({
    required this.originalUrl,
    required this.shortenedUrl,
  });

  factory LinkMapper.fromMap(Map<String, dynamic> map) {
    return LinkMapper(
      originalUrl: map['original_url'] ?? '',
      shortenedUrl: map['shortened_url'] ?? '',
    );
  }
}
