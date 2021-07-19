import 'package:Instadhiman/Services/FirestoreDB.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/widgets/Loading.dart';
import 'package:Instadhiman/widgets/postContent.dart';
import 'package:flutter/material.dart';
import 'package:Instadhiman/constant/search_json.dart';
import 'package:Instadhiman/theme/colors.dart';
import 'package:Instadhiman/widgets/search_category_item.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading;
  List<Post> postImageList;

  loadPostDB() async{
    isLoading = true;
    postImageList = [];
    postImageList = await  DatabaseService().getAllPost();
    postImageList.shuffle();
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
              // child: PostContent(
              //   isVideo: isVideo,
              //   postContentUrl: imgUrl,
              // ),
            ),
            backgroundColor: textFieldBackground,
          );
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      backgroundColor: black,
        color: white,
        onRefresh: () async{
          if(isLoading) return;
          loadPostDB();
        },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
        SizedBox(height: 15,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(children: List.generate(searchCategories.length, (index){
            return CategoryStoryItem(
              name: searchCategories[index],
            );
          })),
                  ),
        ),
        SizedBox(height: 15,),
        Wrap(
          spacing: 1,
          runSpacing: 1,
          children: List.generate(postImageList.length, (index){
            return GestureDetector(
              onTap: (){
                showImageDialog(context, postImageList[index].imgUrl,
                postImageList[index].isVideo);
              },
              child: Container(
          width: (size.width-3)/3,
          height: (size.width-3)/3,
          child: PostContent(
              postContentUrl: postImageList[index].imgUrl,
              isVideo: postImageList[index].isVideo,
          ),
        ),
            );
        }),
          )
          ],
        ),
      ),
    );
  }
}


