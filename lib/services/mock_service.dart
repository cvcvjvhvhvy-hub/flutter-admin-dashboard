import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/content.dart';
import '../models/notification_item.dart';
import '../models/complaint.dart';
import '../models/admin_account.dart';

class MockService {
  static final MockService _instance = MockService._internal();
  factory MockService() => _instance;
  MockService._internal() {
    // seed some data
    _users = [
      User(id: '1', name: 'Ali', email: 'ali@example.com', role: 'admin'),
      User(id: '2', name: 'Sara', email: 'sara@example.com', role: 'editor'),
    ];
    _contents = [
      ContentItem(id: 'c1', title: 'مرحباً', body: 'هذه مقالة تجريبية', published: true),
    ];
    _notifications = [
      NotificationItem(id: Uuid().v4(), message: 'نظام: تم إنشاء اللوحة التجريبية'),
    ];
    _complaints = [
      Complaint(id: 't1', title: 'مشكلة تسجيل', body: 'لا يمكنني تسجيل الدخول', reporterId: '2', priority: 'high'),
    ];
    _admins = [
      AdminAccount(id: 'a1', name: 'Super', email: 'super@admin.com', role: 'superadmin', permissions: ['all']),
    ];
  }

  late List<User> _users;
  late List<ContentItem> _contents;
  late List<NotificationItem> _notifications;
  late List<Complaint> _complaints;
  late List<AdminAccount> _admins;

  Future<List<User>> fetchUsers() async => Future.delayed(Duration(milliseconds: 200), () => List.from(_users));
  Future<void> addUser(User u) async => Future.delayed(Duration(milliseconds: 200), () => _users.add(u));
  Future<void> updateUser(User u) async => Future.delayed(Duration(milliseconds: 200), () {
        final idx = _users.indexWhere((x) => x.id == u.id);
        if (idx != -1) _users[idx] = u;
      });
  Future<void> deleteUser(String id) async => Future.delayed(Duration(milliseconds: 200), () => _users.removeWhere((u) => u.id == id));

  Future<List<ContentItem>> fetchContents() async => Future.delayed(Duration(milliseconds: 200), () => List.from(_contents));
  Future<void> addContent(ContentItem c) async => Future.delayed(Duration(milliseconds: 200), () => _contents.add(c));
  Future<void> updateContent(ContentItem c) async => Future.delayed(Duration(milliseconds: 200), () {
        final idx = _contents.indexWhere((x) => x.id == c.id);
        if (idx != -1) _contents[idx] = c;
      });
  Future<void> deleteContent(String id) async => Future.delayed(Duration(milliseconds: 200), () => _contents.removeWhere((c) => c.id == id));

    Future<List<NotificationItem>> fetchNotifications() async =>
      Future.delayed(Duration(milliseconds: 200), () => List.from(_notifications));
    Future<void> sendNotification(NotificationItem note) async =>
      Future.delayed(Duration(milliseconds: 200), () => _notifications.insert(0, note));
    Future<void> deleteNotification(String id) async =>
      Future.delayed(Duration(milliseconds: 200), () => _notifications.removeWhere((n) => n.id == id));

  Future<int> countUsers() async => (await fetchUsers()).length;
  Future<int> countContents() async => (await fetchContents()).length;
  Future<int> countNotifications() async => (await fetchNotifications()).length;

  // Complaints
  Future<List<Complaint>> fetchComplaints() async => Future.delayed(Duration(milliseconds: 200), () => List.from(_complaints));
  Future<void> addComplaint(Complaint c) async => Future.delayed(Duration(milliseconds: 200), () => _complaints.insert(0, c));
  Future<void> updateComplaint(Complaint c) async => Future.delayed(Duration(milliseconds: 200), () {
        final idx = _complaints.indexWhere((x) => x.id == c.id);
        if (idx != -1) _complaints[idx] = c;
      });
  Future<void> deleteComplaint(String id) async => Future.delayed(Duration(milliseconds: 200), () => _complaints.removeWhere((c) => c.id == id));

  // Admins
  Future<List<AdminAccount>> fetchAdmins() async => Future.delayed(Duration(milliseconds: 200), () => List.from(_admins));
  Future<void> addAdmin(AdminAccount a) async => Future.delayed(Duration(milliseconds: 200), () => _admins.add(a));
  Future<void> updateAdmin(AdminAccount a) async => Future.delayed(Duration(milliseconds: 200), () {
        final idx = _admins.indexWhere((x) => x.id == a.id);
        if (idx != -1) _admins[idx] = a;
      });
  Future<void> deleteAdmin(String id) async => Future.delayed(Duration(milliseconds: 200), () => _admins.removeWhere((a) => a.id == id));
}
