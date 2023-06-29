import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quicko/views/customers/productDetail/product_detail_screen.dart';

class MainProductWidget extends StatefulWidget {
  @override
  _MainProductWidgetState createState() => _MainProductWidgetState();
}

class _MainProductWidgetState extends State<MainProductWidget> {
  late Stream<QuerySnapshot> _productsStream;
  int _productCount = 2;

  @override
  void initState() {
    super.initState();
    _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue.shade700,
            ),
          );
        }

        final products = snapshot.data!.docs;
        final productCount = products.length;
        final displayCount =
        _productCount <= productCount ? _productCount : productCount;

        return Column(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                mainAxisExtent: 200,
              ),
              itemCount: displayCount,
              itemBuilder: (context, index) {
                final productData = products[index];
                final productName =
                    '${productData['productName'][0].toUpperCase()}${productData['productName'].substring(1)}';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ProductDetailScreen(
                          productData: productData,
                        );
                      }),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          child: Image.network(
                            "${productData['imageUrlList'][0]}",
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .merge(
                                  const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "\$${productData['productPrice'].toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .merge(
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (_productCount < productCount)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _productCount += 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    backgroundColor: Colors.black, // Change background color
                  ),
                  child: Text(
                    'View More',
                    style: TextStyle(color: Colors.white, fontSize: 16), // Adjust text color and size
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
