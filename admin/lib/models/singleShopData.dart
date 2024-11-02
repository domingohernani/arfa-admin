import 'package:admin/models/furnituresData.dart';
import 'package:admin/models/sellersData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleShop {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;

  final String shopname;
  final String shoppermit;
  final String shopvalidid;
  final String logo;
  final Map<String, String> address;
  final List<Furniture> furniture;

  final String description;
  final int price;
  final int stock;
  final String category;
  final Timestamp createdatFurniture;
  final int depth;
  final int width;
  final int discountedprice;
  final int height;
  final String imageurl;
  final String imagepreviewfilename;
  final bool issale;
  final String modelurl;

  final String shopperid;
  final String orderstatus;
  final int ordertotal;
  final Timestamp createdatOrder;
  final List<dynamic> orderitems;

  SingleShop({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.address,
    required this.shopname,
    required this.shoppermit,
    required this.shopvalidid,
    required this.logo,
    required this.furniture,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.createdatFurniture,
    required this.depth,
    required this.width,
    required this.discountedprice,
    required this.height,
    required this.imageurl,
    required this.imagepreviewfilename,
    required this.issale,
    required this.modelurl,
    required this.shopperid,
    required this.orderstatus,
    required this.ordertotal,
    required this.createdatOrder,
    required this.orderitems,
  });
}
