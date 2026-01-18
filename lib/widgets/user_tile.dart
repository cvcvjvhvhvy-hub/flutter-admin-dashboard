import 'package:flutter/material.dart';
import '../models/user.dart';

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool selected;
  final ValueChanged<bool> onSelect;

  const UserTile({required this.user, required this.onEdit, required this.onDelete, this.selected = false, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(mainAxisSize: MainAxisSize.min, children: [
        Checkbox(value: selected, onChanged: (v) => onSelect(v ?? false)),
        CircleAvatar(child: Text(user.name.isNotEmpty ? user.name[0] : '?')),
      ]),
      title: Text(user.name),
      subtitle: Text('${user.email} • ${user.role}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
