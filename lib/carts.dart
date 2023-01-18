import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Carts extends StatefulWidget {
  const Carts({super.key});

  @override
  State<Carts> createState() => _CartsState();
}

class _CartsState extends State<Carts> {
  Map<dynamic, Map> all = Map();
  Future get_list(String s) async {
    Uri url = Uri.parse(s);
    var code = await http.get(url);
    var body = jsonDecode(code.body);
    for (int r = 0; r < int.parse("${body.length}"); r++) {
      var json = jsonDecode(code.body)[r]["products"];
      Map card = Map();
      for (var i in json) {
        var respons = await http.get(
            Uri.parse("https://fakestoreapi.com/products/${i["productId"]}"));
        card.addAll({i["productId"]: jsonDecode(respons.body)});
      }
      all.addAll({r: card});
    }

    return all;
  }

  late double total;
  late List keys;
  List<List> subkeys = [];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      // search
      Expanded(
          child: Container(
              child: FutureBuilder(
        future: get_list("https://fakestoreapi.com/carts/user/1"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            keys = all.keys.toList();
            total = 0;
            return ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: keys.length,
              itemBuilder: (context, ir) {
                subkeys.add(all[keys[ir]]!.keys.toList());
                return Card(
                    child: SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: all[keys[ir]]!.keys.toList().length,
                              itemBuilder: ((context, index) {
                                return Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Image.network(
                                        all[keys[ir]]![subkeys[ir][index]]
                                            ["image"],
                                        fit: BoxFit.fill,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                            text: all[keys[ir]]![subkeys[ir]
                                                [index]]["title"],
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text(
                                          "${all[keys[ir]]![subkeys[ir][index]]["price"]}"),
                                      width: 50,
                                    ),
                                    IconButton(
                                        onPressed: (() {
                                          setState(() {
                                            all[keys[ir]]!
                                                .remove(subkeys[ir][index]);
                                            subkeys[ir].removeAt(index);
                                          });
                                        }),
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                );
                              }))),
                      IconButton(
                          onPressed: (() {
                            setState(() {
                              all.remove(keys[ir]);
                              keys.removeAt(ir);
                              subkeys.removeAt(ir);
                            });
                          }),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ));
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )))
    ]));
  }
}
