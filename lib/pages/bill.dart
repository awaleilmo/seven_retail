import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/Configuration.dart';
import 'home.dart';

class BillPage extends StatefulWidget {
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPage();
}

class _BillPage extends State<BillPage>{
  var datas =[];
  void startup() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('bill');
    final rawUser = prefs.getString('userLogin');
    var dataBill = rawJsons != null ? jsonDecode(rawJsons) : [];
    var user = rawUser != null ? jsonDecode(rawUser) : [], news =[];
    for(int i=0; i < dataBill.length; i++){
      if(user['id'] == dataBill[i]['user_id']){
        news.add(dataBill[i]);
      }
    }
    setState((){
      datas = news;
    });
  }

  @override
  void initState() {
    startup();
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
          title: const Text("Bill"),
          backgroundColor: Colors.white,
        ),
        body: _body()

    );
  }

  _body(){
    return Column(
    children: datas.map((val){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _padding(const Text("Seven Retail",style: TextStyle(fontWeight: FontWeight.w700),), 20, 20, 10,2),
          _padding(const Text("Grand Indonesia",style: TextStyle(fontWeight: FontWeight.w400),), 20, 20, 0,7),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5),),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black45)
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                const Expanded(child: Text("Table No.", textAlign: TextAlign.left,)),
                Expanded(child: Text(val['table_no'], textAlign: TextAlign.right,))
              ],
            ),
          ),
          _padding(const Text("Seven Retail",style: TextStyle(fontWeight: FontWeight.w700),), 20, 20, 20,7),
        ],
      );
    }).toList(),
      );
  }

  _padding(chil, l, r, t, b){
    return Padding(
      padding: EdgeInsets.only(left: l, right: r, top: t, bottom: b),
      child: chil,
    );
  }
}