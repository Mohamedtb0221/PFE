import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/components/my_formtextfield.dart';
import 'package:testing/pages/login.dart';

class PasswordTextfield extends StatefulWidget {
  const PasswordTextfield({super.key});

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
                  duration:const Duration(milliseconds: 500),
                  delay:const Duration(milliseconds: 1000),
                  child: MyTextFormField(
                    lines: 1,
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: visiblePass,
                    icon:const Icon(
                      Iconsax.key,
                      color: Color.fromARGB(255, 120, 100, 156),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            visiblePass = !visiblePass;
                            print(visiblePass);
                          });
                        },
                        icon: visiblePass
                            ? const Icon(
                                Icons.visibility,
                                color: Color.fromARGB(255, 120, 100, 156),
                              )
                            : const Icon(Icons.visibility_off,
                                color: Color.fromARGB(255, 120, 100, 156))),
                  ),
                );
  }
}