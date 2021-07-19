import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/widgets/post_item.dart';
import 'package:flutter/material.dart';

class ShowPosts extends StatelessWidget {
  final User mainUser;
  final List<Post> postList;

  ShowPosts({Key key, @required this.mainUser, this.postList}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(postList.length, (index) {
        return PostItem(
          mainUser: mainUser,
          post: postList[index],
        );
      }),
    );
  }
}


// class ShowPostList extends StatefulWidget {
//   final String mainUserID;
//   final List<Post> postList;

//   const ShowPostList({Key key, this.postList, this.mainUserID}) : super(key: key);

//   @override
//   _ShowPostListState createState() => _ShowPostListState();
// }

// class _ShowPostListState extends State<ShowPostList> {
//   List<Post> shufflePostList;
//   @override
//     void initState() {
//       shufflePostList = shuffle(widget.postList);
//       // TODO: implement initState
//       super.initState();
//     }

//   refreshPage(){
//     shufflePostList = shuffle(widget.postList);
//     setState(() {});
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(shufflePostList.length, (index) {
//         return PostItem(
//           mainUserID: widget.mainUserID,
//           post: shufflePostList[index],
//         );
//       }),
//     );
//   }
// }