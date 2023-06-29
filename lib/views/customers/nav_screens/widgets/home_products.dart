import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quicko/views/customers/productDetail/product_detail_screen.dart';

class HomeProductWidget extends StatefulWidget {
  final String categoryName;

  const HomeProductWidget({Key? key, required this.categoryName}) : super(key: key);

  @override
  _HomeProductWidgetState createState() => _HomeProductWidgetState();
}

class _HomeProductWidgetState extends State<HomeProductWidget> {
  final int initialDisplayCount = 2;
  int displayCount = 2;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.categoryName)
        .where('approved', isEqualTo: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "No products have found in this category",
                textAlign: TextAlign.center, // Metni ortala
                style: TextStyle(
                  fontSize: 20, // Font büyüklüğünü ayarla
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        final products = snapshot.data!.docs;
        final int productCount = products.length;
        final int _productCount = displayCount.clamp(0, productCount);
        final bool hasMoreProducts = displayCount < productCount;

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
              itemCount: _productCount,
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
                                style: Theme.of(context).textTheme.subtitle1!.merge(
                                  const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "\$${productData['productPrice'].toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.subtitle2!.merge(
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
            if (hasMoreProducts)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      displayCount += 2;
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