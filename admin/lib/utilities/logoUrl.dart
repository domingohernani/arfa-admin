import 'package:firebase_storage/firebase_storage.dart';

String getLogoUrl(String path) {
  String bucket = FirebaseStorage.instance.bucket;

  if (path.isNotEmpty) {
    List splitPath = path.split('/');
    String filename = splitPath.last;

    String logoUrl =
        "https://firebasestorage.googleapis.com/v0/b/${bucket}/o/files%2Flogo%2F${filename}?alt=media";

    return logoUrl;
  }
  return "https://firebasestorage.googleapis.com/v0/b/${bucket}/o/files%2Flogo%2Flogo-green.png?alt=media";
}

String getProductImageUrl(String path, String filename) {
  String bucket = FirebaseStorage.instance.bucket;

  if (path.isNotEmpty) {
    List splitPath = path.split('/');

    String logoUrl =
        "https://firebasestorage.googleapis.com/v0/b/${bucket}/o/${splitPath[0]}%2F${splitPath[1]}%2F${filename}?alt=media";

    return logoUrl;
  }
  return "https://firebasestorage.googleapis.com/v0/b/${bucket}/o/files%2Flogo%2Flogo-green.png?alt=media";
}

// String getUserImageUrl(String path) {
//   try {
//     if (path.isNotEmpty && path.contains('/')) {
//       // Split the path into folder and file name
//       List<String> splitPath = path.split('/');
//       if (splitPath.length >= 2) {
//         String folder = Uri.encodeComponent(splitPath[0]);
//         String fileName = Uri.encodeComponent(splitPath[1]);
//         return "https://firebasestorage.googleapis.com/v0/b/aria-16a4d.appspot.com/o/$folder%2F$fileName?alt=media";
//       }
//     }
//   } catch (e) {
//     print("Error generating user image URL: $e");
//   }
//   return ""; // Return an empty string for invalid paths
// }

String getUserImageUrl(String path) {
  if (path.isNotEmpty) {
    List splitPath = path.split('/');

    String logoUrl =
        "https://firebasestorage.googleapis.com/v0/b/aria-16a4d.appspot.com/o/${splitPath[0]}%2F${splitPath[1]}?alt=media";

    return logoUrl;
  }
  return "";
}
