import 'package:bringup_app/utils/func.dart';
import 'package:bringup_app/utils/pallet.dart';
import 'package:bringup_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 150,
                        child: Center(
                          child: Text(
                            'TlemiBringUp',
                            style: kHeading,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      CustomTextInput(
                        icon: FontAwesomeIcons.solidUser,
                        hint: 'Username',
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.name,
                        controller: usernameController,
                      ),
                      CustomPasswordInput(
                        icon: FontAwesomeIcons.lock,
                        hint: 'Password',
                        inputAction: TextInputAction.next,
                        controller: passwordController,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: Text(
                          'Forgot Password?',
                          style: kBodyText,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      CustomRoundButton(
                        buttonText: 'Login',
                        onpressed: () async {
                          try {
                            var jwt = await getJwtToken(usernameController.text,
                                passwordController.text);

                            await _storage.write(
                              key: 'access',
                              value: jwt.access,
                              iOptions: const IOSOptions(),
                              aOptions: const AndroidOptions(),
                            );
                            await _storage.write(
                              key: 'refresh',
                              value: jwt.refresh,
                              iOptions: const IOSOptions(),
                              aOptions: const AndroidOptions(),
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/home',
                              ModalRoute.withName('/home'),
                            );
                          } catch (e) {
                            showResponseDialog(
                                context, 'Invalid username or password');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
