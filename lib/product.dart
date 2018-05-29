import 'package:flutter/material.dart';
import 'package:kiosk/mainpage.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_advanced_networkimage/zoomable_widget.dart';
import 'package:flutter_advanced_networkimage/transition_to_image.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:kiosk/lastSeen.dart';

class ProductInfo {
  final int id;

  final String name;

  final String description;

  final String image;

  final double price;

  ProductInfo({this.id, this.name, this.description, this.image, this.price});
}

class ProductItem extends StatefulWidget {
  final int _id;

  ProductItem(this._id);

  @override
  ProductItemState createState() {
    return new ProductItemState();
  }

  Future<ProductInfo> _getData(int id) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";
    var data;
    final String url = 'https://www.handsoneducation.ro/api/rest/products/';
    var httpClient = new HttpClient();
    //   httpClient.findProxy = (Uri uri) => "PROXY 192.168.1.108:8888;";
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    try {
      // Make the call
      var request = await httpClient.getUrl(Uri.parse(url + id.toString()));
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

    var prod = new ProductInfo(
      name: data['name'],
      description: data['description'],
      image: data['image_url'],
      price: data['final_price_with_tax'],
      id: int.parse(data['entity_id']),
    );

    LastSeen.push(prod);

    return prod;
  }


  _launchProduct(context, int id) {
    print(id);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ProductItem(id)),
    );
  }

  ProductCard _buildCards(BuildContext context, int i) {
    return new ProductCard(LastSeen.queue.elementAt(i));
  }
}

class ProductItemState extends State<ProductItem> {

  var _expanded = false;
  ProductInfo values = null;

  @override
  Widget build(BuildContext context) {

    if (values == null){
      var futureBuilder = new FutureBuilder(
        future: widget._getData(widget._id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new CircularProgressIndicator();
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return createWidget(context, snapshot.data);
          }
        },
      );
      return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text("informatii produs"),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: futureBuilder,
      );

    }
    else {
      return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text("informatii produs"),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: createWidget(context, values),
      );


    }



  }

  Widget createWidget(BuildContext context, ProductInfo snapshot) {
    values = snapshot;

    return new SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.network(
                values.image,
                height: 200.0,
              ),
            ],
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    values.name,
                    style: new TextStyle(fontSize: 20.0),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            padding: const EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Text(
                    'In stoc',
                    style: new TextStyle(fontSize: 13.0, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      _priceIntreg(values.price).toString(),
                      style: new TextStyle(
                          fontSize: 25.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    new Column(
                      children: <Widget>[
                        new Text(
                          _priceDecimals(values.price).toString(),
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    new Text(
                      ' Lei',
                      style: new TextStyle(
                          fontSize: 25.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new Container(
                  padding: EdgeInsets.all(8.0),
                  child: new FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      color: Colors.indigo,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            child: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                          new Text(
                            '  Adauga in cos',
                            style: new TextStyle(
                                fontSize: 21.0, color: Colors.white),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Flexible(
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    child: new Text(
                      values.description
                          .replaceAll('<p>', '')
                          .replaceAll('</p>', ''),
                      textAlign: TextAlign.justify,
                      maxLines: _expanded ? 100: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Row(
            children: <Widget>[
              new Flexible(
                  child: new Divider(
                    color: Colors.black12,
                    height: 2.0,
                  ))
            ],
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text('Produse vizualizare recent',
                style:
                new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),
          ),
          new Container(
              height: 180.0,
              child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                  LastSeen.queue.length > 8 ? 8 : LastSeen.queue.length,
                  itemBuilder: LastSeen.queue.isEmpty
                      ? (BuildContext context, int i) => new Text('empry')
                      : (BuildContext context, int i) => new GestureDetector(
                      onTap: () => _launchProduct(context, LastSeen.queue.elementAt(i).id),
                      child:
                      new ProductCard(LastSeen.queue.elementAt(i))))),
        ],
      ),
    );
  }

  _launchProduct(context, int id) {
    print(id);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ProductItem(id)),
    );
  }

}

int _priceIntreg(double price) {
  return price.floor();
}

int _priceDecimals(double price) {
  return ((price - price.floor()) * 100).floor();
}

class ProductCard extends StatefulWidget {
  final ProductInfo _info;

  ProductCard(this._info);

  @override
  ProductCardState createState() {
    return new ProductCardState();
  }
}

class ProductCardState extends State<ProductCard> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Card(
      elevation: 8.0,
      child: new Container(
        height: 170.0,
        width: 120.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              height: 120.0,
              width: 120.0,
              child: new Image.network(
                widget._info.image,
                width: 120.0,
                fit: BoxFit.contain,
              ),
            ),
            new Container(
                height: 30.0,
                width: 120.0,
                child: new Text(
                  widget._info.name,
                  style: new TextStyle(fontSize: 10.0),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                )),
            new Expanded(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Center(
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        _priceIntreg(widget._info.price).toString(),
                        style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      new Column(
                        children: <Widget>[
                          new Text(
                            _priceDecimals(widget._info.price).toString(),
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
            )),
          ],
        ),
      ),
    );
  }
}
