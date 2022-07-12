import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/Configuration.dart';
import 'home.dart';

class BillDetailPage extends StatefulWidget {
  const BillDetailPage({Key? key, required this.datas}) : super(key: key);
  final Map<String, dynamic> datas;
  @override
  State<BillDetailPage> createState() => _BillDetailPage();
}

class _BillDetailPage extends State<BillDetailPage> {
  var datas = {}, dataOrder =[];
  bool login = false;

  void startup() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('bill');
    final rawUser = prefs.getString('userLogin');
    final Logi = prefs.getBool('login');
    var dataBill = rawJsons != null ? jsonDecode(rawJsons) : [];
    var user = rawUser != null ? jsonDecode(rawUser) : [], news = [];
    for (int i = 0; i < dataBill.length; i++) {
      if (user['id'] == dataBill[i]['user_id']) {
        news.add(dataBill[i]);
      }
    }
    setState(() {
      datas = widget.datas;
      dataOrder = widget.datas['order'];
      login = Logi as bool;
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
            icon: const Icon(Icons.arrow_back_outlined),
            iconSize: 20.0,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
          title: Text("Bill ${datas['table_no']}"),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(child: _body(),)
    );
  }

  _body() {
    return login
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _padding(
                      const Text(
                        "Seven Retail",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      20.0,
                      20.0,
                      10.0,
                      2.0),
                  _padding(
                      const Text(
                        "Grand Indonesia",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      20.0,
                      20.0,
                      0.0,
                      7.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black45)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      children: [
                        const Expanded(
                            child: Text(
                          "Table No.",
                          textAlign: TextAlign.left,
                        )),
                        Expanded(
                            child: Text(
                          datas['table_no'].toString(),
                          textAlign: TextAlign.right,
                        ))
                      ],
                    ),
                  ),
                  _padding(
                      const Text(
                        "Your Order",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      20.0,
                      20.0,
                      20.0,
                      10.0),
                  Column(
                    children: dataOrder.map((cal) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black45)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cal['barang']['nama'].toString(),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          "Rp. ${formatter.format(cal['barang']['harga'])}",
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            cal['barang']['image'],
                                            scale: 12,
                                          )
                                        ])),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(cal['note'])),
                                Expanded(
                                    child: _padding(
                                        Text("X${cal['qty'].toString()}", textAlign: TextAlign.end,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                        0.0,
                                        40.0,
                                        10.0,
                                        5.0)
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  _padding(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(flex: 2, child: Text("Payment Method", style: TextStyle(fontWeight: FontWeight.w700),)),
                          Expanded(child: Text(datas['payment'])),
                        ],
                      ),
                      20.0,
                      20.0,
                      45.0,
                      20.0),
                  _padding(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(flex: 2, child: Text("Subtotal", style: TextStyle(fontWeight: FontWeight.w700),)),
                          Expanded(child: Text("Rp. ${formatter.format(datas['total'])}")),
                        ],
                      ),
                      20.0,
                      20.0,
                      10.0,
                      1.0),
                  _padding(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(flex: 2, child: Text("Service Charge", style: TextStyle(fontWeight: FontWeight.w700),)),
                          Expanded(child: Text("Rp. ${formatter.format(datas['service'])}")),
                        ],
                      ),
                      20.0,
                      20.0,
                      1.0,
                      1.0),
                  _padding(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(flex: 2, child: Text("Tax", style: TextStyle(fontWeight: FontWeight.w700),)),
                          Expanded(child: Text("Rp. ${formatter.format(datas['tax'])}")),
                        ],
                      ),
                      20.0,
                      20.0,
                      1.0,
                      1.0),
                  _padding(
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(flex: 2, child: Text("Grand Total", style: TextStyle(fontWeight: FontWeight.w700),)),
                          Expanded(child: Text("Rp. ${formatter.format(datas['grandtotal'])}")),
                        ],
                      ),
                      20.0,
                      20.0,
                      10.0,
                      15.0),
                ],
              )
            : const Center(
                child: Text("No Data"),
              );

  }

  _padding(chil, l, r, t, b) {
    return Padding(
      padding: EdgeInsets.only(left: l, right: r, top: t, bottom: b),
      child: chil,
    );
  }
}
