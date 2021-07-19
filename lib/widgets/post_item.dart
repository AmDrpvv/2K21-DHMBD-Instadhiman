import 'package:Instadhiman/Services/FirestoreDB.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/utils/utilityFunc.dart';
import 'package:Instadhiman/widgets/postContent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/colors.dart';

class PostItem extends StatefulWidget {
  final User mainUser;
  final Post post;
  const PostItem({Key key, this.post, @required this.mainUser}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isLiked;

  updateLikedPost() async
  {
    if(isLiked){
      widget.post.isLoved = false;
      widget.post.likedBy.remove(widget.mainUser.instaName);
      await DatabaseService(uid: widget.post.id).removeLikedPost(widget.mainUser.userid);
    }
    else{
      widget.post.isLoved = true;
      widget.post.likedBy.add(widget.mainUser.instaName);
      await DatabaseService(uid: widget.post.id).addLikedPost(widget.mainUser.userid);
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    isLiked = widget.post.isLoved;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: storyBorderColor),
                    image: DecorationImage(image: NetworkImage(widget.post.profileImgUrl),fit: BoxFit.cover)
                  ),
                ),
                SizedBox(width: 15,),
                Text(widget.post.name,style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),)
                ],),
                Icon(Icons.more_horiz,color: white,)
              ],
            ),
          ),
          SizedBox(height: 12,),
          GestureDetector(
            onDoubleTap: updateLikedPost,
            child: Container(
              height: 350,
              child: PostContent(isVideo: widget.post.isVideo,
              postContentUrl: widget.post.imgUrl,),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 15,top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
              children: <Widget>[
                isLiked ? GestureDetector( 
                  onTap: updateLikedPost,
                  child: SvgPicture.asset("assets/images/loved_icon.svg",width: 27,))
                : GestureDetector( 
                  onTap: updateLikedPost,
                  child: SvgPicture.asset("assets/images/love_icon.svg",width: 27,)),
                SizedBox(width: 20,),
                 SvgPicture.asset("assets/images/comment_icon.svg",width: 27,),
                  SizedBox(width: 20,),
                 SvgPicture.asset("assets/images/message_icon.svg",width: 27,),
              ],
            ),
            SvgPicture.asset("assets/images/save_icon.svg",width: 27,),
              ],
            ),
          ),
          SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.only(left: 15,right: 15),
            child: RichText(text: TextSpan(
              children: [
                if(widget.post.likedBy.length > 0)
                TextSpan(
                  text: "Liked by ",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Helvetica Neue LT 45 Light',
                    fontWeight: FontWeight.w500
                  )
                )else 
                TextSpan(
                  text: "No Likes ",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Helvetica Neue LT 45 Light',
                    fontWeight: FontWeight.w500
                  )
                ),
                if(widget.post.likedBy.length > 0)
                TextSpan(
                  text: "${widget.post.likedBy[0]} ",
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue LT 45 Light',
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  )
                ),
                if(widget.post.likedBy.length > 1)
                TextSpan(
                  text: "and ",
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue LT 45 Light',
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                ),
                if(widget.post.likedBy.length > 1)
                TextSpan(
                  text: "${widget.post.likedBy.length -1} Other",
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue LT 45 Light',
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  )
                ),
                
              ]
            )),
          ),
          SizedBox(height: 12,),
          Padding(padding: EdgeInsets.only(left: 15,right: 15),
          child: RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: "${widget.post.name} ",
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue LT 45 Light',
                    fontSize: 15,
                    fontWeight: FontWeight.w700
                  )
                ),
                TextSpan(
                  text: "${widget.post.caption}",
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue LT 45 Light',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  )
                ),

              ]
            ))),
            SizedBox(height: 12,),
            Padding(padding: EdgeInsets.only(left: 15,right: 15),
            child: Text("View ${widget.post.caption.length} comments",style: TextStyle(
              color: white.withOpacity(0.5),
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),),
            ),
            SizedBox(height: 12,),
            Padding(padding: EdgeInsets.only(left: 15,right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: storyBorderColor),
                    image: DecorationImage(image: NetworkImage(widget.mainUser.profileImg),fit: BoxFit.cover)
                  ),
                ),
                SizedBox(width: 15,),
                Text("Add a comment...",style: TextStyle(
              color: white.withOpacity(0.5),
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),),
              ],
            ),
            Row(
              children: <Widget>[
                Text("😂",style: TextStyle(
                  fontSize: 
                  20
                ),),
                SizedBox(width: 10,),
                Text("😍",style: TextStyle(
                  fontSize: 
                  20
                ),),
                 SizedBox(width: 10,),
                 Icon(Icons.add_circle,color: white.withOpacity(0.5),size: 18,)
              ],
            )
              ],
            )
            ),
            SizedBox(height: 12,),
            Padding(padding: EdgeInsets.only(left: 15,right: 15),
            child:  Text(convertDateTime(widget.post.timeStamp),style: TextStyle(
              color: white.withOpacity(0.5),
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),),
            )
        ],
      ),
    );
  }
}
