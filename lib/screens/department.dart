import 'dart:convert';
import 'dart:io';

import 'package:bringup_app/custom_widget/search-widget.dart';
import 'package:bringup_app/models/member.dart';
import 'package:bringup_app/models/departmentmodel.dart';
import 'package:bringup_app/utils/func.dart';
import 'package:bringup_app/utils/pallet.dart';
import 'package:bringup_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({Key? key}) : super(key: key);

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  // final _storage = const FlutterSecureStorage();
  http.Client client = http.Client();
  List<Department> departments = [];
  List<Memberlist> members = [];
  String query = '';
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    _listDepartment();
    _listMembers();
    super.initState();
  }

  _listDepartment() async {
    departments = [];
    String? access = await _storage.read(key: 'access');

    final response = json.decode((await client.get(departmentUrl,
            headers: {HttpHeaders.authorizationHeader: 'Bearer $access'}))
        .body);
    try {
      for (var element in response) {
        departments.add(Department.fromMap(element));
      }
      setState(() {});
    } catch (e) {
      // ignore: use_build_context_synchronously
      showResponseDialog(context, 'Session Over.\n Login Again');
    }
  }

  _listMembers() async {
    members = [];
    String? access = await _storage.read(key: 'access');

    final response = json.decode((await client.get(memberList,
            headers: {HttpHeaders.authorizationHeader: 'Bearer $access'}))
        .body);
    try {
      for (var element in response) {
        members.add((Memberlist.fromMap(element)));
      }
      setState(() {});
    } catch (e) {
      // ignore: use_build_context_synchronously
      return;
    }
  }

  _removeMember(int id) async {
    String? access = await _storage.read(key: 'access');

    try {
      await client.delete(departmentDeleteUrl(id.toString()),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $access'},
          encoding: utf8);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _listDepartment();
      },
      child: Column(
        children: <Widget>[
          buildSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: departments.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    memberNames(departments[index].member),
                    style: kBodynameText,
                  ),
                  subtitle: Text(
                    'department: ${departments[index].name} \nstatus: ${departments[index].status}',
                    style: kBodystatusText,
                  ),
                  minVerticalPadding: 15,
                  trailing: IconButton(
                    onPressed: () async {
                      _removeMember(departments[index].pk);
                      _listDepartment();
                    },
                    icon: const Icon(FontAwesomeIcons.deleteLeft),
                  ),
                  iconColor: Colors.purple,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Name or Status',
        onChanged: searchMember,
      );

  void searchMember(String query) {
    if (query != '') {
      departments = departments
          .where((departments) =>
              departments.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {});
    } else {
      _listDepartment();
    }
  }

  String memberNames(int pk) {
    for (var member in members) {
      if (member.pk == pk) {
        return '${member.first_name} ${member.last_name}';
      }
    }
    return '';
  }
}
