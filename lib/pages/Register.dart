import 'package:flutter/material.dart';
import 'package:Instadhiman/Services/authService.dart';
import 'package:Instadhiman/theme/colors.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}
GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 
class _RegisterState extends State<Register> {
  TextEditingController usernameTextController;
  TextEditingController passwordTextController;
  TextEditingController confirmpassTextController;
  TextEditingController passwKeyTextController;
  TextEditingController instaNameTextController;
  TextEditingController aboutTextController;
  String errorText;
  bool isLoading;

  @override
  void initState() {
    isLoading =false;
    refreshPage();
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
    confirmpassTextController = TextEditingController();
    passwKeyTextController = TextEditingController();
    instaNameTextController = TextEditingController();
    aboutTextController = TextEditingController();
    errorText = "";
    
  }

  register() async
  {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    
    if(isLoading || !_formKey.currentState.validate()
    ) {
       errorText = "something went wrong";
       setState(() {});
       return;
      }

    
    isLoading = true;
    var result = await AuthService().register(
    email: usernameTextController.text,
    password: passwordTextController.text,
    about: aboutTextController.text,
    instaName : instaNameTextController.text,
    );
    refreshPage();
    if(result == null || result == ""){
      errorText = "oops! something went wrong";
      setState(() {});
    }
    else
    {
      errorText = "";
      Navigator.pop(context);
    }
    isLoading = false;
    print("register in");  

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
                      SizedBox(height: MediaQuery.of(context).size.height*0.1),
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
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(height: 0),
                            hintText: "Username",
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
                          // maxLength: 20,
                          obscureText: true,
                          controller: passwordTextController,
                          
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(height: 0),
                            hintText: "Password",
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
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: white.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(10),
                            color: textFieldBackground),
                        child: TextFormField(
                          validator: (val) {
                          if(confirmpassTextController.text != passwordTextController.text )
                           return "";
                          else return null;
                          },
                          // maxLength: 12,
                          obscureText: true,
                          controller: confirmpassTextController,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(height: 0),
                            hintText: "Confirm Password",
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
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: white.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(10),
                            color: textFieldBackground),
                        child: TextFormField(
                          validator: (val) {
                          if(val.length < 1 || val.length > 20 )
                           return "";
                          else return null;
                          },
                          // maxLength: 20,
                          controller: instaNameTextController,
                          decoration: InputDecoration(
                            hintText: "Intadhiman Name",
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
                          if(val.length < 1 || val.length > 50 )
                           return "";
                          else return null;
                          },
                          maxLines: null,
                          controller: aboutTextController,
                          decoration: InputDecoration(
                            hintText: "About",
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(height: 0),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.edit,
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
                          if(val != "dhiman" )
                           return "";
                          else return null;
                          },
                          // maxLength: 20,
                          controller: passwKeyTextController,
                          decoration: InputDecoration(
                            hintText: "Pass Key",
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
                        onTap: register,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: white.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(10),
                              color: buttonFollowColor),
                          child: Text("Register"),
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
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                           child: RichText(text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                              TextSpan(
                                text: "Sign In",
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