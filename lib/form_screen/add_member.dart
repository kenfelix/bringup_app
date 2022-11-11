// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:convert';
import 'dart:io';

import 'package:bringup_app/utils/func.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../utils/urls.dart';

class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({super.key});

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _storage = const FlutterSecureStorage();

  bool _firstNameHasError = false;
  bool _lastNameHasError = false;
  bool _phoneNumberHasError = false;
  bool _sexHasError = false;
  bool _emailError = false;
  bool _addressError = false;
  bool _statusHasError = false;

  var sexOptions = ['Male', 'Female'];
  var statusOptions = ['First Timer', 'Member'];
  String city = '';
  String state = '';
  String country = '';

  void _onChanged(dynamic value) => value.toString();

  _addMember(
    String firstName,
    String lastName,
    String phoneNumber,
    String sex,
    String email,
    String address,
    String dateOfBirth,
    String stateOfOrigin,
    String nationality,
    String memberChoice,
    String status,
  ) async {
    String? access = await _storage.read(key: 'access');
    final response = await client.post(
      memberAdd,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $access'
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'sex': sex,
        'email': email,
        'address': address,
        'date_of_birth': dateOfBirth,
        'state_of_origin': stateOfOrigin,
        'nationality': nationality,
        'member_choice': memberChoice,
        'status': status,
      }),
    );
    switch (response.statusCode) {
      case 201:
        showResponseDialog(context, 'Member Added');
        return response.body;
      case 200:
        showResponseDialog(context, 'Member Added');
        return response.body;
      default:
        throw response.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Member')),
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
                    FormBuilderTextField(
                      name: 'firstName',
                      decoration: InputDecoration(
                        labelText: 'First name',
                        suffixIcon: _firstNameHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _firstNameHasError = !(_formKey
                                  .currentState?.fields['firstName']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(70),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      name: 'lastName',
                      decoration: InputDecoration(
                        labelText: 'Last name',
                        suffixIcon: _lastNameHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _lastNameHasError = !(_formKey
                                  .currentState?.fields['lastName']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(70),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderPhoneField(
                      name: 'phoneNumber',
                      initialValue: '',
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '',
                      ),
                      priorityListByIsoCode: const ['NG'],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.numeric(),
                      ]),
                      onChanged: (value) {
                        setState(() {
                          _phoneNumberHasError = !(_formKey
                                  .currentState?.fields['phoneNumber']
                                  ?.validate() ??
                              false);
                        });
                      },
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDropdown<String>(
                      name: 'sex',
                      decoration: InputDecoration(
                        labelText: 'Sex',
                        suffixIcon: _sexHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      allowClear: true,
                      hint: const Text('Select Sex'),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: sexOptions
                          .map((sex) => DropdownMenuItem(
                                value: sex,
                                alignment: AlignmentDirectional.center,
                                child: Text(sex),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _sexHasError = !(_formKey.currentState?.fields['sex']
                                  ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (value) => value?.toString(),
                    ),
                    FormBuilderTextField(
                      name: 'email',
                      initialValue: 'none@tlemi.com',
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        suffixIcon: _emailError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _emailError = !(_formKey.currentState?.fields['email']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.max(100),
                        FormBuilderValidators.email(),
                        FormBuilderValidators.required(),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderTextField(
                      name: 'address',
                      decoration: InputDecoration(
                        labelText: 'House Address',
                        suffixIcon: _addressError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _addressError = !(_formKey
                                  .currentState?.fields['address']
                                  ?.validate() ??
                              false);
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.max(100),
                      ]),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDateTimePicker(
                      name: 'date_of_birth',
                      inputType: InputType.date,
                      initialValue: DateTime.now(),
                      firstDate: DateTime(1970),
                      format: DateFormat('yyyy-MM-dd'),
                      onChanged: _onChanged,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        helperText: 'dd-MM-yyyy',
                        hintText: 'dd-MM-yyyy',
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey.currentState!.fields['date_of_birth']
                                  ?.didChange('0000-00-00');
                            }),
                      ),
                    ),
                    CSCPicker(
                      showStates: true,
                      showCities: true,
                      flagState: CountryFlag.ENABLE,
                      dropdownDecoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.shade100,
                        border:
                            Border.all(color: Colors.grey.shade100, width: 1),
                      ),
                      countrySearchPlaceholder: 'Country',
                      stateSearchPlaceholder: 'State',
                      citySearchPlaceholder: 'City',
                      countryDropdownLabel: '*Country',
                      stateDropdownLabel: '*State',
                      cityDropdownLabel: '*City',
                      defaultCountry: DefaultCountry.Nigeria,
                      onCityChanged: (value) {
                        setState(() {
                          city = value.toString();
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          state = value.toString();
                        });
                      },
                      onCountryChanged: (value) {
                        setState(() {
                          country = value.toString();
                        });
                      },
                    ),
                    FormBuilderSwitch(
                      name: 'do_you_want_to_be_a_member',
                      title: const Text('Would you like to be a Member?'),
                      initialValue: true,
                      onChanged: _onChanged,
                    ),
                    FormBuilderDropdown<String>(
                      name: 'status',
                      initialValue: 'First Timer',
                      decoration: InputDecoration(
                        labelText: 'Status',
                        suffixIcon: _statusHasError
                            ? const Icon(Icons.error, color: Colors.red)
                            : const Icon(Icons.check, color: Colors.green),
                      ),
                      allowClear: true,
                      hint:
                          const Text('Select member current membership status'),
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
                          _statusHasError = !(_formKey
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
                        String firstName = data['firstName'].toString();
                        String lastName = data['lastName'].toString();
                        String phoneNumber = data['phoneNumber'].toString();
                        String sex = data['sex'].toString();
                        String email = data['email'].toString();
                        String address = data['address'].toString();
                        String dateOfBirth =
                            data['date_of_birth'].toString().substring(0, 10);
                        String stateOfOrigin = '$city $state';
                        String nationality = country;
                        String memberChoice =
                            data['do_you_want_to_be_a_member'].toString();
                        String status = data['status'].toString();

                        try {
                          await _addMember(
                            firstName,
                            lastName,
                            phoneNumber,
                            sex,
                            email,
                            address,
                            dateOfBirth,
                            stateOfOrigin,
                            nationality,
                            memberChoice,
                            status,
                          );
                        } catch (e) {
                          if (e == 400) {
                            showResponseDialog(context,
                                'Member with this Phone Number already exist');
                          }
                          if (e == 403) {
                            showResponseDialog(context,
                                'Session Over/Dont have permission to view this this Tab.\n Login again or Check other Tab');
                          }
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
