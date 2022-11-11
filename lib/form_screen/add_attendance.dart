import 'dart:convert';
import 'dart:io';

import 'package:bringup_app/custom_widget/dropdown-search-select.dart';
import 'package:bringup_app/utils/func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../utils/urls.dart';

class AttendanceFormScreen extends StatefulWidget {
  const AttendanceFormScreen({super.key});

  @override
  State<AttendanceFormScreen> createState() => _AttendanceFormScreenState();
}

class _AttendanceFormScreenState extends State<AttendanceFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _storage = const FlutterSecureStorage();

  bool _titleHasError = false;

  void _onChanged(dynamic value) => value.toString();

  var ServiceTitleOptions = [
    'Celebrations of Grace',
    'Leaders Meeting',
    'MMOV Meeting',
    'Prayer Power',
    'WOG Meeting',
    'Word Power',
  ];

  _addToAttendance(
    String title,
    String date,
    int member,
  ) async {
    String? access = await _storage.read(key: 'access');
    final response = await client.post(
      attendancelist,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $access'
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'date': date,
        'member': member,
      }),
    );
    switch (response.statusCode) {
      case 201:
        // ignore: use_build_context_synchronously
        showResponseDialog(context, 'Attendance Created');
        break;
      case 200:
        // ignore: use_build_context_synchronously
        showResponseDialog(context, 'Attendance Created');
        break;
      default:
        throw response.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Attendance')),
      body: Padding(
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
                },
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15.0),
                    FormBuilderDropdown<String>(
                      name: 'title',
                      decoration: InputDecoration(
                        labelText: 'Service Title',
                        suffixIcon: _titleHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      allowClear: true,
                      hint: const Text('Select Service Title'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items:
                          ServiceTitleOptions.map((title) => DropdownMenuItem(
                                value: title,
                                alignment: AlignmentDirectional.center,
                                child: Text(title),
                              )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _titleHasError = !(_formKey
                                  .currentState?.fields['title']
                                  ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (value) => value?.toString(),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      inputType: InputType.date,
                      initialValue: DateTime.now(),
                      firstDate: DateTime(1970),
                      format: DateFormat('yyyy-MM-dd'),
                      onChanged: _onChanged,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        helperText: 'dd-MM-yyyy',
                        hintText: 'dd-MM-yyyy',
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey.currentState!.fields['date']
                                  ?.didChange('0000-00-00');
                            }),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                      height: 20,
                    ),
                    const Text('Select member(s)'),
                    const DropdownSearchSelect(),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var data = _formKey.currentState!.value;
                        String title = data['title'].toString();
                        String date = data['date'].toString().substring(0, 10);
                        var datalist = myKey.currentState!.getSelectedItems;
                        for (var element in datalist) {
                          _addToAttendance(title, date, element.pk);
                        }
                      },
                      child: const Text('Create'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
