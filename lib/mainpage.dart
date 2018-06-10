import 'package:flutter/material.dart';
import 'package:kiosk/category.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiosk/cart.dart';
import 'package:kiosk/product.dart';
import 'package:kiosk/productCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatelessWidget {
  MainPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  goToCategory(BuildContext context, int i) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";
    var data;
    final String url =
        'https://www.handsoneducation.ro/api/rest/products?limit=40&category_id=';
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

  _buildCategoryCard(int i) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";
    var data;
    final String url =
        'https://www.handsoneducation.ro/api/rest/products?limit=40&category_id=';
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

    _launchProduct(context, int id, ProductInfo info) {
      print(id);
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new ProductPage(id, info)),
      );
    }

    return new Container(
        height: 190.0,
        child: new ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: emptyList2.length > 8 ? 8 : emptyList2.length,
            itemBuilder: emptyList2.isEmpty
                ? (BuildContext context, int i) => new Text('empty')
                : (BuildContext context, int i) {
                    return new GestureDetector(
                        onTap: () => _launchProduct(
                            context,
                            emptyList2.elementAt(i).id,
                            emptyList2.elementAt(i)),
                        child: new ProductCard(emptyList2.elementAt(i)));
                  }));
  }

  _buildFutureLoader(BuildContext context, int i, String name) {
    return new Column(
      children: <Widget>[
        new Container(
          height: 10.0,
        ),
        new GestureDetector(
          onTap: (){goToCategory(context, i);},
          child: new Container(

              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(

                  mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                new Text(name),
                new Expanded(

                    child: new Text('Toate >  ', textAlign: TextAlign.right,)),
            ],
          ),
              )),
        ),
        new FutureBuilder<dynamic>(
          future: _buildCategoryCard(i), // a Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return new Text('no network');
              case ConnectionState.waiting:
                return new Text('...');
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return snapshot.data;
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
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
                  _buildFutureLoader(context, 146, 'Copii mici'),
                  _buildFutureLoader(context, 94, 'Jocuri de constructie'),
                  _buildFutureLoader(context, 96, 'Creativitate'),
                  _buildFutureLoader(context, 99, 'Instrumente muzicale'),
                  _buildFutureLoader(context, 102, 'Pentru bebelusi'),
                  _buildFutureLoader(context, 105, 'Joc de rol'),
                  _buildFutureLoader(context, 110, 'Puzzle'),
                  _buildFutureLoader(context, 125, 'Carti'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
