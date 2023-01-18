import 'dart:convert';

import 'package:flojics/one_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});
  static Map my_car_shop = Map();
  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  Future get_list(String s) async {
    Uri url = Uri.parse(s);
    var code = await http.get(url);
    return jsonDecode(code.body);
  }

  late AlertDialog _show;
  late BuildContext _control;
  void show(Image image, Map items) {
    _show = AlertDialog(
        content: Container(
          height: 325,
          width: 290,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              image
            ],
          ),
        ),
        contentPadding: EdgeInsets.all(1.0),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(_control).push(MaterialPageRoute(
                    builder: (BuildContext context) => new StatefulBuilder(
                        builder: (BuildContext context, setState) =>
                            OneProduct(item: items))));
                // Navigator.of(_control).pop();
              },
              icon: Icon(Icons.open_in_new_rounded)),
          IconButton(
              onPressed: () {
                AllProducts.my_car_shop.addAll({items["id"]: items});
                Navigator.of(_control).pop();
              },
              icon: Icon(Icons.add_shopping_cart)),
          IconButton(
              onPressed: () {
                Navigator.of(_control).pop();
              },
              icon: Icon(Icons.cancel))
        ],
        elevation: 10);
  }

  Widget item(Map items) {
    Image image = Image.network(
      items["image"],
      fit: BoxFit.fill,
      height: double.infinity,
      width: double.infinity,
    );
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          show(image, items);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                _control = context;
                return _show;
              });
        },
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 23),
                child: Container(
                  height: 325,
                  width: 290,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      image
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: Colors.black,
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 0), // changes position of shadow
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 50,
                  child: Center(
                      child: Text(
                    items["title"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      // search
      Expanded(
        child: Container(
          child: FutureBuilder(
            future: get_list("https://fakestoreapi.com/products?sort=desc"),
            builder: (context, AsyncSnapshot sn) {
              if (sn.hasData)
                return ListView.builder(
                    itemCount: sn.data.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return item(sn.data[i]);
                    });
              else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ),
      )
    ]));
  }
}
