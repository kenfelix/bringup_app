import 'package:bringup_app/models/jwt.dart';
import 'package:http/http.dart' as http;
import 'package:bringup_app/utils/urls.dart';
import 'dart:convert';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

http.Client client = http.Client();

Future<Token> getJwtToken(String username, String password) async {
  final response = await client.post(
    loginUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    return Token.fromMap(jsonDecode(response.body));
  } else {
    throw Exception('Invalid username or password');
  }
}

void showResponseDialog(context, String val) {
  Alert(context: context, desc: val).show();
}

Future<void> launchAdmin(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    }),
  )) {
    throw 'Could not launch $url';
  }
}
