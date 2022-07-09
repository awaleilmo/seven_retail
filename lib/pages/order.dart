import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seven_retail/config/Configuration.dart';
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

  Future<Null> _iklanClose() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('iklan', false);
  }

  Future<Null> _refreshMenu() async {
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

  @override
  void initState() {
    super.initState();

    menus();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) ;
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
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(144.0),
          // ),
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
                      TextButton(
                        child: Container(
                          height: 30,
                          width: 30,
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: MediaQuery.of(context).size.height * 0.60,
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
          return InkWell(
            onTap: () {
              // Navigator.push(context, SlideRightRoute(page: ArtikelPage(
              //     id: Peng[index]['id'],
              //     judul: Judul = 'Pojok Warta LH',
              //     tipe: 1)));
              print('ok');
            },
            child: Container(
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
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: SizedBox(
                            child: Text(
                              datas[index]['nama'],
                              maxLines: 2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: SizedBox(
                            child: Text(
                              datas[index]['desk'],
                              maxLines: 2,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          formatter.format(datas[index]['harga']).toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        TextButton(
                            onPressed: (() {}),
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
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
      controller: _scrollController,
    );
  }
}
