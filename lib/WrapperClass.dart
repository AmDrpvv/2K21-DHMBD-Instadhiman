import 'package:Instadhiman/Services/authService.dart';
import 'package:Instadhiman/pages/SignIn.dart';
import 'package:Instadhiman/pages/root_app.dart';
import 'package:Instadhiman/widgets/Loading.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

     return StreamBuilder<String>(
       stream: AuthService().userStream,
       builder: (context, snapshot) {
         if(!snapshot.hasData) return Loading();
         else{
          if(snapshot.data != null && snapshot.data != "") 
            return RootApp(mainUserID: snapshot.data,);
          else
            return SignIn();
         }
       }
     );
  }

  // @override
  // Widget build(BuildContext context) {

  //   print(data);
  //   if(data != null && data != "") return RootApp(mainUserID: data,);
  //   else return SignIn();
  // }
}