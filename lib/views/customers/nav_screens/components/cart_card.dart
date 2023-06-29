import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicko/views/customers/nav_screens/models/Cart.dart';

import 'package:quicko/size_config.dart';

import 'package:quicko/constants.dart';


class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  // Sepet ürünleri için QR verisi oluşturmak için bir metot.
  String generateQrData(Cart item) {
    String qrData = '';

    qrData = '${item.product.title}, ${item.product.price}, ${item.numOfItem}';

    return qrData;
  }

  Future<void> saveQrDataToFirestore(String qrData) async {
    // Current user'ın uid değerini al.
    var uid = FirebaseAuth.instance.currentUser!.uid;

    // QR koleksiyonunda belge oluştur ve belgenin ID'si olarak uid değerini belirle. QR verisini bu belgeye ekle.
    await FirebaseFirestore.instance.collection('QR').doc(uid).set({
      cart.product.title: qrData,
    }, SetOptions(merge: true));  // merge: true seçeneği, mevcut belgeye yeni alanlar ekler (varsa mevcut alanları korur).
  }


  @override
  Widget build(BuildContext context) {
    String qrData = generateQrData(cart);  // Burada QR verisini oluşturuyoruz.

    // QR verisini Firestore'a kaydediyoruz.
    saveQrDataToFirestore(qrData).then((_) {
      print('QR data saved to Firestore successfully!');
    }).catchError((error) {
      print('Failed to save QR data to Firestore: $error');
    });
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(cart.product.images[0]),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.product.title,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "\$${cart.product.price}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  children: [
                    TextSpan(
                        text: " x${cart.numOfItem}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        )
      ],
    );
  }
}