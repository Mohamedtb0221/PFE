import 'package:flutter/material.dart';


class MyTextFormField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final icon;
  final suffixIcon;
  final lines;

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.icon,
    this.suffixIcon,
    this.lines
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      
      child: SizedBox(
        width: 300,
        child: TextFormField(
          
          validator: (value) {
            if (value!.isEmpty) {
              return "please fill the blank";
            }
          },
          
          controller: controller,
          cursorColor: const Color.fromARGB(255, 120, 100, 156),
          obscureText: obscureText,
          maxLines: lines,
          decoration: InputDecoration(
            
            suffixIcon: suffixIcon,
              focusedErrorBorder:  const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Color.fromARGB(255, 120, 100, 156),width: 2),
          ),
              errorBorder: const OutlineInputBorder(              
                borderSide: BorderSide(color: Color.fromARGB(255, 120, 100, 156),width: 2),
              ),
              errorStyle:const TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 120, 100, 156)
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder:const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: Color.fromARGB(255, 120, 100, 156)),
              ),
              prefixIcon: icon,
              fillColor: Colors.grey.shade200,
              filled: true,
              labelText: hintText,
              labelStyle:const TextStyle(color: Color.fromARGB(255, 120, 100, 156),fontSize: 15),
              hintText: hintText,
              hintStyle:const TextStyle(color: Colors.transparent)),
              
        ),
      ),
    );
  }
}