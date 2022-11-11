import 'dart:convert';
import 'dart:io';

import 'package:bringup_app/models/member.dart';
import 'package:bringup_app/utils/func.dart';
import 'package:bringup_app/utils/urls.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final myKey = GlobalKey<DropdownSearchState<Memberlist>>();

class DropdownSearchSelect extends StatefulWidget {
  const DropdownSearchSelect({super.key});

  @override
  State<DropdownSearchSelect> createState() => _DropdownSearchSelectState();
}

class _DropdownSearchSelectState extends State<DropdownSearchSelect> {
  List<Memberlist> members = [];
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    _listMembers();
    super.initState();
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
      showResponseDialog(context, 'Session ended, Login Again!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DropdownSearch<Memberlist>.multiSelection(
        key: myKey,
        items: members,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        clearButtonProps: const ClearButtonProps(isVisible: true),
        itemAsString: (item) => '${item.first_name} ${item.last_name}',
        compareFn: (item1, item2) => item1.pk == item2.pk,
        validator: (List<Memberlist>? items) {
          if (items == null || items.isEmpty) {
            return 'required field';
          }
          return null;
        },
        onChanged: (value) => value,
        popupProps: const PopupPropsMultiSelection.menu(
          showSearchBox: true,
          showSelectedItems: true,
        ),
      ),
    );
  }
}
