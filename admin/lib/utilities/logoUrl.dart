import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
    print("Split ${splitPath}");

    String logoUrl =
        "https://firebasestorage.googleapis.com/v0/b/${bucket}/o/${splitPath[0]}%2F${splitPath[1]}%2F${filename}?alt=media";
    print("Path ${logoUrl}");

    return logoUrl;
  }
  return "https://firebasestorage.googleapis.com/v0/b/${bucket}/o/files%2Flogo%2Flogo-green.png?alt=media";
}