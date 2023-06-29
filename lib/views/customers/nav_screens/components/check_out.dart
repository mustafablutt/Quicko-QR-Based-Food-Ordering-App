import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quicko/provider/cart_provider.dart';
import 'package:quicko/views/customers/nav_screens/payment/payment_screen.dart';

import 'package:quicko/size_config.dart';
import 'package:quicko/constants.dart';
import 'package:uuid/uuid.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  bool isPickedUp = false;
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    SizeConfig().init(context);
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(15),
              horizontal: getProportionateScreenWidth(30),
            ),
            height: 102,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA).withOpacity(0.15),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text: _cartProvider.totalPrice.toStringAsFixed(2),
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: InkWell(
                          onTap: _cartProvider.totalPrice == 0.00
                              ? null
                              : () async {
                            EasyLoading.show(status: 'Placing Order');
                            final orderId = Uuid().v4();

                            List<Map<String, dynamic>> items = [];
                            _cartProvider.getCartItems
                                .forEach((key, item) {
                              items.add({

                                'vendorId': item.vendorId,
                                'productName': item.productName,
                                'productPrice': item.price,
                                'productId': item.productId,
                                'productImage': item.imageUrl,
                                'quantity': item.quantity,

                              });
                              item.productQuantity -= item.quantity;
                            });

                            _firestore
                                .collection('orders')
                                .doc(orderId)
                                .set({
                              "vendorId": items[0]["vendorId"],
                              "isPickedUp":isPickedUp,
                              'orderId': orderId,
                              'email': data['email'],
                              'phone': data['phoneNumber'],
                              'address': data['address'],
                              'buyerId': data['buyerId'],
                              'fullName': data['fullName'],
                              'userPhoto': data['profileImage'],
                              'items': items,
                              'orderDate': DateTime.now(),
                            }).whenComplete(() async {
                              setState(() {
                                _cartProvider.getCartItems.clear();
                              });
                              EasyLoading.dismiss();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentScreen()));
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _cartProvider.totalPrice == 0.00
                                  ? Colors.grey
                                  : Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                "Check Out",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.blue.shade300,
          ),
        );
      },
    );
  }
}
