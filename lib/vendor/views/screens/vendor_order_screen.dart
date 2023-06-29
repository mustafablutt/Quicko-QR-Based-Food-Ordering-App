import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorOrderScreen extends StatefulWidget {
  @override
  _VendorOrderScreenState createState() => _VendorOrderScreenState();
}

class _VendorOrderScreenState extends State<VendorOrderScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('orders')
            .where('vendorId', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              bool isPickedUp = data['isPickedUp'];
              String statusText = isPickedUp ? 'order delivered.' : 'order not delivered';

              double totalPrice = 0.0;
              List<dynamic> items = data['items'];
              for (int i = 0; i < items.length; i++) {
                int quantity = items[i]['quantity'];
                double productPrice = items[i]['productPrice'];
                totalPrice += quantity * productPrice;
              }
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade900, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order ${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        if (isPickedUp)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        else
                          Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                      ],
                    ),
                    subtitle: Text("${data['fullName']}'s ${statusText} ",style: TextStyle(color: Colors.white,),),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Order Information',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text('Ordered Customer: ${data['fullName']}'),
                                  Text('Phone: ${data['phone']}'),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Items:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  for (int i = 0; i < items.length; i++)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Product ${i + 1}'),
                                        Text('Product Name: ${items[i]['productName']}'),
                                        Text('Quantity: ${items[i]['quantity']}'),
                                        Text('Product Price: ${items[i]['productPrice']}'),
                                        SizedBox(height: 16.0),
                                      ],
                                    ),
                                  Text(
                                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      child: Text('OK',style: TextStyle(color: Colors.blue),),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
