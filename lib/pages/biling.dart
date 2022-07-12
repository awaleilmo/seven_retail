import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seven_retail/pages/billdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/Configuration.dart';
import 'home.dart';

class BilingPage extends StatefulWidget{
  const BilingPage({Key? key}) : super(key: key);

  @override
  State<BilingPage> createState() => _BilingPage();

}

class _BilingPage extends State<BilingPage>{
  var datas = [];

  void startup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('bill');
    final rawUser = prefs.getString('userLogin');
    var dataBill = rawJsons != null ? jsonDecode(rawJsons) : [];
    var user = rawUser != null ? jsonDecode(rawUser) : [], news = [];
    for (int i = 0; i < dataBill.length; i++) {
      if (user['id'] == dataBill[i]['user_id']) {
        news.add(dataBill[i]);
      }
    }
    setState((){
      datas = news;
    });
  }

  void open(val) async {
    Navigator.of(context).push(
      FadeRoute(page: BillDetailPage(datas:val))
    );
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
        body: SingleChildScrollView(child: _body(),)
    );
  }

  _body(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: datas.map((val){
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width * 0.95,
            child: MaterialButton(
              color: ColorBased.primary,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              onPressed: () {
                open(val);
              },
              child: Row(
                children: [
                  Expanded(flex: 2,
                    child: Text(val['table_no'],
                      style: const TextStyle(fontSize:18,fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(val['payment'],
                            style: const TextStyle(fontSize:16,fontWeight: FontWeight.bold, color: Colors.black54),
                          ),
                          Text("Rp. ${formatter.format(val['grandtotal'],)}",
                            style: const TextStyle(fontSize:16,fontWeight: FontWeight.bold, color: Colors.black54),)
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

}