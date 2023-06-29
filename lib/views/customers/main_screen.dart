import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quicko/views/customers/nav_screens/account_screen.dart';
import 'package:quicko/views/customers/nav_screens/cart_screen.dart';
import 'package:quicko/views/customers/nav_screens/home_screen.dart';
import 'package:quicko/views/customers/nav_screens/search_screen.dart';
import 'package:quicko/views/customers/nav_screens/store_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 2;
  List<Widget> _pages = [
    StoreScreen(),
    SearchScreen(),
    HomeScreen(),
    CartScreen(),
    AccountsScreen(),
  ];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      _pageIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: _selectPage,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pageIndex == 0 ? Colors.blue : Colors.white,
              ),
              padding: EdgeInsets.all(_pageIndex == 0 ? 12 : 8),
              child: SvgPicture.asset(
                'assets/icons/shop.svg',
                width: 20,
                color: _pageIndex == 0 ? Colors.white : Colors.black,
              ),
            ),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pageIndex == 1 ? Colors.blue : Colors.white,
              ),
              padding: EdgeInsets.all(_pageIndex == 1 ? 12 : 8),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 20,
                color: _pageIndex == 1 ? Colors.white : Colors.black,
              ),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pageIndex == 2 ? Colors.blue : Colors.white,
              ),
              padding: EdgeInsets.all(_pageIndex == 2 ? 16 : 8),
              child: Icon(
                CupertinoIcons.home,
                size: _pageIndex == 2 ? 30 : 20,
                color: _pageIndex == 2 ? Colors.white : Colors.black,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pageIndex == 3 ? Colors.blue : Colors.white,
              ),
              padding: EdgeInsets.all(_pageIndex == 3 ? 12 : 8),
              child: SvgPicture.asset(
                'assets/icons/cart.svg',
                width: 20,
                color: _pageIndex == 3 ? Colors.white : Colors.black,
              ),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pageIndex == 4 ? Colors.blue : Colors.white,
              ),
              padding: EdgeInsets.all(_pageIndex == 4 ? 12 : 8),
              child: SvgPicture.asset(
                'assets/icons/account.svg',
                width: 20,
                color: _pageIndex == 4 ? Colors.white : Colors.black,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: _pages,
      ),
    );
  }
}
