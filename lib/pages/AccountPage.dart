import 'dart:io';

import 'package:Instadhiman/Services/FirestoreDB.dart';
import 'package:Instadhiman/Services/Storage.dart';
import 'package:Instadhiman/Services/authService.dart';
import 'package:Instadhiman/pages/FollowInfo.dart';
import 'package:Instadhiman/theme/colors.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/utils/utilityFunc.dart';
import 'package:Instadhiman/widgets/Loading.dart';
import 'package:Instadhiman/widgets/postContent.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final String mainUserID;
  final User accountUser;

  const AccountPage({Key key, @required this.mainUserID, this.accountUser}) : super(key: key);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int selectedIndex = 0;
  bool isFollowing;
  bool isLoading;
  User myUser;
  User mainUser;
  List<Post> myPosts;
  TextEditingController nameTextController;
  TextEditingController aboutTextController;

  loadUserDB() async {
    myPosts = [];
    isLoading = true;
    

    mainUser = await DatabaseService(uid: widget.mainUserID).getUser();
    if(widget.accountUser != null){
      myUser = await DatabaseService(uid: widget.accountUser.userid).getUser();
    }
    else
    {
      myUser = mainUser;
    }
    // print(myUser.posts.join("---"));
    for (var i = 0; i < myUser.posts.length; i++) {
      Post post = await DatabaseService(uid: myUser.posts[i]).getPost();
      myPosts.add(post);
    }

    isFollowing = mainUser.following.contains(myUser.userid);
    // await Future.delayed(Duration(seconds: 1));
    setState(() {isLoading = false;});
  }

  getFollowersInfo(){
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) => FollowInfo(
        refreshFunc: refreshPage,
        myUserID: myUser.userid,
        mainUserID: mainUser.userid,
      )
    ));
  }

  refreshPage(){
    if(isLoading) return;
    loadUserDB();
  }

  deletePost(String postID) async{
    if(isLoading) return;
    await DatabaseService(uid : widget.mainUserID).deletePost(postID);
    isLoading = false;
    Navigator.pop(context);
    refreshPage();
  }

  updateProfileDB() async{
    if(isLoading || nameTextController.text.length < 2 && aboutTextController.text.length < 2) return;

    isLoading = true;

    if(nameTextController.text.length   >= 2)
    await DatabaseService(uid: widget.mainUserID).updateUser(
      {
        userInstaName : nameTextController.text
      }
    );
    if(aboutTextController.text.length   >= 2)
    await DatabaseService(uid: widget.mainUserID).updateUser(
      {
        userAbout : aboutTextController.text
      }
    );

    isLoading = false;
    nameTextController.clear();
    aboutTextController.clear();
    Navigator.pop(context);
    refreshPage();
  }
  editUserProfile(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: textFieldBackground,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.0,),
              TextField(
                controller: nameTextController,
                decoration: InputDecoration(
                  hintText: "Instagram Name",
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.account_circle_outlined,
                      color: white.withOpacity(0.3),
                    )),
                style: TextStyle(color: white),
                cursorColor: white,
              ),
              TextField(
                controller: aboutTextController,
                maxLines: null,
                  decoration: InputDecoration(
                    hintText: "About",
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.edit_rounded,
                        color: white.withOpacity(0.3),
                      )),
                  style: TextStyle(color: white),
                  cursorColor: white,
                ),
                GestureDetector(
                  onTap: updateProfileDB,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: white.withOpacity(0.3), width: 2)
                    ),
                    child: Text("Save Changes"),
                      
                  ),
                )
            ],
          ),
        );
      }
    );
  }

  updateUserImageDB(bool isCamera, [bool isRemove = false])async{
    if(isLoading) return;

    if(isRemove)
    {
      await DatabaseService(uid: widget.mainUserID).updateUser({
        userProfileImg : defaultImgUrl
      });
      Navigator.pop(context);
      refreshPage();
      return;
    }
    File imageFile = await getImageFromDevice(isCamera);
    Navigator.pop(context);

    if(imageFile != null){
      setState(() {isLoading = true;});
      String url = await FireStorageService(file: imageFile, fileName: widget.mainUserID).uploadFile();
      if(url != null)
        await DatabaseService(uid: widget.mainUserID).updateUser({
          userProfileImg : url
        });
      imageFile.delete(recursive: true);
      imageCache.clear();
      isLoading = false;
      refreshPage();
    }
  }

  editUserImage(){
    showModalBottomSheet(
    context: context,
    backgroundColor: textFieldBackground,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => updateUserImageDB(true),
            title: Text("Camera"),
            leading: Icon(Icons.camera),
          ),
          ListTile(
            onTap: () => updateUserImageDB(false),
            title: Text("Gallery"),
            leading: Icon(Icons.photo_library_outlined),
          ),
          ListTile(
            onTap: () => updateUserImageDB(false, true),
            title: Text("Remove Photo"),
            leading: Icon(Icons.remove_circle_outline),
          ),
        ],
      );
    }
    );
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
    void initState() {
      loadUserDB();
      aboutTextController = TextEditingController();
      nameTextController = TextEditingController();

      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return isLoading ? Scaffold(backgroundColor: black,
      body: Loading(),)
    : RefreshIndicator(
      backgroundColor: Colors.black,
      color: white,
      onRefresh: () async{
        refreshPage();
      },
      child: Scaffold(
        backgroundColor: black,
        appBar: getAppBar(),
        body: getBody(size),
      ),
    );
  }


  Widget getAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(55),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.lock, size: 18,),
                  SizedBox(width: 10),
                  Text(
                    myUser.username,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                    splashRadius: 15,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if(widget.accountUser == null){
                        if(isLoading) return;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  child: Text("Delete"),
                                  onPressed: () async {
                                    
                                    Navigator.pop(context);
                                    setState(() {isLoading = true;});
                                    await AuthService().deleteAccount();
                                    await DatabaseService().deleteUser(mainUser);
                                    isLoading = false;
                                  }
                                  ),
                              ],
                              title: Text("Delete Account?"),
                              backgroundColor: textFieldBackground,
                            );
                          }
                        );
                      }
                    },
                  ),
                  IconButton(
                    splashRadius: 15,
                    icon: Icon(Icons.view_headline),
                    onPressed: () {
                      if(widget.accountUser == null){
                        if(isLoading) return;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  child: Text("Logout"),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    setState(() {isLoading = true;});
                                    await AuthService().signout();
                                    isLoading = false;
                                  }
                                  ),
                              ],
                              title: Text("Log Out?"),
                              backgroundColor: textFieldBackground,
                            );
                          }
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody(size) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: (size.width - 20) * 0.3,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: ()
                          {
                            showImageDialog(context, myUser.profileImg, false);
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: storyBorderColor),
                              shape: BoxShape.circle,
                              border: Border.all(width: 1, color: white),
                              image: DecorationImage(
                                image: NetworkImage(myUser.profileImg),
                                fit: BoxFit.cover
                              )
                            ),
                          ),
                        ),
                        widget.accountUser == null ? Positioned(
                          bottom: 0,
                          right: 25,
                          child: GestureDetector(
                            onTap: editUserImage,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary,
                                border: Border.all(width: 1, color: white)
                              ),
                              child: Center(
                                child: Icon(Icons.add, color: white),
                              ),
                            ),
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                  Container(
                    width: (size.width - 20) * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 5,),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                myPosts.length.toString(),
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Posts",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: getFollowersInfo,
                            child: Container(
                              color: black,
                              child: Column(
                                children: [
                                  Text(
                                    myUser.followers.length.toString(),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Follwers",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: getFollowersInfo,
                            child: Container(
                              color: black,
                              child: Column(
                                children: [
                                  Text(
                                    myUser.following.length.toString(),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Following",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () async
                        {
                          if(isLoading) return;
                          
                          if(widget.accountUser == null)
                          {
                            editUserProfile();
                            
                            return;
                          }
                          isLoading = true;

                          if(isFollowing){
                            print("unfollowing...");
                            await DatabaseService(uid: mainUser.userid).removeUserFollowers(myUser.userid);
                          }
                          else
                          {
                            print("following...");
                            await DatabaseService(uid: mainUser.userid).addUserFollowers(myUser.userid);
                          }
                          
                          isLoading =false;
                          
                          refreshPage();
                          print("done");
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: white),
                            borderRadius: BorderRadius.circular(5),
                            color: widget.accountUser == null ? textFieldBackground : !isFollowing ? buttonFollowColor : textFieldBackground,
                          ),
                          child: Center(
                            child: Text(
                              widget.accountUser == null ? "Edit Profile" : !isFollowing ? "Follow" :"Unfollow",
                              style: TextStyle(
                                
                              color: white,fontWeight: FontWeight.w600),),
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(myUser.instaName,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
              Text(myUser.about),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Story Highlights",
                    style: TextStyle(
                      fontWeight: FontWeight.bold)
                  ),
                  Icon(Icons.expand_more_outlined, size: 20)
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 0.5,
          width: size.width,
          decoration: BoxDecoration(color: white.withOpacity(0.8)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Container(
                width: (size.width * 0.5),
                child: IconButton(
                  splashRadius: 20,
                  icon: Icon(Icons.view_comfy_sharp, color: selectedIndex == 0 ? white : white.withOpacity(0.5),),
                  onPressed: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
              ),
              Container(
                width: (size.width * 0.5),
                child: IconButton(
                  splashRadius: 20,
                  icon: Icon(Icons.view_carousel, color: selectedIndex == 1 ? white : white.withOpacity(0.5),),
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Container(
                  height: 1,
                  width: (size.width * 0.5),
                  decoration: BoxDecoration(color: selectedIndex == 0 ? white : Colors.transparent),
                ),
                Container(
                  height: 1,
                  width: (size.width * 0.5),
                  decoration: BoxDecoration(color: selectedIndex == 1 ? white : Colors.transparent),
                ),
              ],
            ),
            Container(
              height: 0.5,
              width: size.width,
              decoration: BoxDecoration(color: white.withOpacity(0.8)),
            ),
          ],
        ),
        SizedBox(height: 3),
        IndexedStack(
          index: selectedIndex,
          children: [
            getImages(size),
            widget.accountUser == null ? getImageWithTags(size) : getImages(size),
          ],
        ),
      ],
    );
  }

  Widget getImages(size) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 3,
      runSpacing: 3,
      children: List.generate(myPosts.length, (index) {
        return GestureDetector(
          onTap: ()
          {
            showImageDialog(context, myPosts[index].imgUrl, myPosts[index].isVideo);
          },
          child: Container(
            height: 150,
            width: (size.width - 6) / 3,
            child: PostContent(
              isVideo: myPosts[index].isVideo,
              postContentUrl: myPosts[index].imgUrl,
            ),
          ),
        );
      })
    );
  }

  Widget getImageWithTags(size) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 3,
      runSpacing: 3,
      children: List.generate(myPosts.length, (index) {
        return Container(
          height: 150,
          width: (size.width - 6) / 3,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(myPosts[index].imgUrl),
              fit: BoxFit.cover
            )
          ),
          alignment: Alignment.topLeft,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PostContent(
                isVideo: myPosts[index].isVideo,
                postContentUrl: myPosts[index].imgUrl,
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                 child: IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.delete_outline_sharp),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                              child: Text("Delete"),
                              onPressed: () => deletePost(myPosts[index].id),
                            )
                          ],
                          title: Text("Delete Post?"),
                          backgroundColor: textFieldBackground,
                        );
                      }
                    );
                  },
                ),
              )
            ],
          ),
         
        );
      })
    );
  }
}