import 'package:Instadhiman/Services/FirestoreDB.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/widgets/Loading.dart';
import 'package:Instadhiman/widgets/postContent.dart';
import 'package:flutter/material.dart';
import 'package:Instadhiman/theme/colors.dart';

class FavoritePostPage extends StatefulWidget {
  final String myUserID;

  const FavoritePostPage({Key key, this.myUserID}) : super(key: key);
  @override
  _FavoritePostPageState createState() => _FavoritePostPageState();
}

class _FavoritePostPageState extends State<FavoritePostPage> {
  bool isLoading;
  // List<String> postImageList;
  List<Post> postList;

  loadPostDB() async{
    isLoading = true;
    postList = [];
    // postImageList = [];
    List<Post> allPostList = await  DatabaseService().getAllPost();
    
    for (var i = 0; i < allPostList.length; i++) {
      if(allPostList[i].likedBy.contains(widget.myUserID))
        postList.add(allPostList[i]);
    }

    postList.shuffle();
    setState(() {isLoading =false;});
  }
  @override
    void initState() {
      loadPostDB();
      super.initState();
    }

  showImageDialog(BuildContext contxt, String imgUrl, bool isVideo)
  {
    showDialog(
      context: contxt,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(7.0)
            )
          ),
          child:  Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(7.0)
                ),
                border: Border.all(width: 1, color: white),
                image: isVideo ? null : DecorationImage(
                  image: NetworkImage(imgUrl),fit: BoxFit.contain)
              ),
            ),
            backgroundColor: textFieldBackground,
          );
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : RefreshIndicator(
      backgroundColor: black,
      color: white,
      onRefresh: () async{
        if(isLoading) return;
        loadPostDB();
      },
      child: getBody()
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
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
      SizedBox(height: 25,),
      Wrap(
        spacing: 1,
        runSpacing: 1,
        children: List.generate(postList.length, (index){
          return GestureDetector(
            onTap: (){
              showImageDialog(context, 
              postList[index].imgUrl, postList[index].isVideo);
            },
            child: Container(
        width: (size.width-3)/3,
        height: (size.width-3)/3,
        child: PostContent(
            isVideo: postList[index].isVideo,
            postContentUrl: postList[index].imgUrl,
        ),
      ),
          );
      }),
        )
        ],
      ),
    );
  }
}
