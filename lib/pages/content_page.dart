import 'package:flutter/material.dart';
import '../models/content.dart';
import '../services/mock_service.dart';
import 'package:uuid/uuid.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final MockService _svc = MockService();
  List<ContentItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _items = await _svc.fetchContents();
    setState(() => _loading = false);
  }

  void _showEditor({ContentItem? item}) {
    final _formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: item?.title ?? '');
    final bodyCtrl = TextEditingController(text: item?.body ?? '');
    bool published = item?.published ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item == null ? 'إضافة محتوى' : 'تعديل محتوى'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: titleCtrl, decoration: InputDecoration(labelText: 'العنوان'), validator: (v) => (v==null||v.trim().isEmpty)? 'العنوان مطلوب' : null),
                TextFormField(controller: bodyCtrl, decoration: InputDecoration(labelText: 'المحتوى'), maxLines: 4, validator: (v) => (v==null||v.trim().isEmpty)? 'المحتوى مطلوب' : null),
                Row(
                  children: [
                    StatefulBuilder(builder: (c, setS) => Checkbox(value: published, onChanged: (v) => setS(() => published = v ?? false))),
                    Text('منشور')
                  ],
                )
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              final id = item?.id ?? Uuid().v4();
              final c = ContentItem(id: id, title: titleCtrl.text.trim(), body: bodyCtrl.text.trim(), published: published);
              if (item == null) await _svc.addContent(c); else await _svc.updateContent(c);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم الحفظ')));
              await _load();
            },
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _delete(String id) async {
    await _svc.deleteContent(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text('إدارة المحتوى', style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (_, i) {
                        final it = _items[i];
                        return Card(
                          child: ListTile(
                            title: Text(it.title),
                            subtitle: Text(it.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(icon: Icon(Icons.edit), onPressed: () => _showEditor(item: it)),
                              IconButton(icon: Icon(Icons.delete), onPressed: () => _delete(it.id)),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showEditor(), child: Icon(Icons.add)),
    );
  }
}
