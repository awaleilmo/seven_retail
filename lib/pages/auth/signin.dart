import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:seven_retail/config/Configuration.dart';
import 'package:seven_retail/pages/auth/signup.dart';
import 'package:seven_retail/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInpage extends StatefulWidget {
  const SignInpage({Key? key}) : super(key: key);

  @override
  State<SignInpage> createState() => _SignInpage();
}

class _SignInpage extends State<SignInpage> {
  bool passwordVisible = false;
  bool loading = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('dataUser') ?? '';
    List<dynamic> maps = jsonDecode(rawJsons); var myData = [];
    for(int i=0; i < maps.length; i++){
      if(maps[i]["email"] == email.text){
        if(maps[i]["password"] == pass.text){
          myData.add(maps[i]);
          String JsonEncode = jsonEncode(maps[i]);
          prefs.setString("userLogin", JsonEncode);
          prefs.setBool("login", true);
        }else{
          const snackBar = SnackBar(
            content: Text("Password wrong"),
            backgroundColor: ColorBased.error,
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
      }
    }
    if(myData.isEmpty){
      const snackBar = SnackBar(
        content: Text("Email not found"),
        backgroundColor: ColorBased.error,
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    Alert(
      context: context,
      type: AlertType.success,
      desc: "Welcome, ${myData[0]["name"]}",
      buttons: [
        DialogButton(
          onPressed: ((){
            Navigator.of(context)
                .pushReplacement(FadeRoute(page: const MyHomePage()));
          }),
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Login"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "asset/image/login.png",
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Is Required";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1.5, color: Colors.black38),
                        borderRadius: BorderRadius.circular(30)),
                    prefixIcon: const Icon(Icons.account_circle,
                        color: ColorBased.primary),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: ColorBased.primary,
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(7)),
                    hintText: "Email",
                  ),
                  style: const TextStyle(color: Colors.black54),
                  autofocus: false,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  controller: pass,
                  obscureText: !passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Is Required";
                    }
                    if(value.length < 8){
                      return "Password must be at least 8 characters long";
                    }
                    if(value.length > 20){
                      return "Password must be less than 20 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1.5, color: Colors.black38),
                        borderRadius: BorderRadius.circular(30)),
                    prefixIcon: const Icon(Icons.lock,
                        color: ColorBased.primary),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: ColorBased.primary,),
                      onPressed: (){
                        setState((){
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: ColorBased.primary,
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(7)),
                    hintText: "Password",
                  ),
                  style: const TextStyle(color: Colors.black54),
                  autofocus: false,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: MaterialButton(
                  height: 40,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: ((){
                    if(_formKey.currentState!.validate()){
                      _login();
                    }
                  }),
                  color: ColorBased.primary,
                  child: const Text("Login", style: TextStyle(fontSize:16, color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 100),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No Account?"),
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).push(
                          FadeRoute(page: const SignUpPage())
                      );
                    },
                    child: const Text("Create One", style: TextStyle(color: ColorBased.primary),),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
