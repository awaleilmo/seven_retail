import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seven_retail/config/Configuration.dart';
import 'package:seven_retail/pages/auth/signin.dart';
import 'package:seven_retail/pages/biling.dart';
import 'package:seven_retail/pages/billdetail.dart';
import 'package:seven_retail/pages/order.dart';
import 'package:seven_retail/pages/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectIndex = 0;
  bool logins = false;

  final PageStorageBucket bucket = PageStorageBucket();
  void _startup() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool log = prefs.getBool('login') ?? false;
    setState((){
      logins = log;
    });
  }
  void _navigateBottomBar(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  final List<Widget> _pages = [
    const OrderPage(),
    const BilingPage(),
    const ProfilePage(),
    const SignInpage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            body: _pages.elementAt(_selectIndex),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    rippleColor: Colors.grey[300]!,
                    hoverColor: Colors.grey[100]!,
                    gap: 8,
                    activeColor: ColorBased.primary,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.grey[100]!,
                    color: Colors.black,
                    tabs: const [
                      GButton(
                          icon: Icons.shopping_basket_outlined, text: "Order"),
                      GButton(icon: Icons.payment, text: "Bill"),
                      GButton(icon: Icons.account_circle, text: "Profile"),
                    ],
                    selectedIndex: _selectIndex,
                    onTabChange: _navigateBottomBar,
                  ),
                ),
              ),
            )),
        onWillPop: () async {
          bool keluar = false;
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("Anda akan keluar"),
                    content: const Text("Anda yakin untuk keluar?"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Ya",
                            style: TextStyle(color: Colors.black38)),
                        onPressed: () => exit(0),
                      ),
                      TextButton(
                        child: const Text("Tidak"),
                        onPressed: () {
                          Navigator.pop(context);
                          keluar = false;
                        },
                      ),
                    ],
                  ));
          return keluar;
        });
  }
}
