import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quicko/views/customers/productDetail/store_detail.dart';

class StoreText extends StatelessWidget {
  final Stream<QuerySnapshot> _storeStream =
  FirebaseFirestore.instance.collection('vendors').snapshots();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Stores',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _storeStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              }

              final storeList = snapshot.data!.docs;
              final approvedStoreList = storeList.where((storeData) => storeData['approved'] ?? false).toList();

              return SizedBox(
                height: 140.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: approvedStoreList.length,
                  itemBuilder: (context, index) {
                    final storeData = approvedStoreList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return StoreDetailScreen(storeData: storeData);
                          }),
                        );
                      },
                      child: Container(
                        width: 120.0,
                        margin: EdgeInsets.only(right: 16.0),
                        child: Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                  storeData['storeImage'],
                                  height: 80.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storeData['businessName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      storeData['cityValue'],
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1, // Set maximum lines to 1
                                      overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          color: Colors.grey.shade200,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
