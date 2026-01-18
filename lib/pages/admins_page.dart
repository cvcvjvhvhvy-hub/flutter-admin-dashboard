import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/mock_service.dart';
import '../models/admin_account.dart';

class AdminsPage extends StatefulWidget {
  @override
  _AdminsPageState createState() => _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage> {
  final MockService _svc = MockService();
  List<AdminAccount> _admins = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _admins = await _svc.fetchAdmins();
    setState(() => _loading = false);
  }

  Future<void> _showEditor({AdminAccount? a}) async {
    final name = TextEditingController(text: a?.name ?? '');
    final email = TextEditingController(text: a?.email ?? '');
    final roleCtrl = TextEditingController(text: a?.role ?? 'admin');
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(a == null ? 'إضافة أدمن' : 'تعديل أدمن'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: name, decoration: InputDecoration(hintText: 'الاسم')),
          TextField(controller: email, decoration: InputDecoration(hintText: 'البريد')),
          TextField(controller: roleCtrl, decoration: InputDecoration(hintText: 'الدور')),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text('إلغاء')), ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text('حفظ'))],
      ),
    );
    if (ok != true) return;
    if (a == null) {
      final na = AdminAccount(id: Uuid().v4(), name: name.text.trim(), email: email.text.trim(), role: roleCtrl.text.trim());
      await _svc.addAdmin(na);
    } else {
      a.name = name.text.trim();
      a.email = email.text.trim();
      a.role = roleCtrl.text.trim();
      await _svc.updateAdmin(a);
    }
    await _load();
  }

  Future<void> _delete(String id) async {
    await _svc.deleteAdmin(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                Text('حسابات الأدمن', style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 8),
                Expanded(
                    child: ListView.builder(
                  itemCount: _admins.length,
                  itemBuilder: (_, i) {
                    final it = _admins[i];
                    return Card(
                      child: ListTile(
                        title: Text(it.name),
                        subtitle: Text('${it.email} • ${it.role}'),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(icon: Icon(Icons.edit), onPressed: () => _showEditor(a: it)),
                          IconButton(icon: Icon(Icons.delete), onPressed: () => _delete(it.id)),
                        ]),
                      ),
                    );
                  },
                ))
              ]),
            ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showEditor(), child: Icon(Icons.add)),
    );
  }
}
