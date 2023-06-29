import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:quicko/onboarding_screen.dart';
import 'package:quicko/provider/cart_provider.dart';
import 'package:quicko/provider/product_provider.dart';
import 'package:quicko/splash_screen.dart';
import 'package:quicko/vendor/views/auth/vendor_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'views/customers/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) {
        return ProductProvider();
      }),
      ChangeNotifierProvider(create: (_) {
        return CartProvider();
      })
    ],
    child: const MyApp(),
  ));
}

class InitialScreen extends StatefulWidget {

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    checkOnboardStatus();
  }
  void checkOnboardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOnboardShown = prefs.getBool('isOnboardShown') ?? false;

    if (isOnboardShown == false) {
      showOnboardScreen();
      prefs.setBool('isOnboardShown', true);
    } else {
      // Onboard ekranını gösterin ve değeri kaydedin

    }
  }

  void showOnboardScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Quicko',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'With Quicko Save Your Time',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 80),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 24,
                    offset: Offset(0,
                        5), // Gölgeyi yatay ve dikey olarak ayarlayabilirsiniz
                  ),
                ],
              ),
              child: ElevatedButton(
                child: Text(
                  'Customer Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen();
                  }));
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 24,
                    offset: Offset(0,
                        5), // Gölgeyi yatay ve dikey olarak ayarlayabilirsiniz
                  ),
                ],
              ),
              child: ElevatedButton(
                child: Text(
                  'Vendor Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return VendorAuthScreen();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Poppins-Bold',
        useMaterial3: true,
      ),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
