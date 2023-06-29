import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        title: Text(
          'Scan QR Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller?.toggleFlash();
        },
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Arka plan rengi
          ),
          child: Text(
            'BACK',
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 2,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();

      final String orderId = scanData.code!;
      final orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();
      final currentUser = _auth.currentUser;

      if (currentUser != null && orderDoc.exists) {
        final orderVendorId = orderDoc['vendorId'];
        final currentUserId = currentUser.uid;

        if (orderVendorId != currentUserId) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Invalid Order'),
                content: Text('This order is from another store.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.resumeCamera();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }
      }

      bool isPickedUp = orderDoc['isPickedUp'];
      if (isPickedUp) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Order has been picked up'),
              content: Text('This order has already been picked up.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.resumeCamera();
                  },
                ),
              ],
            );
          },
        );
      } else {
        final fullName = orderDoc['fullName'];
        final phone = orderDoc['phone'];
        final items = orderDoc['items'] as List;

        double totalPrice = 0.0;
        for (final item in items) {
          final quantity = item['quantity'];
          final productPrice = item['productPrice'];
          totalPrice += quantity * productPrice;
        }

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
                    Text('Ordered Customer: $fullName'),
                    Text('Phone: $phone'),
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
                        child: Text('OK'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          setState(() {
                            result = scanData;
                          });

                          // Set 'isPickedUp' value to true
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(orderId)
                              .update({'isPickedUp': true});

                          controller.resumeCamera();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
