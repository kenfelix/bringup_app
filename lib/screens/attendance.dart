import 'dart:convert';
import 'dart:io';

import 'package:bringup_app/models/attendance-model.dart';
import 'package:bringup_app/models/member.dart';
import 'package:bringup_app/utils/pallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../utils/func.dart';
import '../utils/urls.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String query = '';
  List<Attendance> attendance = [];
  List<Attendance> queriedAttendance = [];
  List<Memberlist> members = [];
  final _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormBuilderState>();

  void _onChanged(dynamic value) => value.toString();

  _listAttendance() async {
    attendance = [];
    String? access = await _storage.read(key: 'access');

    final response = json.decode((await client.get(attendancelist,
            headers: {HttpHeaders.authorizationHeader: 'Bearer $access'}))
        .body);
    try {
      for (var element in response) {
        attendance.add(Attendance.fromMap(element));
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

  @override
  void initState() {
    _listAttendance();
    _listMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _listAttendance();
      },
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormBuilder(
                  key: _formKey,
                  onChanged: () {
                    _formKey.currentState!.save();
                    debugPrint(_formKey.currentState!.value.toString());
                    searchAttendance();
                  },
                  autovalidateMode: AutovalidateMode.disabled,
                  child: FormBuilderDateTimePicker(
                    name: 'date',
                    inputType: InputType.date,
                    firstDate: DateTime(1970),
                    format: DateFormat('yyyy-MM-dd'),
                    onChanged: _onChanged,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'dd-MM-yyyy',
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['date']
                                ?.didChange('0000-00-00');
                          }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.purple,
          height: 20,
          thickness: 40,
        ),
        const SizedBox(
          height: 10,
        ),
        titleText(),
        Expanded(
          child: ListView.builder(
            itemCount: queriedAttendance.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  memberNames(queriedAttendance[index].member),
                ),
                tileColor: Colors.white10,
                trailing: const Icon(FontAwesomeIcons.check),
                iconColor: Colors.purple,
              );
            },
          ),
        ),
      ]),
    );
  }

  void searchAttendance() {
    var data = _formKey.currentState!.value;
    query = data['date'].toString().substring(0, 10);

    if (query != '') {
      queriedAttendance = attendance
          .where((attendance) => attendance.date.contains(query))
          .toList();
      setState(() {});
    } else {
      _listAttendance();
    }
  }

  Widget titleText() {
    if (queriedAttendance.isNotEmpty) {
      return Text(
        queriedAttendance[1].title,
        style: kContentDisplayText,
      );
    }
    return const Text('');
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
