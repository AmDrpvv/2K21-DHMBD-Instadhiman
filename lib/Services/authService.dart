import 'package:Instadhiman/Services/FirestoreDB.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Instadhiman/utils/Models.dart' as models;


class AuthService{
  final FirebaseAuth _auth =FirebaseAuth.instance;
//create our user from firebase user
  String _createStringfromFirebaseuser(User user){
    return user==null ? "" : user.uid;
  }

  // auth change user stream
  Stream<String> get userStream {
    return _auth.authStateChanges()
        .map((User user) => _createStringfromFirebaseuser(user));
  }


  //signin with username and password
  Future signin(String email,String password) async
  {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      User user = userCredential.user;
      return _createStringfromFirebaseuser(user);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      else {
        print("$e");
        return null;
      }
    }
  }

  //register with username and password
  Future register({String instaName,String password, String email, String about}) async
  {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      User user = userCredential.user;

      if(user!=null){
        await DatabaseService(uid: user.uid).createNewUser(
          models.User(
            instaName: instaName,
            password: password,
            userid: user.uid,
            username: email,
            about: about,
          )
        );
      }
      return _createStringfromFirebaseuser(user);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }else {
        print("$e");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }


  //signing out
  Future signout ()async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print('Error in signout :'+ e.toString());
      return null;
    }
  }

  //deleting User
  Future deleteAccount() async{
    
    try {
      await _auth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }

  }
}