// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:bringup_app/custom_widget/custom_widget.dart';
import 'package:bringup_app/models/member.dart';
import 'package:bringup_app/update_screen/member_update.dart';
import 'package:bringup_app/utils/func.dart';
import 'package:bringup_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class MemberDetailPage extends StatefulWidget {
  final Client client;
  final String url;
  const MemberDetailPage({
    super.key,
    required this.client,
    required this.url,
  });

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  final _storage = const FlutterSecureStorage();
  Member member = Member(
    pk: 1,
    first_name: '',
    last_name: '',
    phone_number: '',
    sex: '',
    email: '',
    address: '',
    date_of_birth: '',
    state_of_origin: '',
    nationality: '',
    departments: [],
    member_choice: true,
    status: '',
  );

  @override
  void initState() {
    try {
      _memberDetails();
    } catch (e) {
      if (e != '')
        showResponseDialog(context, 'Permission/Session over login again');
    }
    super.initState();
  }

  _memberDetails() async {
    String? access = await _storage.read(key: 'access');

    final response = await client.get(Uri.parse(widget.url.toString()),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $access'});
    final body = json.decode((response.body));

    switch (response.statusCode) {
      case 200:
        member = Member.fromMap(body);
        setState(() {});
        break;
      default:
        throw json.decode(response.body)['message'];
    }
  }

  _deleteMember() async {
    String? access = await _storage.read(key: 'access');
    try {
      final response = await client.delete(
          memberDeleteUrl(member.pk.toString()),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $access'},
          encoding: utf8);
      Navigator.pop(
        context,
      );
    } catch (e) {
      print(e);
    }
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => MemberUpdate(
                    member: member,
                  )),
        );
        break;
      case 1:
        _deleteMember();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Details'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: ((context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Delete'),
                  ),
                ]),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeadingContentDisplay(
                heading: 'Full Name',
                content: '${member.first_name} ${member.last_name}',
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'Phone Number',
                content: member.phone_number,
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'Sex',
                content: member.sex,
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'Email Address',
                content: member.email,
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'Residential Address',
                content: member.address,
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'Date of Birth',
                content: member.date_of_birth,
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'State',
                content: member.state_of_origin,
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'Nationality',
                content: member.nationality,
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'Do you want to be a Member',
                content: member.member_choice.toString(),
              ),
              const SizedBox(
                height: 28,
              ),
              HeadingContentDisplay(
                heading: 'Status',
                content: member.status,
              )
            ],
          ),
        ),
      ),
    );
  }
}
