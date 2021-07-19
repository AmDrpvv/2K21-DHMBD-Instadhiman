import 'package:Instadhiman/theme/colors.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.width,
      color: black,
      child: Center(
        child: Text(
          "Instadhiman",
          style: TextStyle(
            fontFamily: "Billabong",
            fontSize: 24,
            color: white
            ),
        ),
      ),
    );
  }
}