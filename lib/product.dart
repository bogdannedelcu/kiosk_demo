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
import 'package:kiosk/imageView.dart';
import 'package:kiosk/productCard.dart';
import 'package:kiosk/utils.dart';
import 'package:kiosk/cart.dart';
import 'package:zoomable_image/zoomable_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductInfo {
  final int id;

  final String name;

  final String description;

  final String image;

  final String sku;

  final double price;

  double qty = 0.0;

  final List<String> images = new List<String>();

  ProductInfo(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.sku,
      this.qty});
}

class ProductPage extends StatefulWidget {
  final int _id;
  final ProductInfo _info = null;

  ProductPage(this._id, Null);

  @override
  ProductItemState createState() {
    return new ProductItemState(_info);
  }

  Future<ProductInfo> _getData(int id) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";
    var data;
    String url = 'https://www.handsoneducation.ro/api/rest/products/';
    var httpClient = new HttpClient();
//       httpClient.findProxy = (Uri uri) => "PROXY 192.168.1.171:8888;";
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    try {
      // Make the call
      var request = await httpClient.getUrl(Uri.parse(url + id.toString()));
      request.headers.add('Accept', 'application/json');
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonul = await response.transform(utf8.decoder).join();
        // Decode the json response
        data = json..decode(jsonul);
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
      price: double.tryParse(data['final_price_with_tax'].toString()),
      id: int.tryParse(data['entity_id'].toString()),
      sku: data['sku'],
    );

    debugPrint(prod.toString());

    prod.images.clear();
    prod.images.add(prod.image);

    try {
      // Make the call
      var request =
          await httpClient.getUrl(Uri.parse(url + id.toString() + '/images'));
      request.headers.add('Accept', 'application/json');
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var jsonul = await response.transform(utf8.decoder).join();
        // Decode the json response
        data = json.decode(jsonul);
        // Get the result list

        // Print the results.
        print('A:' + data.toString());


        data.forEach((value) {
          print('Image:   ' + value['url'].toString());

          if (value['url'] != prod.image) prod.images.add(value['url']);
        });
      } else {
        print('B:' + data.toString());
      }
    } catch (exception) {
      print(exception.toString());
    }

    return prod;
  }

  _launchProduct(context, int id) {
    print(id);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ProductPage(id, null)),
    );
  }

  ProductCard _buildCards(BuildContext context, int i) {
    return new ProductCard(LastSeen.queue.elementAt(i));
  }
}

class ProductItemState extends State<ProductPage> {
  var _expanded = false;
  ProductInfo values;

  ProductItemState(this.values);

  @override
  Widget build(BuildContext context) {
    if (values == null) {
      var futureBuilder = new FutureBuilder(
        future: widget._getData(widget._id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
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
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new CartPage()),
                );
              },
              icon: Icon(Icons.shopping_basket),

            )

          ],

        ),
        body: futureBuilder,
      );
    } else {
      return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text("informatii produs"),
          elevation: 0.0,
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new CartPage()),
                );
              },
              icon: Icon(Icons.shopping_basket),

            )

          ],
        ),
        body: new Builder(builder: (BuildContext context) {
          return createWidget(context, values);
        }),
      );
    }
  }

  Widget createWidget(BuildContext context, ProductInfo snapshot) {
    values = snapshot;

    LastSeen.push(values);

    return new SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height:220.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: CarouselSlider(
                    items: values.images.map((item) {
                      return new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ImageView(item)),
                          );
                        },
                        child: new Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            new Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 2.0),
                              child: new Hero(
                                tag: item,
                                child: new Container(
                                  margin: new EdgeInsets.symmetric(horizontal: 0.0),
                                  decoration: new BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(0.0)),
                                      image: new DecorationImage(
                                          image: new NetworkImage(item),
                                          fit: BoxFit.fitHeight)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    viewportFraction: 1.0,
                    aspectRatio: 1.0,
                    autoPlay: true,
                  ),
                ),
              ],
            ),
          ),

/*
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ImageView(values.image)),
              );
            },
            child: new Container(
              height: 200.0,
              child: new Hero(
                tag: values.image,
                child: new Image(
                  image: new NetworkImage(values.image),
                ),
              ),
            ),
          ),
  */
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Expanded(
                  child: new Text(
                    'In stoc',
                    style: new TextStyle(fontSize: 13.0, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                new Expanded(
                  child: new Text(
                    values.sku,
                    style: new TextStyle(fontSize: 13.0, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      priceIntreg(values.price).toString(),
                      style: new TextStyle(
                          fontSize: 25.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    new Column(
                      children: <Widget>[
                        new Text(
                          priceDecimals(values.price).toString(),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: new FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        final snackBar = SnackBar(
                            content: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              new Text('Produsul a fost adugat in cos!')
                            ]));

                        LastOrder.push(values);

                        Scaffold.of(context).showSnackBar(snackBar);
                      },
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
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Flexible(
                child: new GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: new Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: new Text.rich(
                      new TextSpan(
                        text: values.description
                            .replaceAll('\r', '')
                            .replaceAll('\t', '')
                            .replaceAll('&nbsp;', ' ')
                            .replaceAll('\n', '')
                            .replaceAll(new RegExp('<[^>]*>'), ''),
                      ),
                      textAlign: TextAlign.justify,
                      maxLines: _expanded ? 100 : 6,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: new Divider(
                color: Colors.black12,
                height: 2.0,
              ))
            ],
          ),
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: _showCards(context),
          ),
          new Container(
              height: 190.0,
              child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      LastSeen.queue.length > 8 ? 8 : LastSeen.queue.length,
                  itemBuilder: LastSeen.queue.isEmpty
                      ? (BuildContext context, int i) => new Text('empty')
                      : (BuildContext context, int i) {
                          if (i == 0) return new Container();

                          return new GestureDetector(
                              onTap: () => _launchProduct(
                                  context,
                                  LastSeen.queue.elementAt(i).id,
                                  LastSeen.queue.elementAt(i)),
                              child:
                                  new ProductCard(LastSeen.queue.elementAt(i)));
                        })),
        ],
      ),
    );
  }

  _showCards(BuildContext context) {
//    if (LastSeen.queue.length < 1)
//      return new Container();

    return new Text('Produse vizualizate recent',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0));
  }

  _launchProduct(context, int id, ProductInfo info) {
    print(id);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ProductPage(id, info)),
    );
  }
}
