import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final Widget? text;

  const MyButton({super.key, required this.onTap,required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color:const Color.fromARGB(255,120,100,156),
          
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: text,
        ),
      ),
    );
  }
}