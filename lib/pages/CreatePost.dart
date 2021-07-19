import 'dart:io';
import 'package:Instadhiman/Services/FirestoreDB.dart';
import 'package:Instadhiman/Services/Storage.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:Instadhiman/widgets/Loading.dart';
import 'package:Instadhiman/theme/colors.dart';
import 'package:Instadhiman/utils/utilityFunc.dart';
import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  final String mainUserID;

  const CreatePost({Key key, this.mainUserID}) : super(key: key);
  @override
  _CreatePostState createState() => _CreatePostState();
}


class _CreatePostState extends State<CreatePost> {

  bool isLoading = false;
  File postContent;
  bool showVideo;
  TextEditingController captionTextController;
  
  @override
  void initState() {
    captionTextController = TextEditingController();
    isLoading = false;
    showVideo = false;
    postContent = null;
    super.initState();
  }

  @override
  void dispose() {
    refreshPage();
    super.dispose();
  }

  refreshPage(){
    isLoading = false;
    showVideo = false;
    captionTextController.clear();
    if(postContent != null)
    {
      postContent.delete(recursive: true);
      imageCache.clear();
      postContent = null;
    }
  }

uploadPost()async{

  if(isLoading || captionTextController.text.length < 1) return;

  try {
      if(postContent != null){

        setState(() {isLoading = true;});
        String postID = await DatabaseService().createNewPostID();
        String url = await FireStorageService(file: postContent, fileName: postID).uploadFile();
        
        
        if(url != null)
        {
          
          Post post = new Post(
            caption: captionTextController.text,
            userId : widget.mainUserID,
            id: postID,
            imgUrl: url,
            isVideo: showVideo,
            timeStamp: DateTime.now()
          );

          await DatabaseService(uid: postID).createNewPost(post);
          await DatabaseService(uid: widget.mainUserID).addUserPost(postID);

        }
        isLoading = false;
        setState(() { refreshPage();}); 
        
      }
    
  } catch (e) {
    print("error in uploading post $e");
  }
  
}

  showPost(bool isCamera, bool isVideo) async{
    if(isLoading ) return;
    Navigator.pop(context);

    isLoading = true;
    if(postContent != null)
    {
      postContent.delete(recursive: true);
      imageCache.clear();
      postContent = null;
    }

    if(isVideo)
    {
      postContent = await getVideoFromDevice(isCamera);
      showVideo = true;
    }else
    {
      postContent = await getImageFromDevice(isCamera);
      showVideo = false;
    }
    setState(() {isLoading = false;});
  }

  getPostfromDevice(bool isVideo){
    Navigator.pop(context);
    showModalBottomSheet(
    context: context,
    backgroundColor: textFieldBackground,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => showPost(true, isVideo),
            title: Text("Camera"),
            leading: Icon(Icons.camera),
          ),
          ListTile(
            onTap: () => showPost(false, isVideo),
            title: Text("Gallery"),
            leading: Icon(Icons.photo_library_outlined),
          ),
        ],
      );
    }
    );
  }

  showBottomSheetForPost(){
    if(isLoading ) return;
    showModalBottomSheet(
    context: context,
    backgroundColor: textFieldBackground,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => getPostfromDevice(false),
            title: Text("Image"),
            leading: Icon(Icons.image),
          ),
          ListTile(
            onTap: () => getPostfromDevice(true),
            title: Text("Video"),
            leading: Icon(Icons.videocam_outlined),
          ),
        ],
      );
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading(): RefreshIndicator(
      backgroundColor: black,
      color: white,
      onRefresh: () async{
        setState(() { refreshPage();});
      },
      child: SingleChildScrollView(
        physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30.0,),
              Container(
                alignment: Alignment.centerLeft,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: white.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                    color: textFieldBackground),
                child: TextField(
                  controller: captionTextController,
                  decoration: InputDecoration(
                    hintText: "Post Caption",
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.edit,
                        color: white.withOpacity(0.3),
                      )),
                  style: TextStyle(color: white),
                  cursorColor: white,
                ),
              ),
              SizedBox(height: 30.0,),
              showVideo && postContent != null ? Container(
                alignment: Alignment.center,
                height: 350,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: white.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                    color: textFieldBackground),
                child: Container(color: black,)
                // ChewieListItem(
                //   videoPlayerController: VideoPlayerController.file(postContent),
                //   looping: true,
                // ),
              ): Container(
                alignment: postContent == null ? Alignment.center : Alignment.bottomLeft,
                height: 350,
                decoration: BoxDecoration(
                  image: postContent == null ? null : DecorationImage(
                    image: FileImage(postContent),fit: BoxFit.cover),
                  border: Border.all(width: 1, color: white.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                    color: textFieldBackground),
                child: CircleAvatar(
                  backgroundColor: buttonFollowColor,
                  child: IconButton(icon : Icon(Icons.add),
                  color: white,
                  onPressed: showBottomSheetForPost
                ),
                ),
              ),
              SizedBox(height: 30.0,),
              GestureDetector(
                onTap: uploadPost,
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: white.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                      color: buttonFollowColor),
                  child: Text("Upload"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}