import 'dart:convert';

import 'package:flojics/all_products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopCar extends StatefulWidget {
  const ShopCar({super.key});

  @override
  State<ShopCar> createState() => _ShopCarState();
}

class _ShopCarState extends State<ShopCar> {
  late double total;

  late List keys;
  @override
  Widget build(BuildContext context) {
    keys = AllProducts.my_car_shop.keys.toList();
    total = 0;
    for (int i = 0; i < keys.length; i++) {
      total += AllProducts.my_car_shop[keys[i]]["price"];
    }
    // TODO: implement build
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: AllProducts.my_car_shop.length,
              itemBuilder: ((context, index) {
                return Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        AllProducts.my_car_shop[keys[index]]["image"],
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: AllProducts.my_car_shop[keys[index]]["title"],
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                          "${AllProducts.my_car_shop[keys[index]]["price"]}"),
                      width: 50,
                    ),
                    IconButton(
                        onPressed: (() {
                          setState(() {
                            AllProducts.my_car_shop.remove(keys[index]);
                            keys.removeAt(index);
                          });
                        }),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                );
              })),
        ),
        ElevatedButton(
          child: Text("Total ${total}\$"),
          onPressed: () {
            http.post(Uri.parse("https://fakestoreapi.com/carts"),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({
                  "userId": 2,
                  "date":
                      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                  "products": []
                }));
            setState(() {
              AllProducts.my_car_shop.clear();
            });
          },
        )
      ],
    );
  }
}
