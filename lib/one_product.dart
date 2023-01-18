import 'package:flutter/material.dart';

class OneProduct extends StatefulWidget {
  const OneProduct({super.key, required this.item});

  final Map item;

  @override
  State<OneProduct> createState() => _OneProductState();
}

class _OneProductState extends State<OneProduct> {
  late String url, title, description, category;
  late double price, rate;
  late int count;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    url = widget.item["image"];
    title = widget.item["title"];
    description = widget.item["description"];
    category = widget.item["category"];
    price = double.parse("${widget.item["price"]}");
    rate = double.parse("${widget.item["rating"]["rate"]}");

    count = int.parse("${widget.item["rating"]["count"]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("text")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
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
                      Image.network(
                        url,
                        width: double.infinity,
                        height: 200,
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(""),
                  Text("Price: $price", style: TextStyle(fontSize: 15)),
                  Text(""),
                  Text("Description: $description",
                      style: TextStyle(fontSize: 15)),
                  Text(""),
                  Text("Category: $category", style: TextStyle(fontSize: 15)),
                  Text(""),
                  Text("Count: $count", style: TextStyle(fontSize: 15)),
                  Text(""),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
