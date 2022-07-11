import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/Configuration.dart';
import 'home.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key? key, required this.datas}) : super(key: key);

  final Map<String, dynamic> datas;

  @override
  State<AddOrderPage> createState() => _AddOrderPage();
}

class _AddOrderPage extends State<AddOrderPage> {
  List<Map> modifier = [
    {"name": "Mie Besar", "isCheck": false},
    {"name": "Mie Kecil", "isCheck": false},
    {"name": "Nasi", "isCheck": false},
  ];
  TextEditingController notes = TextEditingController();
  int qty = 1;
  String total = '';

  @override
  void initState() {
    total = formatter.format(widget.datas['harga']);
    super.initState();
  }

  void addTotal(){
    int ttl = widget.datas['harga'] * qty;
    setState((){
      total = formatter.format(ttl);
    });
  }

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJson1 = prefs.getString('userLogin');
    final rawJson2 = prefs.getString('order');
    var users = jsonDecode(rawJson1!);
    var order = rawJson2 != null ? jsonDecode(rawJson2) : [], news = [];
    int? id = 1;
    for(int i  = 0; i < order.length; i++){
      if(order.length == i){
        id = (1 + order[i]['id']) as int?;
      }
    }
    var data = {
      "id": id,
      "user_id": users['id'],
      "id_barang": widget.datas['id'],
      "modifier": modifier,
      "note": notes.text,
      "qty": qty,
      "total": widget.datas['harga'] * qty
    };
    if(order.length > 0){
      order.add(data);
      news = order;
    }
    else{
      news = [data];
    }
    String raw = jsonEncode(news);
    prefs.setString('order', raw);
    Navigator.of(context).pushReplacement(
      FadeRoute(page: const MyHomePage())
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.datas['nama']),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(child: _body()),
    );
  }

  _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(widget.datas['image'].toString()),
                  fit: BoxFit.cover)),
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Positioned(
                  left: 20,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.datas['nama'],
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset.zero,
                                blurRadius: 10,
                              )
                            ]),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 3)),
                      Text(
                        widget.datas['desk'],
                        maxLines: 4,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset.zero,
                                blurRadius: 5,
                              )
                            ]),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        "Rp. ${formatter.format(widget.datas['harga'])}",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset.zero,
                                blurRadius: 10,
                              )
                            ]),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                    ],
                  )),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black12),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.view_list,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                    "Modfier",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                  children: modifier.map((hobby) {
                return Row(
                  children: [
                    Checkbox(
                        value: hobby["isCheck"],
                        onChanged: (bool? newValue) {
                          setState(() {
                            hobby["isCheck"] = newValue;
                          });
                        }),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      hobby['name'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                );
              }).toList())
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 15)),
        Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black12),
          child: Column(
            children: [
              Row(
                children: const [
                   Icon(
                    Icons.note_alt,
                    size: 30,
                  ),
                   Padding(padding: EdgeInsets.only(left: 5)),
                   Text(
                    "Notes",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              TextFormField(
                controller: notes,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.5, color: Colors.black38),
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ColorBased.primary,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(7)),
                  hintText: "Optional",
                ),
              )
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 15)),
        Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black12),
          child: Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed:((){
                      if(qty > 0) {
                        setState(() {
                          qty -= 1;
                          addTotal();
                        });
                      }
                    }),
                    child: const Icon(Icons.remove_circle)
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                    qty.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  TextButton(
                      onPressed:((){
                        if(qty >= 0) {
                          setState(() {
                            qty += 1;
                            addTotal();
                          });
                        }
                      }),
                      child: const Icon(Icons.add_circle)
                  ),
                ],
              ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 15)),
        TextButton(
            onPressed: (){
              save();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorBased.success,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  const Icon(
                    Icons.shopping_cart_rounded,
                    size: 20,
                    color: Colors.black87,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  const Text(
                    "Add to Basket",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87,),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15)),
                  const Text(
                    "|",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87,),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 15)),
                  Text(
                    "Rp. $total",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87,),
                  ),
                ],
              ),
            )
        )
      ],
    );
  }
}
