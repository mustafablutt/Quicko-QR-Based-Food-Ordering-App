import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quicko/views/customers/productDetail/product_detail_screen.dart';

class StoreDetailScreen extends StatelessWidget {
  final dynamic storeData;

  const StoreDetailScreen({Key? key, required this.storeData});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('vendorId', isEqualTo: storeData['vendorId'])
        .snapshots();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('vendors')
                          .doc(storeData['vendorId'])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/default_vendor_image.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.yellow.shade900,
                              ),
                            ),
                          );
                        }

                        final Map<String, dynamic>? vendorData =
                        snapshot.data?.data() as Map<String, dynamic>?;

                        if (vendorData == null ||
                            vendorData['storeImage'] == null ||
                            !Uri.parse(vendorData['storeImage']).isAbsolute) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/default_vendor_image.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }

                        final cityValue = vendorData['cityValue'] ?? '';
                        final email = vendorData['email'] ?? '';
                        final phone = vendorData['phone'] ?? '';

                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(vendorData['storeImage'] as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('vendors')
                        .doc(storeData['vendorId'])
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }

                      final Map<String, dynamic>? vendorData =
                      snapshot.data?.data() as Map<String, dynamic>?;

                      if (vendorData == null) {
                        return Container();
                      }

                      final businessName = vendorData['businessName'] as String?;
                      final cityValue = vendorData['cityValue'] ?? '';
                      final email = vendorData['email'] ?? '';
                      final phone = vendorData['phone'] ?? '';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            capitalizeFirstLetter(businessName ?? ''),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5, // Adjust the letter spacing for uniqueness
                              shadows: [
                                Shadow(
                                  color: Colors.grey,
                                  offset: Offset(2, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'City: $cityValue',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Email: $email',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Phone: $phone',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _productsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: Colors.yellow.shade900,
                        );
                      }

                      final List<Map<String, dynamic>> products = [];
                      snapshot.data!.docs.forEach((productDoc) {
                        final productName = productDoc['productName'] as String?;
                        final price = productDoc['productPrice'] as double?;
                        final imageUrl = productDoc['imageUrlList'][0] as String?;

                        if (productName != null && price != null && imageUrl != null) {
                          final product = {
                            'productName': productName,
                            'productPrice': price,
                            'imageUrlList': imageUrl,
                          };
                          products.add(product);
                        }
                      });

                      if (products.isEmpty) {
                        return Center(
                          child: Text(
                            'No Products Found',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = products[index];
                          final isEvenIndex = index % 2 == 0;
                          final cardColor = isEvenIndex ? Colors.white : Colors.grey.shade200;
                          return Card(
                            color: cardColor,
                            elevation: 4,
                            margin: EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text(
                                product['productName'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                '\$${product['productPrice'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product['imageUrlList'] as String,
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      productData: snapshot.data!.docs[index].data(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return '';
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}