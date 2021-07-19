import 'package:Instadhiman/theme/colors.dart';
import 'package:flutter/material.dart';

class PostContent extends StatelessWidget {
  final bool isVideo;
  final String postContentUrl;

  const PostContent({Key key, this.isVideo, this.postContentUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return isVideo  ?
    Container(
      color: textFieldBackground,
    ) 
    // ChewieListItem(
    //   videoPlayerController: VideoPlayerController.network(postContentUrl),
    //   looping: true,
    // )
    : Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(postContentUrl),fit: BoxFit.cover)
      ),
    );
  }
}