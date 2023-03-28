import 'package:flutter/material.dart';

class Sidemenu extends StatelessWidget {
  const Sidemenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        child: ListTileTheme(
              horizontalTitleGap: 0,
              
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  ListTile(
                    onTap: () {},
                    leading:const Icon(Icons.home),
                    title:const Text('Home'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading:const Icon(Icons.account_circle_rounded),
                    title:const Text('Profile'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading:const Icon(Icons.favorite),
                    title:const Text('Favourites'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading:const Icon(Icons.settings),
                    title:const Text('Settings'),
                  ),
                  
                  
                ],
              ),
            ),
      );
  }
}