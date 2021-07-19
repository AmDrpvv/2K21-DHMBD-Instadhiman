import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class FireStorageService{
  final File file;
  final String fileName;
  FireStorageService({this.file, this.fileName});

  Future uploadFile() async {

    try {

      firebase_storage.Reference storageReference = 
      firebase_storage.FirebaseStorage.instance.ref().child("images/$fileName");

      final firebase_storage.UploadTask uploadTask = storageReference.putFile(file);
      String url = await (await uploadTask).ref.getDownloadURL();
      
      print('url for uploaded image is : $url');
      return url;

    } catch (e) {
      print("error in image uploading $e");
    }
    
  //   final firebase_storage.TaskSnapshot downloadUrl = (await uploadTask.whenComplete());
  //   final String url = (await downloadUrl.ref.getDownloadURL());
  //   print('url for uploaded image is : $url');
  //   return url;
  }

  Future deleteFile() async {
    try {
      await firebase_storage.FirebaseStorage.instance.ref().child("images/$fileName").delete();

    } catch (e) {
      print("error in image deletion $e");
    }
  }

  Future getImageUrl() async{
    try {
      return await firebase_storage.FirebaseStorage.instance.ref().child("$fileName").getDownloadURL();
    } catch (e) {
      print("$e");
    }
  }

}