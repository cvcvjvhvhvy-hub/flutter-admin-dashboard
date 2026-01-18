class ContentItem {
  String id;
  String title;
  String body;
  bool published;

  ContentItem({required this.id, required this.title, required this.body, this.published = false});

  ContentItem copyWith({String? id, String? title, String? body, bool? published}) {
    return ContentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      published: published ?? this.published,
    );
  }
}
