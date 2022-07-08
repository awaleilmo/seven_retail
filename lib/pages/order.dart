import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
          )
        ],
      ),
    );
  }
}
