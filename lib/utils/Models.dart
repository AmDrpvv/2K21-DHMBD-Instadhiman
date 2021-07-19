
final String userId = "userId";
final String userName = "userName";
final String userPassword = "password";
final String userInstaName = "instaName";
final String userProfileImg = "profileImg";
final String userAbout = "about";
final String userPosts = "posts";
final String userFollowers = "followers";
final String userFollowing = "following";


final String postId ="postId";
final String postUserID ="postUserId";
final String postIsVideo ="isVideo";
final String postCaption ="caption";
// final String postProfileImgUrl ="profileImgUrl";
final String postImgUrl ="ImgUrl";
final String postLikedBy ="likedBy";
final String postComments ="comments";
final String postTimeStamp ="timeStamp";

final String defaultImgUrl ="https://firebasestorage.googleapis.com/v0/b/instadhiman.appspot.com/o/idef2.png?alt=media&token=ce11a2f3-f7db-43cb-9dd2-ee0cb29dff5c";

class User {
  String userid;
  String username;
  String password;
  String instaName;
  String profileImg;
  String about;
  List<dynamic> posts;
  List<dynamic> followers;
  List<dynamic> following;

  User({this.userid,this.password, this.instaName, this.username, this.profileImg,
  this.about, this.posts, this.followers, this.following});

  User.fromMap(Map<String, dynamic> map){
    userid = map[userId] ?? '';
    username = map[userName] ?? 'instadhiman_@123';
    password = map[userPassword] ?? '';
    instaName = map[userInstaName] ?? 'instaMAN';
    
    profileImg = map[userProfileImg] ?? defaultImgUrl;
    about = map[userAbout] ?? "#hey there i'm using \n#instadhiman";
    posts = map[userPosts] ?? [];
    followers = map[userFollowers] ?? [];
    following = map[userFollowing] ?? [];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      userId : userid ,
      userName : username,
      userInstaName : instaName,
      userPassword : password,
      userProfileImg : profileImg,
      userAbout : about,
      userFollowers : followers ?? [],
      userPosts : posts ?? [],
      userFollowing : following ?? []
    };

    if(userid != null)
      map[userId] = userid;

    return map;
  }

  String repr(){
    return '$userid, $instaName, $username, $password';
  }
}


class Post {
  String id;
  String name;
  String userId;
  bool isVideo;
  bool isLoved;
  String caption;
  String profileImgUrl;
  String imgUrl;
  List<dynamic> likedBy;
  List<dynamic> comments;
  DateTime timeStamp;

  Post({this.id, this.isVideo,this.isLoved=false,this.userId, this.name, this.profileImgUrl, this.imgUrl,
  this.timeStamp, this.comments, this.likedBy, this.caption});

  Post.fromMap(Map<String,dynamic> map){
    id = map[postId] ?? "";
    caption = map[postCaption] ?? "instadhiman New Post added";
    userId = map[postUserID] ?? "";
    isVideo = map[postIsVideo] ?? false;
    imgUrl = map[postImgUrl] ?? defaultImgUrl;
    likedBy = map[postLikedBy] ?? [];
    comments = map[postComments] ?? [];
    timeStamp = map[postTimeStamp]?.toDate() ?? DateTime.now();

  }

  Map<String, dynamic> toMap()
  {
    var map = <String, dynamic>{
      postUserID : userId ,
      postCaption : caption,
      postImgUrl : imgUrl,
      postIsVideo : isVideo,
      postLikedBy : likedBy ?? [],
      postComments : comments ?? [],
      postTimeStamp : timeStamp ?? DateTime.now()
    };

    if(id != null)
      map[postId] = id;

    return map;
  }

  String repr()
  {
    return "$id , $name , $caption , $isVideo";
  }

}