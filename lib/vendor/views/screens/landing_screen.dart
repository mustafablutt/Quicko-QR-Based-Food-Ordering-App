import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicko/vendor/views/auth/vendor_registor.dart';

import '../../models/vender_user_models.dart';
import 'main_vendor_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollectionReference _vendorsStream =
    FirebaseFirestore.instance.collection('vendors');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final String currentUserId = _auth.currentUser!.uid;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _vendorsStream.doc(currentUserId).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          if (!snapshot.data!.exists) {
            return VendorRegisterScreen();
          }

          bool isApproved = snapshot.data!.get('approved') ?? false;
          if (isApproved) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainVendorScreen()),
              );
            });
            return Container();
          }

          VendorUserModel vendorUserModel = VendorUserModel.fromJson(
              snapshot.data!.data()! as Map<String, dynamic>);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    vendorUserModel.storeImage.toString(),
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  vendorUserModel.businessName.toString(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15),
                Text(
                  "Your application has been sent to shop admin\n Admin will get back to you soon",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: Text("Sign out"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
