import 'package:Instadhiman/theme/colors.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:flutter/material.dart';

class UserInfoItem extends StatelessWidget {
  final User userInfo;
  final User mainUser;
  final Function func;
  const UserInfoItem({Key key, this.userInfo, this.func, this.mainUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isFollowing = mainUser.following.contains(userInfo.userid);
    return ListTile(
      tileColor: black,
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: storyBorderColor),
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: white),
          image: DecorationImage(
            image: NetworkImage(userInfo.profileImg),
            fit: BoxFit.cover
          )
        ),
      ),
      title: Text(userInfo.username),
      subtitle: Text(userInfo.instaName),
      trailing: GestureDetector(
        onTap: (){
          func(userInfo, isFollowing);
        },
        child: Container(
          height: 28,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: white),
            borderRadius: BorderRadius.circular(5),
            color: isFollowing ? textFieldBackground : buttonFollowColor,
          ),
          child: Center(
            child: Text(
              isFollowing ? "Unfollow": "Follow",
              style: TextStyle(
              color: white,fontWeight: FontWeight.w600),),
          ),
        ),
      ),
    );
  }
}