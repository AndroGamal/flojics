import 'dart:convert';

import 'package:flojics/main.dart';
import 'package:flojics/sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});
  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool wait = false, chick = true;
  void login() async {
    setState(() {
      wait = true;
    });
    var response = await http.post(
        Uri.parse("https://fakestoreapi.com/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": nameController.text,
          "password": passwordController.text
        }));
    Map access_token = jsonDecode(response.body) as Map;
    await prefs.setString("token", access_token["token"]);
    setState(() {
      wait = false;
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => new StatefulBuilder(
            builder: (BuildContext context, setState) => MyHomePage(
                  title: widget.title,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Flojics',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: chick,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                CheckboxListTile(
                    title: Text(
                      "Show password",
                    ),
                    value: !chick,
                    onChanged: (value) {
                      setState(() {
                        chick = !(value as bool);
                      });
                    }),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: wait
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Login'),
                      onPressed: login,
                    )),
                Row(
                  children: <Widget>[
                    const Text('Does not have account?'),
                    TextButton(
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
//signup screen
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new StatefulBuilder(
                                    builder: (BuildContext context, setState) =>
                                        Sign_in(title: "Sign in"))));
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            )));
  }
}
