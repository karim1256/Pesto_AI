import 'package:flutter/material.dart';

   double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
   double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
   double appbarHeight = AppBar().preferredSize.height;
    double state(BuildContext context) => MediaQuery.of(context).padding.top;

    double bodyHeight(BuildContext context) => screenHeight(context) - appbarHeight - state(context);