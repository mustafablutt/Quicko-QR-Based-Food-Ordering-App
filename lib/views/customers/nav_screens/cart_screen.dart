import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quicko/provider/cart_provider.dart';
import 'package:quicko/views/customers/main_screen.dart';
import 'package:quicko/views/customers/nav_screens/components/check_out.dart';

class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        title: Text(
          'Cart Screen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _cartProvider.removeAllItem();
            },
            icon: Icon(
              CupertinoIcons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomSheet: CheckoutCard(),
      body:_cartProvider.getCartItems.isNotEmpty? ListView.builder(
        shrinkWrap: true,
        itemCount: _cartProvider.getCartItems.length,
        itemBuilder: (context, index) {
          final cartData = _cartProvider.getCartItems.values.toList()[index];
          return Card(
            color: Colors.white,
            child: SizedBox(
              height: 140,
              child: Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.network(cartData.imageUrl[0]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartData.productName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:Colors.black,
                          ),
                        ),
                        Text(
                          '\$' + cartData.price.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue.shade900,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: cartData.quantity == 1
                                          ? null
                                          : () {
                                        _cartProvider
                                            .decreament(cartData);
                                      },
                                      icon: Icon(
                                        CupertinoIcons.minus,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      cartData.quantity.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: cartData.productQuantity ==
                                          cartData.quantity
                                          ? null
                                          : () {
                                        _cartProvider.increment(cartData);
                                      },
                                      icon: Icon(
                                        CupertinoIcons.plus,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _cartProvider.removeItem(cartData.productId);
                                },
                                icon: Icon(CupertinoIcons.cart_badge_minus),
                              ),
                            ],
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
      ):
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
              },
              child: Text('Continue Shopping',style: TextStyle(color: Colors.blue.shade500),),
            ),
          ],
        ),
      ),
    );
  }
}