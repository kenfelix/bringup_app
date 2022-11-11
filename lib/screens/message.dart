// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bringup_app/custom_widget/dropdown-search-select.dart';
import 'package:bringup_app/utils/func.dart';
import 'package:bringup_app/utils/pallet.dart';
import 'package:bringup_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _bodyHasError = false;

  _sendMessage(String body, String phoneNumber) async {
    final response = await client.get(
      messageUrl(body, phoneNumber),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
    switch (response.statusCode) {
      case 200:
        showResponseDialog(context, 'Member Updated');
        return response.body;
      case 201:
        showResponseDialog(context, 'Member Updated');
        return response.body;

      default:
        throw response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
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
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: FormBuilderTextField(
                        name: 'body',
                        decoration: InputDecoration(
                          labelText: 'Message Body',
                          labelStyle: kBodynameText,
                          alignLabelWithHint: true,
                          suffixIcon: _bodyHasError
                              ? const Icon(Icons.error, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _bodyHasError = !(_formKey
                                    .currentState?.fields['body']
                                    ?.validate() ??
                                false);
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLines: 5,
                      ),
                    ),
                    const DropdownSearchSelect(),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var data = _formKey.currentState!.value;
                        String body = data['body'].toString();
                        var datalist = myKey.currentState!.getSelectedItems;
                        for (var element in datalist) {
                          _sendMessage(body, element.phone_number);
                        }
                      },
                      child: const Text('Send'),
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
