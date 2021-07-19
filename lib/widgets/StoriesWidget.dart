import 'package:Instadhiman/theme/colors.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/widgets/story_item.dart';
import 'package:flutter/material.dart';

class ShowStories extends StatelessWidget {
  final User mainUser;
  final List<User> userList;
  const ShowStories({Key key, this.mainUser, this.userList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(right: 20, left: 15, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                width: 65,
                height: 65,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 65,
                      height: 65,
                      
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: storyBorderColor),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(mainUser.profileImg),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 19,
                          height: 19,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: white),
                          child: Icon(
                            Icons.add_circle,
                            color: buttonFollowColor,
                            size: 19,
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 70,
                child: Text(
                  "Your Story",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: white),
                ),
              )
            ],
          ),
        ),
        Row(
            children: List.generate(userList.length, (index) {
          return StoryItem(
            mainUserID: mainUser.userid,
            user: userList[index],
          );
        })),
      ],
    );

  }
}
