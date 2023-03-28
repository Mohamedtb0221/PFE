import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        cursorColor: const Color.fromARGB(255, 120, 100, 156),
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder:const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 120, 100, 156)),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelText: hintText,
            labelStyle:const TextStyle(color: Color.fromARGB(255, 120, 100, 156)),
            hintText: hintText,
            hintStyle:const TextStyle(color: Colors.transparent)),
      ),
    );
  }
}