import 'package:Instadhiman/Services/Storage.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService
{
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("User Collection");
  final CollectionReference postCollection = FirebaseFirestore.instance.collection("Post Collection");
  
  List<User> _changeQuerySnapshotIntoUser(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc){
      return User.fromMap(doc.data());
    }
    ).toList();
  }

  Stream<List<User>> get allUserStream {
    return userCollection.orderBy(userName).snapshots()
    .map(_changeQuerySnapshotIntoUser);
  }

  List<Post> _changeQuerySnapshotIntoPost(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc){
      return Post.fromMap(doc.data());
    }
    ).toList();
  }
  List<String> _changeQuerySnapshotIntoPostImages(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc){
      return doc.data()[postImgUrl].toString();
    }
    ).toList();
  }

  Stream<List<Post>> get allPostStream {
    return postCollection.snapshots()
    .map(_changeQuerySnapshotIntoPost);
  }

  Future<User> getUser() async {
    try {
      var map = await userCollection.doc(uid).get();
      return User.fromMap(map.data());
    } catch (e) {
      print("error $e");
      return null;
    }
  }

  Future<Post> getPost() async {
    try {
      var map = await postCollection.doc(uid).get();
      return Post.fromMap(map.data());
    } catch (e) {
      print("error $e");
      return null;
    }
    
  }

  Future getAllPost() async {
    var map = await postCollection.get();
    return _changeQuerySnapshotIntoPost(map);
  }

  Future getAllUser(String exceptUserID) async {
    var map = await userCollection.where(userId, isNotEqualTo: exceptUserID).get();
    return _changeQuerySnapshotIntoUser(map);
  }

  Future getAllPostImages() async {
    var map = await postCollection.get();
    return _changeQuerySnapshotIntoPostImages(map);
  }



  Future createnewUserID() async
  {
    return userCollection.doc().id;
  }

  Future createNewUser(User user) async
  {
    return await userCollection.doc(uid).set(user.toMap());
  }
  Future updateWholeUser(User user) async{
    return await userCollection.doc(uid).update(user.toMap());
  }

  Future updateUser(Map<String, dynamic> map) async{
    return await userCollection.doc(uid).update(map);
  }

  Future updatePost(Post post) async{
    return await postCollection.doc(uid).update(post.toMap());
  }

  Future addUserFollowers(String followerID) async{
    DocumentReference docRefrUser = userCollection.doc(uid);
    DocumentReference docRefrFollower = userCollection.doc(followerID);
    await docRefrUser.update(
      {
        userFollowing : FieldValue.arrayUnion([followerID]),
      }
    );
    await docRefrFollower.update(
      {
        userFollowers : FieldValue.arrayUnion([uid]),
      }
    );
  }

  Future removeUserFollowers(String followerID) async{
    DocumentReference docRefrUser = userCollection.doc(uid);
    DocumentReference docRefrFollower = userCollection.doc(followerID);
    await docRefrUser.update(
      {
        userFollowing : FieldValue.arrayRemove([followerID]),
      }
    );
    await docRefrFollower.update(
      {
        userFollowers : FieldValue.arrayRemove([uid]),
      }
    );
  }

  Future addUserPost(String postID) async{
    DocumentReference docRefrUser = userCollection.doc(uid);
    await docRefrUser.update(
      {
        userPosts : FieldValue.arrayUnion([postID]),
      }
    );
  }

  Future removeUserPost(String postID) async{
    DocumentReference docRefrUser = userCollection.doc(uid);
    await docRefrUser.update(
      {
        userPosts : FieldValue.arrayRemove([postID]),
      }
    );
  }

  Future addLikedPost(String likedUserID) async{
    DocumentReference docRef = postCollection.doc(uid);
    await docRef.update(
      {
        postLikedBy : FieldValue.arrayUnion([likedUserID]),
      }
    );
  }
  Future removeLikedPost(String likedUserID) async{
    DocumentReference docRef = postCollection.doc(uid);
    await docRef.update(
      {
        postLikedBy : FieldValue.arrayRemove([likedUserID]),
      }
    );
  }


  Future createNewPostID() async
  {
    return postCollection.doc().id;
  }

  Future createNewPost(Post post) async
  {
    await postCollection.doc(uid).set(post.toMap());
  }

  Future deletePost(String postID) async
  {
    await postCollection.doc(postID).delete();
    await removeUserPost(postID);
    await FireStorageService(fileName: postID).deleteFile();
  }

  Future deleteUser(User user) async
  {
    
    for (int i = 0; i < user.following.length; i++) {
      DocumentReference docRefrUser = userCollection.doc(user.following[i]);
      await docRefrUser.update(
        {
          userFollowers : FieldValue.arrayRemove([user.userid]),
        }
    );
    }

    for (int i = 0; i < user.posts.length; i++) {
      await FireStorageService(fileName: user.posts[i]).deleteFile();
      await postCollection.doc(user.posts[i]).delete();
    }

    await userCollection.doc(user.userid).delete();

    if(user.profileImg != defaultImgUrl)
      await FireStorageService(fileName: user.userid).deleteFile();
  }
}

