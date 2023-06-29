import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:quicko/main.dart';
import 'package:quicko/vendor/views/screens/landing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorAuthScreen extends StatelessWidget {
  const VendorAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 32,
          ),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
              return InitialScreen();
            }));
          },
        ),
        title: null,
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providers: [
                EmailAuthProvider(),
              ],
            );
          }

          final currentUser = snapshot.data!;
          final String currentUserId = currentUser.uid;

          // Check if current user's UID exists in the "buyers" collection
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('buyers')
                .where('buyerId', isEqualTo: currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                // User is enrolled as a customer
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  FirebaseAuth.instance.signOut();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Enrollment as Customer'),
                        content: Text('You are enrolled as a customer with your current account details. Please register as a vendor.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                });
              } else {
                // User is not enrolled as a customer
                return LandingScreen();
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
