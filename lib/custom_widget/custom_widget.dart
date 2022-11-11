import 'package:bringup_app/utils/pallet.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputType,
    required this.inputAction,
    required this.controller,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        height: 60,
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            hintText: hint,
            hintStyle: kBodyText,
            filled: true,
            fillColor: Colors.transparent,
          ),
          style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
          controller: controller,
        ),
      ),
    );
  }
}

class CustomPasswordInput extends StatelessWidget {
  const CustomPasswordInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputAction,
    required this.controller,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputAction inputAction;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(
        height: 60,
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            hintText: hint,
            hintStyle: kBodyText,
            filled: true,
            fillColor: Colors.transparent,
          ),
          obscureText: true,
          style: kBodyText,
          textInputAction: inputAction,
          controller: controller,
        ),
      ),
    );
  }
}

class CustomRoundButton extends StatelessWidget {
  const CustomRoundButton({
    Key? key,
    required this.buttonText,
    required this.onpressed,
  }) : super(key: key);

  final String buttonText;
  final void Function() onpressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onpressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: kBodyText,
        ),
      ),
    );
  }
}

class HeadingContentDisplay extends StatelessWidget {
  const HeadingContentDisplay({
    Key? key,
    required this.heading,
    required this.content,
  }) : super(key: key);
  final String heading;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: kHeaderDisplayText,
        ),
        const SizedBox(
          height: 13,
        ),
        Text(
          content,
          style: kContentDisplayText,
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 1,
          thickness: 0.3,
          color: Colors.black45,
        )
      ],
    );
  }
}
