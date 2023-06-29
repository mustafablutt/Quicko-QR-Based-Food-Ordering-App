import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicko/main.dart';
import 'package:quicko/vendor/views/auth/vendor_auth.dart';

class VendorLogoutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          await _auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InitialScreen()),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue, // Arka plan rengi burada belirlenir
        ),
        child: Text(
          "Vendor Logout Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
