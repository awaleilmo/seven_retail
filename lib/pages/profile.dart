import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seven_retail/config/Configuration.dart';
import 'package:seven_retail/pages/auth/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  var datas = {};
  void starup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool("login");
    final userData = prefs.getString("userLogin");
    if (login == false) {
      Navigator.of(context).push(FadeRoute(page: const SignInpage()));
    }
    setState((){
      datas = jsonDecode(userData!);
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool("login");
    final userData = prefs.getString("userLogin");
    prefs.setBool('login', false);
    prefs.remove('userLogin');
    Navigator.of(context).pushReplacement(
      FadeRoute(page: const MyHomePage())
    );
  }

  @override
  void initState() {
    starup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 20.0,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                ScaleRoute(page: const MyHomePage()),
              );
            },
          ),
          elevation: 0,
          title: const Text("Profile"),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(78.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.black38,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID: ${datas['phone']}", style: const TextStyle(fontSize: 18),),
                          Text("Name: ${datas['name'].toString().toUpperCase()}", style: const TextStyle(fontSize: 15)),
                          Row(
                            children: const [
                              Text("Upgrade Security - Claim Point", style: TextStyle(fontSize: 12),),
                              Icon(Icons.warning, size: 12,color: ColorBased.error,)
                            ],
                          ),

                        ],
                      )
                  ),
                  Expanded(
                      child: IconButton(
                        alignment: Alignment.centerRight,
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          logout();
                        },
                      )
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: _body(),
        ));
  }

  _body(){
    return
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.star, color: Color.fromRGBO(124, 124, 27, 1), size: 100,),
                        Text("5/8", style: TextStyle(fontSize: 18),)
                      ],
                    )
                ),
                Expanded(
                    child: Column(
                      children: const [
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Text("Rewards", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        Padding(padding: EdgeInsets.only(top: 15.0)),
                        Text("Gold Level 1", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(124, 124, 27, 1)),),
                        Padding(padding: EdgeInsets.only(top: 20.0)),
                        Text("1", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                        Text("Start until", style: TextStyle(fontSize: 15,),),
                        Text("Next Reward", style: TextStyle(fontSize: 15,),),

                      ],
                    )
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 40.0, left: 20),
            child: Text("Rewards", textAlign: TextAlign.left,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
            ),
            Container(
              padding: const EdgeInsets.only(left: 0, top: 5),
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _reward(),
                  _reward(),
                  _reward(),
                  _reward(),
                  _reward(),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.only(top: 40.0, left: 20),
                child: Text("Promotions", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))
            ),
            Container(
              padding: const EdgeInsets.only(left: 0, top: 5),
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _promo(),
                  _promo(),
                  _promo(),
                  _promo(),
                  _promo(),
                ],
              ),
            )
          ],
        );
  }

  _reward(){
    return Container(
      width: 200,
      margin:const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage("asset/image/reward.jpeg"),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Upgrade Security", style: TextStyle(fontWeight: FontWeight.w400),),
          const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
          const Text("1 POINTS", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32),),
          const Text("time expiration 2:00:00:00", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12,),),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(124, 124, 27, 1)
              ),
              child: const Text("CLAIM", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 14,),),
            ),
          )
        ],
      ),
    );
  }

  _promo(){
    return Container(
      width: 200,
      margin:const EdgeInsets.only(left: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage("asset/image/promosi.jpeg"),
              fit: BoxFit.cover
          )
      ),
    );
  }

}
