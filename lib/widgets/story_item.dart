import 'package:Instadhiman/pages/AccountPage.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:flutter/material.dart';
import 'package:Instadhiman/theme/colors.dart';

class StoryItem extends StatelessWidget {
  final User user;
  final String mainUserID;
  const StoryItem({Key key, this.user, this.mainUserID,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 10),
      child: GestureDetector(
        onTap: ()
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => AccountPage(
              mainUserID: mainUserID,
              accountUser: user,
            )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: storyBorderColor)),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                      border: Border.all(color: black, width: 2),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                            user.profileImg,
                          ),
                          fit: BoxFit.cover)),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: 70,
              child: Text(
                user.instaName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: white,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
