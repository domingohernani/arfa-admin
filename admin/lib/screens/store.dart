import 'package:admin/constants/constant.dart';
import 'package:flutter/material.dart';

class StoreProfileView extends StatefulWidget {
  const StoreProfileView({super.key});

  @override
  State<StoreProfileView> createState() => _StoreProfileView();
}

class _StoreProfileView extends State<StoreProfileView> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'The Meridian Marvel',
      'price': '₱ 4,990.00',
      'rating': 5.0,
      'image': 'assets/meridian.png',
    },
    {
      'name': 'The Valencia Vista',
      'price': '₱ 1,290.00',
      'rating': 4.8,
      'image': 'assets/valencia.png',
    },
    {
      'name': 'The Seraphina Surface',
      'price': '₱ 1,890.00',
      'rating': 4.6,
      'image': 'assets/seraphina.png',
    },
    {
      'name': 'The Cambridge Cache',
      'price': '₱ 3,490.00',
      'rating': 4.6,
      'image': 'assets/cambridge.png',
    },
    {
      'name': 'The Ashton Allure',
      'price': '₱ 1,250.00',
      'rating': 4.4,
      'image': 'assets/ashton.png',
    },
    {
      'name': 'The Windsor Whisper',
      'price': '₱ 2,499.00',
      'rating': 4.3,
      'image': 'assets/windsor.png',
    },
    {
      'name': 'The Avalon Accent',
      'price': '₱ 1,990.00',
      'rating': 3.7,
      'image': 'assets/avalon.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width =
        MediaQuery.of(context).size.width - sidebarSize - paddingHorizontal;
    return SizedBox(
      height: height,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          children: [Text("store profile")],
        ),
      ),
    );
  }
}

class SellerInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/logo.png'), // Seller logo
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HD Furniture',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text('Seller ID: #101'),
                    Text('Contacts: hdfurniture@gmail.com'),
                    Text('Phone: +639094562331'),
                    Text(
                        'Address: McArthur Highway, Barangay San Vicente, Urdaneta City'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text('Total Sales: ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Units Sold: '),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String name;
  final String price;
  final double rating;
  final String imagePath;

  ProductCard({
    required this.name,
    required this.price,
    required this.rating,
    required this.imagePath,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.price),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4.0),
                    Text(widget.rating.toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
