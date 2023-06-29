import 'package:flutter/material.dart';
import 'package:quicko/views/customers/nav_screens/payment/generateQR_screen.dart';

import '../../main_screen.dart';
import '../cart_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          ),
        ),
        title: Text("Payment Methods"),
        backgroundColor: Colors.amber[600],
        elevation: 0,
        toolbarHeight: 100,
        actions: [
          Icon(Icons.settings),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: content(context),
    );
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            paymentMethod("Master Card", "assets/images/mastercard.png"),
            SizedBox(
              height: 30,
            ),
            paymentMethod("Paypal", "assets/images/paypal.png"),
            SizedBox(
              height: 30,
            ),
            paymentMethod("Visa", "assets/images/visa.png"),
            SizedBox(height: 200),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            QRGeneratorScreen()));
              },
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget paymentMethod(String title, String iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = title;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3))
            ]),
        child: ListTile(
          title: Text(title),
          leading: Container(
            child: Image.asset(iconPath),
            height: 50,
            width: 50,
          ),
          trailing: _selectedMethod == title
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.circle_outlined),
        ),
      ),
    );
  }
}