import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:quicko/provider/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white, // Change AppBar color to white
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.productData['productName'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 2,
            color: Colors.black, // Change AppBar text color to black
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.grey[300], // Change color to light grey
                  height: 300,
                  width: double.infinity,
                  child: PhotoView(
                    imageProvider: NetworkImage(
                      widget.productData['imageUrlList'][_imageIndex],
                    ),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.transparent, // Make PhotoView background transparent
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.productData['imageUrlList'].length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _imageIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.yellow.shade900,
                                  ),
                                  borderRadius: BorderRadius.circular(10), // Rounded mini images
                                ),
                                height: 60,
                                width: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10), // Rounded mini images
                                  child: Image.network(widget.productData['imageUrlList'][index]),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0), // Added padding for readability
              child: Text(
                '\$' + widget.productData['productPrice'].toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added padding for readability
              child: Text(
                widget.productData['productName'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 4,
                ),
              ),
            ),
            ExpansionTile(
              title: Text(
                'Product Description',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.start, // Or TextAlign.left
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productData['description'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            if (_cartProvider.isVendorIdSame(widget.productData['vendorId'])) {
              if (!_cartProvider.getCartItems.containsKey(widget.productData['productId'])) {
                _cartProvider.addProductToCart(
                  widget.productData['productName'],
                  widget.productData['productId'],
                  widget.productData['imageUrlList'],
                  1,
                  widget.productData['productQuantity'],
                  widget.productData['productPrice'],
                  widget.productData['vendorId'],
                );
              }
            } else {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Warning'),
                  content: Text('You cant add product from different vendors!'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              );
            }
          },

          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _cartProvider.getCartItems
                  .containsKey(widget.productData['productId'])
                  ? Colors.grey
                  : Colors.blueAccent, // Change color to blue accent
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    CupertinoIcons.cart,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _cartProvider.getCartItems
                      .containsKey(widget.productData['productId'])
                      ? Text(
                    'In Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                      : Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
