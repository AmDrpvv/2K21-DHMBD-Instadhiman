import 'package:Instadhiman/Services/FirestoreDB.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/widgets/Loading.dart';
import 'package:Instadhiman/widgets/PostWidget.dart';
import 'package:Instadhiman/widgets/StoriesWidget.dart';
import 'package:flutter/material.dart';
import 'package:Instadhiman/theme/colors.dart';


class HomePage extends StatefulWidget {
  final String mainUserID;

  HomePage({Key key, this.mainUserID}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> allUser;
  List<Post> allPost;
  User mainUser;
  bool isLoading;


  initializeDataBase() async
  {
    setState(() { isLoading = true;});
    allPost = [];
    allUser = [];

    allUser = await DatabaseService().getAllUser(widget.mainUserID);
    allPost = await DatabaseService().getAllPost();

    mainUser = await DatabaseService(uid: widget.mainUserID).getUser();

    for (int i = 0; i < allPost.length; i++) {
      User postUser = allUser.firstWhere(
        (user) => user.userid == allPost[i].userId,
        orElse: (){ return mainUser;}
        );//await DatabaseService(uid: allPost[i].userId).getUser();
      allPost[i].name = postUser.instaName;
      allPost[i].profileImgUrl = postUser.profileImg;
      allPost[i].isLoved = allPost[i].likedBy.contains(mainUser.userid);

      for (int j = 0; j < allPost[i].likedBy.length; j++) {
        User likedByUser = allUser.firstWhere(
        (user) => user.userid == allPost[i].likedBy[j],
        orElse: (){ return mainUser;}
        ); //await DatabaseService(uid: allPost[i].likedBy[j]).getUser();
        allPost[i].likedBy[j] = likedByUser.instaName;

      }
    }

    allPost.shuffle();
    allUser.shuffle();

    setState(() { isLoading = false;});
  }

  refreshPage(){
    if(isLoading) return;
    initializeDataBase();
  }


  @override
    void initState() {
      initializeDataBase();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : getBody();
  }

  Widget getBody() {
    return RefreshIndicator(
      backgroundColor: black,
      color: white,
      onRefresh: () async{
        refreshPage();
      },
      child: SingleChildScrollView(
        physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ShowStories(mainUser: mainUser, userList: allUser,)
            ),
            Divider(
              color: white.withOpacity(0.3),
            ),
            ShowPosts(mainUser: mainUser, postList: allPost,),
          ],
        ),
      ),
    );
  }
}
