import 'package:flutter/material.dart';

///it's not that custom but still :(
class CustomTextFeild extends StatelessWidget {
  const CustomTextFeild({
    Key? key,
    required this.controller,
    required this.validator,
    this.hintText = '',
    this.obscureText = false,
    this.suffixWidget,
    this.prefixIcon,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final Widget? suffixWidget;
  final Icon? prefixIcon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          suffix: suffixWidget,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
