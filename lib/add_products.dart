import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewProduct extends StatefulWidget {
  const NewProduct({super.key, required this.title});

  final String title;

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  var json;

  Future get_list(String s) async {
    Uri url = Uri.parse(s);
    var code = await http.get(url);
    json = jsonDecode(code.body);
    return json;
  }

  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController image = TextEditingController();
  late AlertDialog dialog;
  late BuildContext _control;
  dynamic method;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dialog = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(_control).pop();
          },
        ),
        ElevatedButton(
          child: Text("OK"),
          onPressed: () => method(),
        )
      ],
      content: ListView(children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: image,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'image',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: title,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'title',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'price',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: category,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'category',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: description,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'description',
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                title.text = "";
                image.text = "";
                description.text = "";
                price.text = "";
                category.text = "";

                method = () {
                  http.post(Uri.parse("https://fakestoreapi.com/products"),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode({
                        "title": title.text,
                        "price": price.text,
                        "description": description.text,
                        "image": image.text,
                        "category": category.text
                      }));

                  Navigator.of(_control).pop();
                };
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      _control = context;
                      return dialog;
                    });
              },
              iconSize: 20,
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      body: FutureBuilder(
          future: get_list("https://fakestoreapi.com/products?sort=desc"),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemExtent: 80,
                  itemCount: (json.length),
                  itemBuilder: ((context, index) {
                    return Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            json[index]["image"],
                            fit: BoxFit.fill,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                text: json[index]["title"],
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        IconButton(
                            onPressed: (() {
                              setState(() {
                                http.delete(Uri.parse(
                                    "https://fakestoreapi.com/products/${json[index]["id"]}"));
                                json.remove(index);
                                print(json);
                              });
                            }),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: (() {
                              setState(() {
                                title.text = "${json[index]["title"]}";
                                image.text = "${json[index]["image"]}";
                                description.text =
                                    "${json[index]["description"]}";
                                price.text = "${json[index]["price"]}";
                                category.text = "${json[index]["category"]}";
                                print("${json[index]}");
                                method = () {
                                  http.put(
                                      Uri.parse(
                                          "https://fakestoreapi.com/products/${json[index]["id"]}"),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: jsonEncode({
                                        "title": title.text,
                                        "price": price.text,
                                        "description": description.text,
                                        "image": image.text,
                                        "category": category.text
                                      }));
                                  Navigator.of(_control).pop();
                                };
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      _control = context;
                                      return dialog;
                                    });
                              });
                            }),
                            icon: Icon(
                              Icons.edit,
                            ))
                      ],
                    );
                  }));
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          })),
    );
  }
}
