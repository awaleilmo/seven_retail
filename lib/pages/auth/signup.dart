import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:seven_retail/pages/auth/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/Configuration.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  bool passwordVisible = false,
      loading = false,
      nameNot = false,
      emailNot = false,
      passNot = false,
      passCNot = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rawJsons = prefs.getString('dataUser') ?? '';
    List<dynamic> maps = jsonDecode(rawJsons); var news = [];
    int id = 1;
    for(int i =0; i < maps.length; i++){
      if(email.text == maps[i]["email"]){
        const snackBar = SnackBar(
            content: Text("email already exists"),
            backgroundColor: ColorBased.error,
            behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      news.add(maps[i]);
      id++;
    }
    var dataUser = {
        'id':id,
        'name': name.text,
        'email': email.text,
        'password': pass.text,
        'phone': phone.text,
      };
    news.add(dataUser);
    String jsonEnd = jsonEncode(news);
    prefs.setString('dataUser', jsonEnd);
    Alert(
      context: context,
      type: AlertType.success,
      desc: "Successfully created an account",
      buttons: [
        DialogButton(
          onPressed: ((){
            Navigator.of(context)
                .pushReplacement(FadeRoute(page: const SignInpage()));
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
        title: const Text("Register"),
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
                  "asset/image/register.png",
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                //Field Name
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Is Required";
                      }
                      return null;
                    },
                    controller: name,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.black38),
                          borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.account_circle,
                          color: ColorBased.primary),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: ColorBased.primary,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(7)),
                      hintText: "Name",
                    ),
                    style: const TextStyle(color: Colors.black54),
                    autofocus: false,
                  ),
                ),
                //Field Email
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Is Required";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    controller: email,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.black38),
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
                //Field Password
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Is Required";
                      }
                      if(value.length < 8){
                        return "Password must be atleast 8 characters long";
                      }
                      if(value.length > 20){
                        return "Password must be less than 20 characters";
                      }
                      return null;
                    },
                    controller: pass,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.black38),
                          borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.lock, color: ColorBased.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: ColorBased.primary,
                        ),
                        onPressed: () {
                          setState(() {
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
                //Field Password confirm
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Is Required";
                      }
                      if(value.length < 8){
                        return "Password must be atleast 8 characters long";
                      }
                      if(value.length > 20){
                        return "Password must be less than 20 characters";
                      }
                      if(value != pass.text){
                        return "Password is not the same";
                      }
                      return null;
                    },
                    controller: passC,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.5, color: Colors.black38),
                          borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.lock, color: ColorBased.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: ColorBased.primary,
                        ),
                        onPressed: () {
                          setState(() {
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
                      hintText: "Password Confirm",
                    ),
                    style: const TextStyle(color: Colors.black54),
                    autofocus: false,
                  ),
                ),
                //phone number
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Is Required";
                      }
                      return null;
                    },
                    controller: phone,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 1.5, color: Colors.black38),
                          borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.lock, color: ColorBased.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: ColorBased.primary,
                        ),
                        onPressed: () {
                          setState(() {
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
                      hintText: "Phone Number",
                    ),
                    style: const TextStyle(color: Colors.black54),
                    autofocus: false,
                  ),
                ),
                //button
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: MaterialButton(
                    height: 40,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        _register();
                      }
                    },
                    color: ColorBased.primary,
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacement(FadeRoute(page: const SignInpage()));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: ColorBased.primary),
                      ),
                    )
                  ],
                )
              ],
            )
        )
    );
  }
}
