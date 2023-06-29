import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quicko/views/customers/nav_screens/cart_screen.dart';

class WelcomeText extends StatefulWidget {
  const WelcomeText({
    Key? key,
  }) : super(key: key);

  @override
  _WelcomeTextState createState() => _WelcomeTextState();
}

class _WelcomeTextState extends State<WelcomeText> {
  int itemCount = 0; // Eklenen ürün sayısı

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'How Can I Help You?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            child: Stack(
              children: [
                Container(
                  child: SvgPicture.asset(
                    'assets/icons/cart.svg',
                    width: 30,
                  ),
                ),
                if (itemCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        itemCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bu fonksiyonu çağırarak ürün sayısını güncelleyebilirsiniz
  void updateItemCount(int count) {
    setState(() {
      itemCount = count;
    });
  }
}
