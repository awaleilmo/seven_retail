import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:seven_retail/config/Configuration.dart';
import 'package:seven_retail/pages/auth/signup.dart';
import 'package:seven_retail/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seven Retail',
      theme: ThemeData(
        primarySwatch: ColorBased.primary,
      ),
      home: const SplashScreenPage(),
    );
  }
}

class SplashScreenPage extends StatefulWidget{
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>{
  bool autol = false;
  bool isLoading = false;
  String name = '';
  bool keluar = false;

  @override

  @override
  void initState() {
    super.initState();

    //startSplashScreen();
    autoLogIn();
  }

  void autoLogIn() async {
    // try {
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        var dataUser = [
          {
            'id':1,
            'name': 'admins',
            'email': 'admin@gmail.com',
            'password': 'admin1234',
          },
        ];
        var map = [
          {
            'id':1,
            'nama': 'Maecanse',
            'desk': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            'harga': 50000,
            'image':'asset/image/menu.jpg'
          },
          {
            'id':2,
            'nama': 'Makaroni',
            'desk': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            'harga': 43000,
            'image':'asset/image/menu.jpg'
          },
          {
            'id':3,
            'nama': 'Mahoni',
            'desk': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            'harga': 65000,
            'image':'asset/image/menu.jpg'
          },
          {
            'id':4,
            'nama': 'Manohara',
            'desk': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            'harga': 90000,
            'image':'asset/image/menu.jpg'
          },
          {
            'id':5,
            'nama': 'Manuk',
            'desk': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            'harga': 12000,
            'image':'asset/image/menu.jpg'
          },
          {
            'id':6,
            'nama': 'Maho Shoujo',
            'desk': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            'harga': 83000,
            'image':'asset/image/menu.jpg'
          }
        ];
        String rawJson = jsonEncode(map);
        String Rawuser = jsonEncode(dataUser);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final rawJsons = prefs.getString('dataUser') ?? '';
        prefs.setBool('iklan', true);
        if(rawJsons == ''){
          prefs.setString('data', rawJson);
          prefs.setString('dataUser', Rawuser);
        }
        print(rawJsons);
        // List<dynamic> maps = jsonDecode(rawJsons);
        bool? login = prefs.getBool('login');
        startSplashScreen();
        if (login == true) {
          isLoading = false;
          setState(() {
            autol = true;
          });
          return;
        }else{
          prefs.setBool('login', false);
          return;
        }
      }
    // } on TimeoutException catch (e) {
    //   Alert(
    //     context: context,
    //     type: AlertType.warning,
    //     title: "",
    //     desc: "Cek Koneksi Internet Anda.",
    //     closeFunction: () => exit(0),
    //     buttons: [
    //       DialogButton(
    //         onPressed: () => exit(0),
    //         width: 120,
    //         child: const Text(
    //           "Back",
    //           style: TextStyle(color: Colors.white, fontSize: 20),
    //         ),
    //       )
    //     ],
    //   ).show();
    // } on Error catch (e) {
    //   Alert(
    //     context: context,
    //     type: AlertType.error,
    //     title: "Terjadi Kesalahan",
    //     desc: "Cek Koneksi Internet Anda.",
    //     closeFunction: () => exit(0),
    //     buttons: [
    //       DialogButton(
    //         onPressed: () => exit(0),
    //         width: 120,
    //         child: const Text(
    //           "Back",
    //           style: TextStyle(color: Colors.white, fontSize: 20),
    //         ),
    //       )
    //     ],
    //   ).show();
    // }

  }

  startSplashScreen() async{
    var durasi = const Duration(seconds: 3);
    return Timer(durasi, (){
      Navigator.of(context).pushReplacement(
        ScaleRoute(page: const MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.10,
              child: Image.asset(
                "asset/image/LOGO-01.jpg",
                fit: BoxFit.fill,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            const Padding(padding: EdgeInsets.only(top: 25)),
            LoadingProgress()
          ],
        ),
      ),
    );
  }

}