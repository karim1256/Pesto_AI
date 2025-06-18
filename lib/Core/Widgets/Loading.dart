import 'package:flutter/material.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';

Widget Loading({Color? color}) {
  return Center(
    child: CircularProgressIndicator(
      color: color ?? MainColor,
      strokeWidth: 5.0,
    ),
  );
}
