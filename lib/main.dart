import 'package:flojics/add_products.dart';
import 'package:flojics/all_products.dart';
import 'package:flojics/carts.dart';
import 'package:flojics/login.dart';
import 'package:flojics/result_search.dart';
import 'package:flojics/shop_car.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String token;
late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  token = prefs.getString("token") ?? "";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token == ""
          ? const Login(title: "Log in")
          : const MyHomePage(title: 'Welcome'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 1;
  FocusNode foc = FocusNode();
  Widget result = Text("no result");
  final myController = TextEditingController();
  late TextField textsearch = TextField(
      controller: myController,
      showCursor: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          isDense: true,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
          hintStyle: TextStyle(height: .8),
          hintText: 'Search'),
      keyboardType: TextInputType.url,
      focusNode: foc);
  void search() {
    setState(() {
      result = Result(search: myController.text);
      index = 3;
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textsearch,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: search,
              iconSize: 20,
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => new StatefulBuilder(
                      builder: (BuildContext context, setState) =>
                          NewProduct(title: ""))));
            },
            iconSize: 25,
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            )),
      ),
      body: Column(children: [
        Expanded(
            child: IndexedStack(
                index: index,
                children: [ShopCar(), AllProducts(), Carts(), result])),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          RawMaterialButton(
            onPressed: () {
              setState(() {
                index = 0;
              });
            },
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.shopping_cart,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                index = 1;
              });
            },
            padding: EdgeInsets.all(10),
            child: Icon(Icons.home),
          ),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                index = 2;
              });
            },
            padding: EdgeInsets.all(10),
            child: Icon(Icons.add_card),
          ),
        ])
      ]),
    );
  }
}
