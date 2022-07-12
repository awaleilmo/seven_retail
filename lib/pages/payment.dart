import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/Configuration.dart';

class Payment extends StatefulWidget{
  const Payment({Key? key, required this.datas}) : super(key: key);

  final Map<String, dynamic> datas;
  @override
  State<Payment> createState() => _Payment();
}

class _Payment extends State<Payment>{
  var pay =[
    {"icon":Icons.account_balance_wallet, "name":"Gopay", "value":1},
    {"icon":Icons.credit_card, "name":"Credit Card / Debit Card", "value":2},
    {"icon":Icons.account_balance, "name":"Bank Transfer", "value":3},
    {"icon":Icons.payments, "name":"Shopee Pay", "value":4},
  ];
  int pilih = 1;

  void save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('userLogin');
    var dataUser = rawJsons != null ? jsonDecode(rawJsons): [],
        news =[];
    String? pyment = '';
    for(int i=0; i < pay.length; i++){
      if(pay[i]['value'] == pilih){
        pyment = pay[i]['nama'] as String?;
      }
    }
    var data = {
      "id": widget.datas['id'],
      "user_id": widget.datas['user_id'],
      "table_no": widget.datas['table_no'],
      "order": widget.datas['order'],
      "total": widget.datas['total'],
      "service": widget.datas['service'],
      "tax": widget.datas['tax'],
      "grandtotal":widget.datas['grandtotal'],
      "payment":widget.datas['payment']
    };
    print("ok");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: ()
            { Navigator.of(context).pop();}
           ,
        ),
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(child: _body()),
    );
  }

  _body(){
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Row(
            children: [
              Expanded(
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black26,
                    ),
                    child: Column(
                      children: const [
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Text("Online Payment", style: TextStyle(fontSize: 16),),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Icon(Icons.account_balance_wallet, size: 60,),
                      ],
                    ),
                  ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              Expanded(
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black26,
                    ),
                    child: Column(
                      children: const [
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Text("Pay at Cashier", style: TextStyle(fontSize: 16),),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Icon(Icons.money, size: 60,),
                      ],
                    ),
                  )
              )
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
          const Text("Select Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Column(
            children: pay.map((val){
              return Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black45)
                ),
                child: Row(
                  children: [
                    Icon(val['icon'] != null ? val['icon'] as IconData : Icons.account_balance_wallet),

                    const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Text(val['name'].toString(), textAlign: TextAlign.start,),

                    Expanded(child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          pilih != val['value'] ? Icons.check_box_outline_blank : Icons.check_box,
                          color: pilih == val['value'] ? ColorBased.primary : Colors.black45,
                        ),
                        onPressed: () {
                          setState((){
                            pilih = val['value'] as int;
                          });
                        },
                      ),
                    ))
                  ],
                ),
              );
            }).toList(),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
          Padding(padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10,),
          child: Row(
            children: [
              const Expanded(child: Text("Subtotal",textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w600),)),
              Expanded(child: Text("Rp. ${formatter.format(widget.datas['total'])}", textAlign: TextAlign.right,))
            ],
          ),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10,),
          child: Row(
            children: [
              const Expanded(child: Text("Service Charge",textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w600),)),
              Expanded(child: Text("Rp. ${formatter.format(widget.datas['service'])}", textAlign: TextAlign.right,))
            ],
          ),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10,),
          child: Row(
            children: [
              const Expanded(child: Text("Tax",textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w600),)),
              Expanded(child: Text("Rp. ${formatter.format(widget.datas['tax'])}", textAlign: TextAlign.right,))
            ],
          ),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10,),
          child: Row(
            children: [
              const Expanded(child: Text("Grand Total",textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w600),)),
              Expanded(child: Text("Rp. ${formatter.format(widget.datas['grandtotal'])}", textAlign: TextAlign.right,))
            ],
          ),
          ),
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
                      "Pay Now",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87,),
                    ),),
                    const Padding(padding: EdgeInsets.only(left: 15)),
                    Expanded(child: Text(
                      "Rp. ${formatter.format(widget.datas['grandtotal'])}",
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87,),
                    ),),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}