import 'dart:convert';

import 'package:flojics/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Sign_in extends StatefulWidget {
  const Sign_in({super.key, required this.title});
  final String title;

  @override
  State<Sign_in> createState() => _Sign_inState();
}

class _Sign_inState extends State<Sign_in> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fristController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController number = TextEditingController();

  bool wait = false;
  Future<void> login() async {
    var response = await http.post(
        Uri.parse("https://fakestoreapi.com/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": "mor_2314", "password": "83r5^_"}));
    Map access_token = jsonDecode(response.body) as Map;
    await prefs.setString("token", access_token["token"]);
  }

  void Sign_in() async {
    setState(() {
      wait = true;
    });
    var response =
        await http.post(Uri.parse("https://fakestoreapi.com/auth/Sign_in"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": emailController.text,
              "username": nameController.text,
              "password": passwordController.text,
              "name": {
                "firstname": fristController.text,
                "lastname": fristController.text
              },
              "address": {
                "city": city.text,
                "street": street.text,
                "number": number.text,
                "zipcode": '12926-3874',
                "geolocation": {"lat": '-37.3159', "long": '81.1496'}
              },
              "phone": phone.text
            }));
    await login();
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
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: fristController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'frist Name',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: lastController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'last Name',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
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
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: city,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'city',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: street,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'street',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: number,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'number',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: wait
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Sign in'),
                      onPressed: Sign_in,
                    )),
              ],
            )));
  }
}
