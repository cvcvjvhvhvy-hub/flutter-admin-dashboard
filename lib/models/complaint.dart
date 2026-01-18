class Complaint {
  final String id;
  String title;
  String body;
  String reporterId;
  String status; // new, in_progress, done
  String priority; // high, medium, low
  DateTime createdAt;
  DateTime updatedAt;
  List<String> attachments;

  Complaint({
    required this.id,
    required this.title,
    required this.body,
    required this.reporterId,
    this.status = 'new',
    this.priority = 'medium',
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? attachments,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        attachments = attachments ?? [];
}
