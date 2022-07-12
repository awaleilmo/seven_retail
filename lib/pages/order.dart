import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seven_retail/config/Configuration.dart';
import 'package:seven_retail/pages/auth/signin.dart';
import 'package:seven_retail/pages/billdetail.dart';
import 'package:seven_retail/pages/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addOrder.dart';
import 'home.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage> {
  var datas = [], dataOrder = [];
  int totalOrder = 0;
  bool iklan = false, orderan = false;
  final ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;

  @override
  Future<void> menus() async {
    if (!_loadingMore) {
      setState(() {
        _loadingMore = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final rawMenu = prefs.getString('data') ?? '';
      var jsson = jsonDecode(rawMenu);
      bool? login = prefs.getBool('login');
      final rawUser = prefs.getString('userLogin');
      final rawOrder = prefs.getString('order');
      int length = 0;
      var user = rawUser != null ? jsonDecode(rawUser) : [];
      var order = rawOrder != null ? jsonDecode(rawOrder) : [];
      for(int i = 0; i < order.length; i++){
        if(order[i]['user_id'] == user['id']){
          length++;
        }
      }

      setState(() {
        if(login == true && length > 0){
          orderan = true;
          dataOrder = order;
          for(int i =0; i < order.length; i++){
            totalOrder += (order[i]['total'] ?? 0) as int;
          }
        }
        iklan = prefs.getBool('iklan')!;
        _loadingMore = false;
        datas = jsson;
      });
    }
  }

  Future<void> _iklanClose() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('iklan', false);
  }

  Future<void> _refreshMenu() async {
    if (!_loadingMore) {
      setState(() {
        _loadingMore = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final rawJsons = prefs.getString('data') ?? '';
      List<dynamic> jsson = jsonDecode(rawJsons);
      var data = jsson;
      setState(() {
        _loadingMore = false;
        datas = data;
      });
    }
  }

  Future<void> _add(namaData) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login = prefs.getBool('login') ?? false;
    Navigator.of(context).push(
      FadeRoute(page: login ? AddOrderPage(datas:namaData) : const SignInpage()),
    );
  }

  @override
  void initState() {
    super.initState();

    menus();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent);
    });
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
          title: const Text("Order"),
          backgroundColor: Colors.white,
        ),
        body: _body()

    );
  }

  _body(){
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("asset/image/header.jpg"),
                      fit: BoxFit.cover)),
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: const [
                  Positioned(
                      left: 20,
                      bottom: 30,
                      child: Text(
                        "Seven Retail",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset.zero,
                                blurRadius: 7,
                              )
                            ]),
                      )),
                  Positioned(
                    left: 20,
                    bottom: 10,
                    child: Text(
                      "Grand Indonesia",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset.zero,
                              blurRadius: 7,
                            )
                          ]),
                    ),
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Expanded(
              child: RefreshIndicator(
                child: _list(),
                onRefresh: _refreshMenu,
              ),
            ),
            orderan ? const Padding(padding: EdgeInsets.only(top: 30)) : const Padding(padding: EdgeInsets.zero),
          ],
        ),
        iklan
            ? Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 140)),
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.65, bottom: 2),
              child: TextButton(
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    iklan = false;
                    _iklanClose();
                  });
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Image.asset(
                "asset/image/iklan.jpg",
                fit: BoxFit.fill,
              ),
            )
          ],
        )
            : const Padding(padding: EdgeInsets.zero),
        orderan ?
        Positioned(
            bottom: 5,
            child:TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  FadeRoute(page: const CartPage())
                );
              },
              style: TextButton.styleFrom(
                primary: Colors.black87
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: ColorBased.success,
                    borderRadius: BorderRadius.circular(10)
                ),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_basket),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                            "Order Quantity \n${dataOrder.length} item(s)"
                        )
                      ],
                    ),
                    Expanded(
                      child: Text(
                        "Rp. ${formatter.format(totalOrder)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    )

                  ],
                ),
              ),
            )
        ) : const Text(''),


      ],
    );
  }

  _list() {
    return ListView.builder(
      itemCount: datas.isEmpty ? 0 : datas.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        if (index == datas.length) {
          return LoadingProgress();
        } else {
          return Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  verticalDirection: VerticalDirection.up,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            image: DecorationImage(
                                image: AssetImage(datas[index]['image'] ?? 'asset/image/menu.jpg'),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                    ),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: SizedBox(
                              child: Text(
                                datas[index]['nama'] ?? 'ok',
                                maxLines: 2,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: SizedBox(
                              child: Text(
                                datas[index]['desk'] ?? 'oks',
                                maxLines: 4,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Text(
                            "Rp. ${formatter.format(datas[index]['harga'] ?? 0)}",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: (() {
                                _add(datas[index]);
                              }),
                              child: Container(
                                height: 20,
                                width: 40,
                                alignment: AlignmentDirectional.center,
                                decoration: BoxDecoration(
                                    color: ColorBased.primary,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  "Add",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
        }
      },
      controller: _scrollController,
    );
  }
}
