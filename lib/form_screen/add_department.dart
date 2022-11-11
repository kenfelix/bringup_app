import 'dart:convert';
import 'dart:io';

import 'package:bringup_app/custom_widget/dropdown-search-select.dart';
import 'package:bringup_app/utils/func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../utils/urls.dart';

class DepartmentFormScreen extends StatefulWidget {
  const DepartmentFormScreen({super.key});

  @override
  State<DepartmentFormScreen> createState() => _DepartmentFormScreenState();
}

class _DepartmentFormScreenState extends State<DepartmentFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _storage = const FlutterSecureStorage();

  bool _departmentHasError = false;
  bool _statusHasError = false;

  var departmentOptions = [
    'Bring Up',
    'Electricals',
    'Executive Managers',
    'Finance',
    'Pastorate',
    'Santuary',
    'Security/protocol',
    'Sound Circle',
    'Techno Media',
    'Tlemi Theatre',
  ];

  var statusOptions = ['HOD', 'Secretary', 'Member'];

  _addToDepartment(
    int pk,
    String name,
    String status,
  ) async {
    String? access = await _storage.read(key: 'access');
    final response = await client.post(
      departmentlist,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $access'
      },
      body: jsonEncode(<String, dynamic>{
        'member': pk,
        'name': name,
        'status': status,
      }),
    );
    switch (response.statusCode) {
      case 201:
        // ignore: use_build_context_synchronously
        showResponseDialog(context, 'Member Added');
        return response.body;
      case 200:
        // ignore: use_build_context_synchronously
        showResponseDialog(context, 'Member Added');
        return response.body;
      default:
        throw response.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Member to Department')),
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
                    const Text('Select member(s)'),
                    const DropdownSearchSelect(),
                    FormBuilderDropdown<String>(
                      name: 'department',
                      decoration: InputDecoration(
                        labelText: 'Department',
                        suffixIcon: _departmentHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      allowClear: true,
                      hint: const Text('Select Departmemt'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: departmentOptions
                          .map((department) => DropdownMenuItem(
                                value: department,
                                alignment: AlignmentDirectional.center,
                                child: Text(department),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _departmentHasError = !(_formKey
                                  .currentState?.fields['department']
                                  ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (value) => value?.toString(),
                    ),
                    FormBuilderDropdown<String>(
                      name: 'status',
                      decoration: InputDecoration(
                        labelText: 'Status',
                        suffixIcon: _statusHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      allowClear: true,
                      hint: const Text('Position in Department'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: statusOptions
                          .map((status) => DropdownMenuItem(
                                value: status,
                                alignment: AlignmentDirectional.center,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _departmentHasError = !(_formKey
                                  .currentState?.fields['status']
                                  ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (value) => value?.toString(),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var data = _formKey.currentState!.value;
                        String name = data['department'].toString();
                        String status = data['status'].toString();
                        var datalist = myKey.currentState!.getSelectedItems;
                        for (var element in datalist) {
                          _addToDepartment(element.pk, name, status);
                        }
                      },
                      child: const Text('Add'),
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
