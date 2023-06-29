import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../productDetail/store_detail.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorsStream =
    FirebaseFirestore.instance.collection('vendors').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stores',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade900,
              ),
            );
          }

          return Container(
            height: 500,
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade300,
                height: 1,
              ),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                final storeData = snapshot.data!.docs[index];

                // Check if the store is approved
                bool isApproved = storeData['approved'] ?? false;
                if (!isApproved) {
                  // If not approved, return an empty container
                  return Container();
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return StoreDetailScreen(
                            storeData: storeData,
                          );
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    title: Text(
                      storeData['businessName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      storeData['cityValue'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(storeData['storeImage']),
                    ),
                  ),
                );
              },
            ),
          );

        },
      ),
    );
  }
}
