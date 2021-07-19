import 'package:Instadhiman/Services/FirestoreDB.dart';
import 'package:Instadhiman/theme/colors.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/widgets/Loading.dart';
import 'package:Instadhiman/widgets/UserInfoItem.dart';
import 'package:flutter/material.dart';

class FollowInfo extends StatefulWidget {
  final Function refreshFunc;
  final String myUserID;
  final String mainUserID;

  const FollowInfo({Key key, this.refreshFunc, this.myUserID, this.mainUserID}) : super(key: key);
 
  @override
  _FollowInfoState createState() => _FollowInfoState();
}

class _FollowInfoState extends State<FollowInfo> {

  bool isLoading;
  User myUser;
  User mainUser;
  List<User> myFollowers;
  List<User> myFollowing;

  follow(User user) async{
    print("following...");
    await DatabaseService(uid: widget.mainUserID).addUserFollowers(user.userid);
    mainUser = await DatabaseService(uid: widget.mainUserID).getUser();
    if(widget.mainUserID == widget.myUserID)
      myFollowing.add(user);

    setState(() {});
  }

  unfollow(User user) async
  {
    print("unfollowing...");
    await DatabaseService(uid: widget.mainUserID).removeUserFollowers(user.userid);
    mainUser = await DatabaseService(uid: widget.mainUserID).getUser();
    if(widget.mainUserID == widget.myUserID)
      myFollowing.remove(user);

    setState(() {});
  }

  followOrUnfollow(User user, bool isFollowing){
    if(isFollowing) unfollow(user);
    else follow(user);
  }

  initUserDB() async {
    isLoading =true;
    myFollowers = [];
    myFollowing = [];

    mainUser = await DatabaseService(uid: widget.mainUserID).getUser();
    myUser = await DatabaseService(uid: widget.myUserID).getUser();

    for (var i = 0; i < myUser.followers.length; i++) {
      User user = await DatabaseService(uid: myUser.followers[i]).getUser();
      myFollowers.add(user);
    }

    for (var i = 0; i < myUser.following.length; i++) {
      User user = await DatabaseService(uid: myUser.following[i]).getUser();
      myFollowing.add(user);
    }
    // await Future.delayed(Duration(seconds: 1));
    setState(() {isLoading = false;});
  }


  @override
    void initState() {
      initUserDB();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return isLoading ? Scaffold(backgroundColor: black, body:Loading())
    : WillPopScope(
      onWillPop: (){
        widget.refreshFunc();
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        backgroundColor: black,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SafeArea(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: size.width - 30,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: textFieldBackground),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: white.withOpacity(0.3),
                          )),
                      style: TextStyle(color: white.withOpacity(0.3)),
                      cursorColor: white.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: size.width - 30,
                  height: 30,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: textFieldBackground),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Followers")
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(myFollowers.length, (index){
                  return UserInfoItem(userInfo: myFollowers[index], func: followOrUnfollow, mainUser: mainUser,);
                }
                ),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Container(
                  width: size.width - 30,
                  height: 30,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: textFieldBackground),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("Following")
                  ),
                ),
                SizedBox(
                  width: 15,
                )
              ],
            ),
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(myFollowing.length, (index){
                  return UserInfoItem(userInfo: myFollowing[index], func: followOrUnfollow, mainUser: mainUser,);
                }
                ),
              ),
            ),
          ],
        )
        ),
      ),
    );
  }
}