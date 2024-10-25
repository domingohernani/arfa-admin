import 'package:cloud_firestore/cloud_firestore.dart';

class Furniture {
  final String sellerid;
  final String name;
  final String description;
  final int price;
  final int stock;
  final String category;
  final Timestamp createdat;
  final int depth;
  final int width;
  final int discountedprice;
  final int height;
  final String imageurl;
  final String imagepreviewfilename;
  final bool issale;
  final String modelurl;

  Furniture({
    required this.sellerid,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.createdat,
    required this.depth,
    required this.width,
    required this.discountedprice,
    required this.height,
    required this.imageurl,
    required this.imagepreviewfilename,
    required this.issale,
    required this.modelurl,
  });

  factory Furniture.fromFirestore(Map<String, dynamic> data) {
    return Furniture(
        sellerid: data['ownerId'] ?? "",
        name: data['name'] ?? "",
        description: data['description'] ?? "",
        price: data['price'] ?? 0,
        stock: data['stock'] ?? 0,
        category: data['category'] ?? "",
        createdat: data['createAt'],
        depth: data['depth'] ?? 0,
        width: data['width'] ?? 0,
        discountedprice: data['discountedPrice'] ?? 0,
        height: data['height'] ?? 0,
        imageurl: data['imagesUrl'] ?? "",
        imagepreviewfilename: data['imgPreviewFilename'] ?? "",
        issale: data['isSale'],
        modelurl: data['modelUrl'] ?? "");
  }
}
