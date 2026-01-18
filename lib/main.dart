import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/users_page.dart';
import 'pages/content_page.dart';
import 'pages/notifications_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/complaints_page.dart';
import 'pages/admins_page.dart';
import 'pages/tech_page.dart';

void main() {
  runApp(AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      locale: Locale('ar'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('ar')],
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardHome(),
    );
  }
}

class DashboardHome extends StatefulWidget {
  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _selectedIndex = 0;

  final _pages = [
    DashboardPage(),
    UsersPage(),
    ContentPage(),
    ComplaintsPage(),
    NotificationsPage(),
    AdminsPage(),
    TechPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة التحكم'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('Admin', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('لوحة المعلومات'),
              selected: _selectedIndex == 0,
              onTap: () => _select(0),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('إدارة المستخدمين'),
              selected: _selectedIndex == 1,
              onTap: () => _select(1),
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('إدارة المحتوى'),
              selected: _selectedIndex == 2,
              onTap: () => _select(2),
            ),
            ListTile(
              leading: Icon(Icons.report_problem),
              title: Text('الشكاوى والدعم'),
              selected: _selectedIndex == 3,
              onTap: () => _select(3),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('الإشعارات'),
              selected: _selectedIndex == 4,
              onTap: () => _select(4),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('حسابات الأدمن'),
              selected: _selectedIndex == 5,
              onTap: () => _select(5),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('المدير التقني'),
              selected: _selectedIndex == 6,
              onTap: () => _select(6),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  void _select(int idx) {
    setState(() {
      _selectedIndex = idx;
    });
    Navigator.of(context).pop();
  }
}
