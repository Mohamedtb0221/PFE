
import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path>{
  Path getClip(Size size){
    Path path = Path();
    path.lineTo(0,size.height/2);
    path.quadraticBezierTo(size.width /2, size.height, size.width, size.height/2);
    path.lineTo(size.width,0);
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}