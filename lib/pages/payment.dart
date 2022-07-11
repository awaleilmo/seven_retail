import 'package:flutter/material.dart';

class Payment extends StatefulWidget{
  const Payment({Key? key, required this.datas}) : super(key: key);

  final Map<String, dynamic> datas;
  @override
  State<Payment> createState() => _Payment();
}

class _Payment extends State<Payment>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(child: _body()),
    );
  }

  _body(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}