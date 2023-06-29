import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:quicko/controllers/auth_controller.dart';
import 'package:quicko/main.dart';
import 'package:quicko/utils/show_snackbar.dart';
import 'package:quicko/views/customers/auth/register_screen.dart';
import 'package:quicko/views/customers/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  late String email;
  late String password;
  bool _isLoading = false;

  _loginUsers() async {
    if (_formKey.currentState!.validate()) {
      bool isVendorEnrolled = await checkVendorEnrollment();
      if (isVendorEnrolled) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Account Creation'),
              content: Text(
                'This account was created for a vendor. Please use another email to create a customer account.',
              ),
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
      } else {
        String res = await _authController.loginUsers(email, password);
        if (res == 'success') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainScreen(),
            ),
          );
        } else {
          showSnack(context, res);
        }
      }
    } else {
      showSnack(context, 'Please Fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue.shade700,
            size: 48,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return InitialScreen();
              }),
            );
          },
        ),
        title: null,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Customer Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,

                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _loginUsers();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Need an account?',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerRegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkVendorEnrollment() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String currentUserId = currentUser.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .where('vendorId', isEqualTo: currentUserId)
          .get();
      return querySnapshot.docs.isNotEmpty;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final currentUserId = currentUser.uid;
      handleLogin(currentUserId);
    }
  }

  void handleLogin(String currentUserId) async {
    bool isVendorEnrolled = await checkVendorEnrollment();
    if (isVendorEnrolled) {
      FirebaseAuth.instance.signOut(); // Sign out the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Account Creation'),
            content: Text(
              'This account was created for a vendor. Please use another email to create a customer account.',
            ),
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
    } else {
      // Perform login action
      _loginUsers();
    }
  }
}
