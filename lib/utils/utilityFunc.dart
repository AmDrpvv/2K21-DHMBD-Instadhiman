import 'dart:io';
import 'package:Instadhiman/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Instadhiman/utils/Models.dart';
import 'package:image_cropper/image_cropper.dart';

// List shuffle(List items, [int seed = 0]) {

//   var random = new Random();

//   // Go through all elements.
//   for (var i = items.length - 1; i > 0; i--) {

//     // Pick a pseudorandom number according to the list length
//     var n = random.nextInt(i + 1);

//     var temp = items[i];
//     items[i] = items[n];
//     items[n] = temp;
//   }

//   return items;
// }

dynamic findInList(String id, List<Post> posts)
{
  Post myPost = posts.firstWhere((post){
    return post.id == id;
  });
  posts.remove(myPost);
  return {myPost, posts};
}

Future<File> getImageFromDevice(bool isCamera) async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      // maxHeight: 720,
      // imageQuality: 90,
      // maxWidth: 720
      );

  if (pickedFile != null) {
    return await getCroppedImageFromDevice(File(pickedFile.path));
  } else {
    return null;
  }
}

Future<File> getCroppedImageFromDevice(File imageFile) async
{
  File croppedFile = await ImageCropper.cropImage(
    sourcePath: imageFile.path,
    maxHeight: 720,
    maxWidth: 720,
    compressQuality: 90,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      // CropAspectRatioPreset.ratio3x2,
      // CropAspectRatioPreset.original,
      // CropAspectRatioPreset.ratio4x3,
      // CropAspectRatioPreset.ratio16x9
    ],
    androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Instadhiman',
        toolbarColor: black,
        toolbarWidgetColor: white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
        backgroundColor: textFieldBackground,
        statusBarColor: black,
        activeControlsWidgetColor: buttonFollowColor,
      ),
  );

  return croppedFile ?? null;
}

Future<File> getVideoFromDevice(bool isCamera) async {
  if(1==1) return null;
  final picker = ImagePicker();
  final pickedFile = await picker.getVideo(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,

      maxDuration: Duration(minutes: 2)
      // maxHeight: 720,
      // imageQuality: 90,
      // maxWidth: 720
      );

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

String convertDateTime(DateTime data)
{
  // String formattedDate = "${data.weekday}";
  Duration duration = DateTime.now().difference(data);
  if(duration.inMinutes < 60 ){
    if(duration.inMinutes < 2 ) return "a few seconds ago";
    return "${duration.inMinutes} minutes ago";
  }else if(duration.inHours < 24 ){
    if(duration.inHours < 2) return "an hour ago";
    return "${duration.inHours} hours ago";
  }else if(duration.inDays < 30 ){
    if(duration.inDays < 2 ) return "a day ago";
    return "${duration.inDays} days ago";
  }

  return "${data.day.toString().padLeft(2,'0')}-${data.month.toString().padLeft(2,'0')}-${data.year}"+
   " ${data.hour.toString().padLeft(2,'0')}:${data.minute.toString().padLeft(2,'0')}";
}

