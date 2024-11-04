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

String getUserImageUrl(String path) {
  if (path.isNotEmpty) {
    List splitPath = path.split('/');

    String logoUrl =
        "https://firebasestorage.googleapis.com/v0/b/aria-16a4d.appspot.com/o/${splitPath[0]}%2F${splitPath[1]}?alt=media";

    return logoUrl;
  }
  return "";
}
