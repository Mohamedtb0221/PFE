import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testing/components/my_formtextfield.dart';
import 'package:testing/pages/login.dart';

class UsernameTextfield extends StatelessWidget {
  const UsernameTextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
                  duration:const Duration(milliseconds: 400),
                  delay:const Duration(milliseconds: 1000),
                  child: MyTextFormField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                    icon:const Icon(
                      Iconsax.user,
                      color: Color.fromARGB(255, 120, 100, 156),
                    ),
                  ),
                );
  }
}