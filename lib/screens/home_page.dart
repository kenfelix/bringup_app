import 'dart:convert';
import 'dart:io';

import 'package:bringup_app/custom_widget/search-widget.dart';
import 'package:bringup_app/models/member.dart';
import 'package:bringup_app/utils/func.dart';
import 'package:bringup_app/utils/pallet.dart';
import 'package:bringup_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../detail_screen/member_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _storage = const FlutterSecureStorage();
  http.Client client = http.Client();
  final _storage = const FlutterSecureStorage();

  List<Memberlist> members = [];
  String query = '';

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
      showResponseDialog(context, 'Session Over.\n Login Again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _listMembers();
      },
      child: Column(
        children: <Widget>[
          buildSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    '${members[index].first_name} ${members[index].last_name}',
                    style: kBodynameText,
                  ),
                  subtitle: Text(
                    'status: ${members[index].status}',
                    style: kBodystatusText,
                  ),
                  minVerticalPadding: 15,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MemberDetailPage(
                              url: members[index].url,
                              client: client,
                            )));
                  },
                  trailing: IconButton(
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber(
                          members[index].phone_number.toString());
                    },
                    icon: const Icon(FontAwesomeIcons.phone),
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
      members = members
          .where((member) =>
              member.first_name.toLowerCase().contains(query.toLowerCase()) ||
              member.last_name.toLowerCase().contains(query.toLowerCase()) ||
              member.status.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {});
    } else {
      _listMembers();
    }
  }
}
