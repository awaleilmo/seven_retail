import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seven_retail/config/Configuration.dart';
import 'package:seven_retail/pages/auth/signin.dart';
import 'package:seven_retail/pages/bill.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage> {
  List datas = [];
  bool iklan = false;
  final ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;
  var formatter = NumberFormat('#,##,000');

  @override
  Future<void> menus() async {
    if (!_loadingMore) {
      setState(() {
        _loadingMore = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final rawJsons = prefs.getString('data') ?? '';
      List<dynamic> jsson = jsonDecode(rawJsons);
      var data = jsson;
      setState(() {
        iklan = prefs.getBool('iklan')!;
        _loadingMore = false;
        datas.addAll(data);
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

  Future<void> _add() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool login = prefs.getBool('login') ?? false;
    Navigator.of(context).push(
      FadeRoute(page: login ? BillPage() : SignInpage()),
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
        body: Stack(
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
                : const Padding(padding: EdgeInsets.zero)
          ],
        ));
  }

  _list() {
    return ListView.builder(
      itemCount: datas == null ? 2 : datas.length,
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
                                image: AssetImage(datas[index]['image']),
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
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: SizedBox(
                              child: Text(
                                datas[index]['nama'],
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
                                datas[index]['desk'],
                                maxLines: 3,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        Positioned(
                          right: 12,
                          child: Text(
                            formatter.format(datas[index]['harga']).toString(),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: (() {
                                _add();
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
