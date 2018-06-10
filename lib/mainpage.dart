import 'package:flutter/material.dart';
import 'package:kiosk/category.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiosk/cart.dart';
import 'package:kiosk/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MainPageState createState() => new _MainPageState();
}



class _MainPageState extends State<MainPage> {

  Future pickImage() async {

    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new CartPage()),
    );



  }


  goToCategory(int i) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";
    var data;
    final String url = 'https://www.handsoneducation.ro/api/rest/products?limit=40&category_id=';
    var httpClient = new HttpClient();
//    httpClient.findProxy = (Uri uri) => "PROXY 192.168.1.108:8888;";
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    try {
      // Make the call
      var request = await httpClient.getUrl(Uri.parse(url + i.toString()));
      request.headers.add('Accept', 'application/json');
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        // Decode the json response
        data = JSON.decode(json);
        // Get the result list

        // Print the results.
        print('A:' + response.toString());
      } else {
        print('B:' + response.toString());
      }
    } catch (exception) {
      print(exception.toString());
    }
    var emptyList2 = List<ProductInfo>();

    data.forEach((key, value) {
      print(key);
      print(value['name']);
      double _price = 0.0;
      if (value['final_price_with_tax'] != null)
        _price = value['final_price_with_tax'].toDouble();

      var item = new ProductInfo(
        id: int.parse(value['entity_id']),
        name: value['name'],
        description: value['description'],
        image: value['image_url'],
        price: _price,
      );
      emptyList2.add(item);
    });


    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new CategoryPage(emptyList2)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(

        title: new TextField(
          decoration:
          new InputDecoration.collapsed(hintText: 'Cauta in magazin'),
        ),
      ),
      body: new SingleChildScrollView(

        child: new Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: <Widget>[
/*            new FlatButton(
              color: Colors.greenAccent,
              onPressed: () {
                pickImage();
              },
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.category),
                    new Text('Shop by category'),
                  ]),
            ),*/
            new Container(
              height: 500.0,
              child: new ListView(


                children: <Widget>[
                  new ListTile(
                    title: new Text("Jocuri de constructie"),
                    onTap: () {goToCategory(94);},
                  ),
                  new ListTile(
                    title: new Text("Creativitate"),
                    onTap: () {goToCategory(96);},
                  ),
                  new ListTile(
                    title: new Text("Arta plastica si mestesug"),
                    onTap: () {goToCategory(97);},
                  ),
                  new ListTile(
                    title: new Text("Instrumente muzicale"),
                    onTap: () {goToCategory(99);},
                  ),
                  new ListTile(
                    title: new Text("Jucarii pentru bebelusi"),
                    onTap: () {goToCategory(102);},
                  ),
                  new ListTile(
                    title: new Text("Papusi si joc de rol"),
                    onTap: () {goToCategory(105);},
                  ),
                  new ListTile(
                    title: new Text("Jocuri si puzzle"),
                    onTap: () {goToCategory(110);},
                  ),
                  new ListTile(
                    title: new Text("Carti"),
                    onTap: () {goToCategory(125);},
                  ),
                ],
              ),
            ),
            new Card(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Flexible(
                    flex: 1,
                    child: new MaterialButton(
                      height: 60.0,
                      onPressed: () {
                        goToCategory(94);
                      },
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/vandute.png'),
                          new Padding(
                            padding: const EdgeInsets.symmetric(vertical:4.0),
                            child: Text(
                              'Cele mai vandute',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Flexible(
                    flex: 1,
                    child: new MaterialButton(
                        height: 60.0,
                        onPressed: () {
                          goToCategory(97);
                        },
                        child: new Column(
                          children: <Widget>[
                            Image.asset('assets/dolar.png'),
                            Text(
                              'De construit',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ),
                  new Flexible(
                    flex: 1,
                    child: new MaterialButton(
                        height: 60.0,
                        onPressed: () {
                          goToCategory(108);
                        },
                        child: new Column(
                          children: <Widget>[
                            Image.asset('assets/resigilate.png'),
                            new Text(
                              'Resigilate',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
