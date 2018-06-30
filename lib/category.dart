import 'package:flutter/material.dart';
import 'package:kiosk/mainpage.dart';
import 'package:kiosk/product.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryItem extends StatelessWidget {
  final ProductInfo _info;

  CategoryItem(this._info);

  _launchProduct(context, int id) {
    print(id);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ProductPage(id, _info)),
    );
  }

  int _priceIntreg(double price) {
    return price.floor();
  }

  int _priceDecimals(double price) {
    return ((price - price.floor()) * 100).floor();
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 2.0,
      child: new Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: new InkWell(
          onTap: () {
            _launchProduct(context, _info.id);
          },
          child: new Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
            child: new Column(
              children: <Widget>[
                new Container(
                  child: new Container(
                    height: 100.0,
                    width: 160.0,
                    child: new Hero(
                      tag: _info.image,
                      child: new Image(
                        image: new NetworkImage(_info.image),
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Flexible(
                        child: new Text(
                          _info.name,
                          style: TextStyle(fontStyle: FontStyle.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                new Expanded(
                    child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Center(
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              _priceIntreg(_info.price).toString(),
                              style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                            new Column(
                              children: <Widget>[
                                new Text(
                                  _priceDecimals(_info.price).toString(),
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            new Text(
                              ' Lei',
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryPage extends StatefulWidget {
  final int categoryId;

  CategoryPage(this.categoryId);

  @override
  CategoryState createState() => CategoryState(categoryId);

  Future<List<ProductInfo>> loadState(int i) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";

    List<ProductInfo> data = new List<ProductInfo>();

    var jsonData;
    final String url =
        'https://www.handsoneducation.ro/api/rest/products?limit=40&category_id=';
    var httpClient = new HttpClient();
//    httpClient.findProxy = (Uri uri) => "PROXY 192.168.1.171:8888;";
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
        jsonData = JSON.decode(json);
        // Get the result list

        // Print the results.
        print('A:' + response.toString());
      } else {
        print('B:' + response.toString());
      }
    } catch (exception) {
      print(exception.toString());
    }

    jsonData.forEach((key, value) {
      print(key);
      print(value['name']);
      double _price = 0.0;
      if (value['final_price_with_tax'] != null)
        _price = value['final_price_with_tax'].toDouble();

      var item = new ProductInfo(
        id: int.parse(value['entity_id']),
        name: value['name'],
        sku: value['sku'],
        description: value['description'],
        image: value['image_url'],
        price: _price,
      );
      data.add(item);
    });

    return data;
  }

}

class CategoryState extends State<CategoryPage> {
  final int categoryId;

  CategoryState(this.categoryId);

  List<ProductInfo> values;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (values != null) {
      return new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: new Text("Produse in categorie"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {},
                child: new Icon(Icons.search),
              )
            ],
          ),
          body: new Center(
            child:  createWidget(context, values),

          ));

    }


    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: new Text("Produse in categorie"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {},
              child: new Icon(Icons.search),
            )
          ],
        ),
        body: new Center(
          child: new FutureBuilder(
            future: widget.loadState(widget.categoryId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else return createWidget(context, snapshot.data);
              }
            },
          ),
        ));
  }

  Widget createWidget(BuildContext context, List<ProductInfo> data) {
    values = data;

    return new GridView.count(
      crossAxisCount: 2,
      children: _buildItems(context, data),

    );

  }

  List<CategoryItem> _buildItems(BuildContext context, List<ProductInfo> data) {
    return data.map((info) => new CategoryItem(info)).toList();
  }

}
