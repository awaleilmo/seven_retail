import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seven_retail/pages/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/Configuration.dart';

class CartPage extends StatefulWidget{
  const CartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CartPage();

}

class _CartPage extends State<CartPage>{
  var datas = [];
  int qty = 1, total = 0;
  TextEditingController phone = TextEditingController();
  void starup() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('userLogin');
    final rawJsons2 = prefs.getString('order');
    var dataUser = rawJsons != null ? jsonDecode(rawJsons): [],
        dataOrder = rawJsons2 != null ? jsonDecode(rawJsons2): [],
        filter = [];
    for(int i =0; i < dataOrder.length; i++){
      if(dataOrder[i]['user_id'] == dataUser['id']){
        filter.add(dataOrder[i]);
        setState((){
          total += dataOrder[i]['total'] as int;
        });
      }
    }
    setState((){
      datas = filter;
      phone.text = dataUser['phone'].toString();
    });
  }

  void save() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('userLogin');
    final rawJsons2 = prefs.getString('order');
    final rawJsons3 = prefs.getString('bill');
    var dataUser = rawJsons != null ? jsonDecode(rawJsons): [],
        dataOrder = rawJsons2 != null ? jsonDecode(rawJsons2): [],
        dataBill = rawJsons3 != null ? jsonDecode(rawJsons3): [],
        filter = [];
    int id = 1;
    for(int i =0; i < dataOrder.length; i++){
      if(dataUser['id'] == dataOrder[i]['user_id']){
        filter.add(dataOrder[i]);
      }
    }
    for(int i  = 0; i < dataBill.length; i++){
      if(dataBill.length == i+1){
        id = dataBill[i]['id'] + 1;
      }
    }
    var data = {
      "id": id,
      "user_id": dataUser['id'],
      "table_no": "TL0$id${dataUser['phone']}",
      "order": filter,
      "total": total,
      "service": 1000,
      "tax": 2500,
      "grandtotal":total+1000+2500,
      "payment":''
    };
    Navigator.of(context).push(
      FadeRoute(page: Payment(datas: data))
    );
  }

  void addTotal(int id, int qty) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('userLogin');
    final rawJsons2 = prefs.getString('order');
    var dataUser = rawJsons != null ? jsonDecode(rawJsons): [],
        dataOrder = rawJsons2 != null ? jsonDecode(rawJsons2): [];
    int ttl = 0;
    for(int i =0; i < dataOrder.length; i++){
      if(dataOrder[i]['id'] == id ){
        dataOrder[i]['qty'] = qty;
        dataOrder[i]['total'] = qty * dataOrder[i]['barang']['harga'];
      }
      if(dataUser['id'] == dataOrder[i]['user_id']){
        ttl += dataOrder[i]['total'] as int;
      }
    }
    String raws = jsonEncode(dataOrder);
    prefs.setString('order', raws);
    setState((){
      total = ttl;
    });

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
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Cart"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(child: _body()),
    );

  }

  _body(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: phone,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 1.5, color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                      hintText: "Phone Number",
                    ),

                    enabled: false,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(width: 1.5, color: Colors.black38),
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Age",
                        ),
                        enabled: false,
                      ),),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Expanded(child: TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(width: 1.5, color: Colors.black38),
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Male",
                        ),
                        enabled: false,
                      ),),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 1.5, color: Colors.black38),
                          borderRadius: BorderRadius.circular(5)),
                      hintText: "Jakarta",
                    ),
                    enabled: false,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(width: 1.5, color: Colors.black38),
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Jakarta Timur",
                        ),
                        enabled: false,
                      ),),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Expanded(child: TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(width: 1.5, color: Colors.black38),
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Kebayoran",
                        ),
                        enabled: false,
                      ),),
                    ],
                  ),
                  const Text("Wajib unutk mengisi data diri sebelum melakukan order",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 10, color: ColorBased.error),
                  )
                ],
              ),
            ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),child: Text("Your Order", style: TextStyle(fontWeight: FontWeight.w600),),),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 0, right: 10),
          child: column(),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        TextButton(
            onPressed: (){
              save();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorBased.success,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start ,
                children: [
                  const Expanded(child: Text(
                    "Submit Order",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87,),
                  ),),
                  const Padding(padding: EdgeInsets.only(left: 15)),
                  Expanded(child: Text(
                    "Rp. ${formatter.format(total)}",
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87,),
                  ),),
                ],
              ),
            )
        ),
        const Text("Submited order cannot be canceled", textAlign: TextAlign.right, style: TextStyle(color: ColorBased.error, fontSize: 9), ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 15)),
      ],
    );
  }

  Column column() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: datas.map((val){
            return Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black45)
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(val['barang']['nama']),
                                Text("Rp. ${formatter.format(val['barang']['harga'] * val['qty'])}"),

                              ],
                            ),
                          )
                      ),
                      Expanded(
                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Image.asset(val['barang']['image'],
                                    width: 95,
                                    height: 95,),
                                ),
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(val['note']),
                          )
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, right: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed:((){
                                  if(val['qty'] > 0) {
                                    setState(() {
                                      val['qty'] -= 1;
                                      addTotal(val['id'], val['qty']);
                                    });
                                  }
                                }),
                                child: const Icon(Icons.remove_circle)
                            ),
                            const Padding(padding: EdgeInsets.only(left: 3)),
                            Text(
                              val['qty'].toString(),
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 3)),
                            TextButton(
                                onPressed:((){
                                  if(val['qty'] >= 0) {
                                    setState(() {
                                      val['qty'] += 1;
                                      addTotal(val['id'], val['qty']);
                                    });
                                  }
                                }),
                                child: const Icon(Icons.add_circle)
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );

          }).toList(),
        );
  }

}