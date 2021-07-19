import 'package:Instadhiman/WrapperClass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:Instadhiman/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,// transparent status bar
    systemNavigationBarColor: appFooterColor
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_){
          runApp(MyApp());
      }
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Helvetica Neue LT 45 Light',
        brightness: Brightness.dark,
        accentColor: white,
        primaryColor: black
      ),
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
  );
  }
}

// class Demo extends StatefulWidget {
//   @override
//   _DemoState createState() => _DemoState();
// }

// class _DemoState extends State<Demo> {

//   initDB() async{
//     isLoading = true;
//     for (var i = 0; i < searchImages.length; i++) {
//       var mapUser = <String, dynamic>{};
//       User user = User.fromMap(mapUser);
//       user.profileImg = searchImages[i];
//       user.username = "user $i";
//       user.userid = await DatabaseService().createnewUserID();
//       await DatabaseService(uid: user.userid).createNewUser(user);


//       var mapPost = <String, dynamic>{};
//       Post post = Post.fromMap(mapPost);
//       post.imgUrl = searchImages[i];
//       post.name = "Post $i";
//       post.profileImgUrl = searchImages[i];
//       post.timeStamp = DateTime.now();
//       post.id = await DatabaseService().createNewPostID();
//       await DatabaseService(uid: post.id).createNewPost(post);
//     }

//     setState(() {isLoading = false;});
//   }

//   List<String> numberList;
//   List<String> shuffleNumberList;

//   bool isLoading = false;
//   @override
//     void initState() {
//       numberList = ["1", "2" , "3" , "4" , "5" , "6" , "7" , "8" ,"9" , "10"];
//       shuffleNumberList = [];
//       // initDB();
//       super.initState();
//     }
//   @override
//   Widget build(BuildContext context) {
  
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           TextButton(
//             child: Text("Click"),
//             onPressed: ()
//             {
//               numberList.shuffle();
//               setState(() {});
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: Container(
//           child: isLoading ? Text("Loading...") : Text(numberList.join("-")),
//         ),
//       ),
//     );
//   }
// }

