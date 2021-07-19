import 'package:Instadhiman/Services/authService.dart';
import 'package:Instadhiman/pages/Register.dart';
import 'package:Instadhiman/theme/colors.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}
GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
class _SignInState extends State<SignIn> {
  TextEditingController usernameTextController;
  TextEditingController passwordTextController;
  String errorText;
  bool isLoading;

  @override
  void initState() {
    refreshPage();
    isLoading = false;
    super.initState();
  }
  
  @override
  void dispose() {
    refreshPage();
    super.dispose();
  }

  refreshPage()
  {
    usernameTextController = TextEditingController();
    passwordTextController = TextEditingController();
    errorText = "";
  }

  signIn() async
  {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if(isLoading || !_formKey.currentState.validate())
    {
       errorText = "something went wrong";
       setState(() {});
       return;
      }

    isLoading = true;
    
    var result = await AuthService().signin(usernameTextController.text,
    passwordTextController.text);

    refreshPage();
    if(result == null || result == ""){
      errorText = "oops! something went wrong";
      setState(() {});
    }
    else
    {
      errorText = "";
    }
    isLoading = false;
    print("sign in");
    
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: black,
      color: white,
      onRefresh: () async{
        refreshPage();
        isLoading = false;
        _formKey.currentState.reset();
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setState(() {});
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
          },
          child: SingleChildScrollView(
            physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height*0.3),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Instadhiman",
                          style: TextStyle(
                            fontFamily: 'Billabong',
                            fontSize: 35
                          ),),
                      ),
                      SizedBox(height: 10.0,),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: white.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(10),
                            color: textFieldBackground),
                        child: TextFormField(
                          validator: (val) {
                          if(val.length < 4 || val.length > 20 )
                           return "";
                          else return null;
                          },
                          controller: usernameTextController,
                          decoration: InputDecoration(
                            hintText: "Username",
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(height: 0),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.account_circle_outlined,
                                color: white.withOpacity(0.3),
                              )),
                          style: TextStyle(color: white),
                          cursorColor: white,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: white.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(10),
                            color: textFieldBackground),
                        child: TextFormField(
                          validator: (val) {
                          if(val.length < 6 || val.length > 20 )
                           return "";
                          else return null;
                          },
                          
                          obscureText: true,
                          controller: passwordTextController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(height: 0),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.security_rounded,
                                color: white.withOpacity(0.3),
                              )),
                          style: TextStyle(color: white),
                          cursorColor: white,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      GestureDetector(
                        onTap: signIn,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: white.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(10),
                              color: buttonFollowColor),
                          child: Text("SignIn"),
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          errorText,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                          )
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                           child: RichText(text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                              TextSpan(
                                text: "Create one",
                                style: TextStyle(
                                  color: buttonFollowColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                )
                              ),

                            ]
                          ))
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
        ),
      ),
    );
  }
}