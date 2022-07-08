import 'package:flutter/material.dart';
import 'package:seven_retail/config/Configuration.dart';
import 'package:seven_retail/pages/bill.dart';
import 'package:seven_retail/pages/order.dart';
import 'package:seven_retail/pages/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  final List<Widget> _pages = [
    OrderPage(),
    BillPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari"),
      ),
      body: _pages[_selectIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: ColorBased.primary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(icon: Icons.shopping_basket_outlined, text: "Order"),
                GButton(icon: Icons.payment, text: "Bill"),
                GButton(icon: Icons.account_circle, text: "Profile"),
              ],
              selectedIndex: _selectIndex,
              onTabChange: _navigateBottomBar,
            ),
          ),
        ),
      )
    );
  }
}
