import 'package:bringup_app/form_screen/add_attendance.dart';
import 'package:bringup_app/form_screen/add_department.dart';
import 'package:bringup_app/form_screen/add_member.dart';
import 'package:bringup_app/screens/attendance.dart';
import 'package:bringup_app/screens/department.dart';
import 'package:bringup_app/screens/message.dart';
import 'package:bringup_app/utils/func.dart';
import 'package:bringup_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'home_page.dart';
import 'login.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [
    HomePage(),
    DepartmentPage(),
    AttendancePage(),
  ];
  List<Widget> adds = [
    const MemberFormScreen(),
    const DepartmentFormScreen(),
    const AttendanceFormScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TBringup'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: ((context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('admin'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('logout'),
                  ),
                ]),
          ),
        ],
      ),
      body: pages[currentPage],
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.home_menu,
        childrenButtonSize: const Size(60, 60),
        children: [
          SpeedDialChild(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => adds[currentPage])),
              child: const Icon(Icons.add),
              label: 'Add'),
          SpeedDialChild(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SendMessage())),
              child: const Icon(Icons.mail),
              label: 'Message'),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Department'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Attendance'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}

void onSelected(BuildContext context, int item) {
  switch (item) {
    case 0:
      try {
        launchAdmin(adminUrl);
      } catch (e) {
        showResponseDialog(context, e.toString());
      }
      break;
    case 1:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Login()),
      );
      break;
    default:
  }
}
