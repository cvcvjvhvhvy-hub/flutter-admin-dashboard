import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/mock_service.dart';
import '../models/complaint.dart';
import 'package:flutter/services.dart';

class ComplaintsPage extends StatefulWidget {
  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final MockService _svc = MockService();
  List<Complaint> _items = [];
  bool _loading = true;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _items = await _svc.fetchComplaints();
    setState(() => _loading = false);
  }

  void _showDetails(Complaint c) async {
    final status = c.status;
    final priority = c.priority;
    final noteCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تفاصيل البلاغ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('العنوان: ${c.title}'),
              SizedBox(height: 8),
              Text('البلاغ: ${c.body}'),
              SizedBox(height: 8),
              Text('الأولوية: $priority'),
              SizedBox(height: 8),
              Text('الحالة: $status'),
              SizedBox(height: 12),
              TextField(controller: noteCtrl, decoration: InputDecoration(hintText: 'رد سريع أو ملاحظة')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق')),
          TextButton(
              onPressed: () {
                final wa = 'https://wa.me/?text=${Uri.encodeComponent('${c.title} - ${c.body}') }';
                Clipboard.setData(ClipboardData(text: wa));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم نسخ رابط واتساب (افتحه في المتصفح)')));
              },
              child: Text('رد عبر واتساب')),
          ElevatedButton(
              onPressed: () async {
                c.status = 'in_progress';
                c.updatedAt = DateTime.now();
                await _svc.updateComplaint(c);
                Navigator.pop(context);
                await _load();
              },
              child: Text('بدء المعالجة')),
        ],
      ),
    );
  }

  Future<void> _addNew() async {
    final title = TextEditingController();
    final body = TextEditingController();
    final pr = ValueNotifier<String>('medium');
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('إنشاء بلاغ جديد'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: title, decoration: InputDecoration(hintText: 'العنوان')),
          TextField(controller: body, decoration: InputDecoration(hintText: 'نص البلاغ')),
          ValueListenableBuilder<String>(valueListenable: pr, builder: (_, v, __) => DropdownButton<String>(value: v, items: ['high', 'medium', 'low'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (s) => pr.value = s ?? 'medium')),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text('إلغاء')), ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('إنشاء'))],
      ),
    );
    if (ok != true) return;
    final c = Complaint(id: Uuid().v4(), title: title.text.trim(), body: body.text.trim(), reporterId: 'unknown', priority: pr.value);
    await _svc.addComplaint(c);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final list = _filter == 'all' ? _items : _items.where((x) => x.status == _filter).toList();
    return Scaffold(
      appBar: AppBar(actions: [
        PopupMenuButton<String>(onSelected: (v) => setState(() => _filter = v), itemBuilder: (_) => [
          PopupMenuItem(value: 'all', child: Text('الكل')),
          PopupMenuItem(value: 'new', child: Text('جديدة')),
          PopupMenuItem(value: 'in_progress', child: Text('قيد المعالجة')),
          PopupMenuItem(value: 'done', child: Text('منجزة')),
        ])
      ]),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('الشكاوى والدعم', style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 8),
                Expanded(
                    child: list.isEmpty
                        ? Center(child: Text('لا توجد شكاوى'))
                        : ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (_, i) {
                              final it = list[i];
                              return Card(
                                child: ListTile(
                                  title: Text(it.title),
                                  subtitle: Text('${it.priority} • ${it.status} • ${it.createdAt.toLocal().toString().split('.').first}'),
                                  trailing: IconButton(icon: Icon(Icons.open_in_new), onPressed: () => _showDetails(it)),
                                ),
                              );
                            },
                          ))
              ]),
            ),
      floatingActionButton: FloatingActionButton(onPressed: _addNew, child: Icon(Icons.add)),
    );
  }
}
