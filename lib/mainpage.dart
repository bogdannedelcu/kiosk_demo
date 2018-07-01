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
import 'package:carousel_slider/carousel_slider.dart';

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
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new CategoryPage(i)),
    );
  }

  goToCategorySearch(BuildContext context, String i) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";
    var data;
    String url =
        'https://www.handsoneducation.ro/api/rest/products?limit=40&filter%5B1%5D%5Battribute%5D=name&filter%5B1%5D%5Blike%5D=%25' +
            i.toString() +
            '%25';
    var httpClient = new HttpClient();
    var json = '';
//    httpClient.findProxy = (Uri uri) => "PROXY 192.168.1.171:8888;";
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    try {
      // Make the call
      var request = await httpClient.getUrl(Uri.parse(url));
      request.headers.add('Accept', 'application/json');
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        json = await response.transform(UTF8.decoder).join();
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

    if (json == '[]') {
      String url =
          'https://www.handsoneducation.ro/api/rest/products?limit=40&filter%5B1%5D%5Battribute%5D=sku&filter%5B1%5D%5Blike%5D=%25' +
              i.toString() +
              '%25';
      var httpClient = new HttpClient();
//    httpClient.findProxy = (Uri uri) => "PROXY 192.168.1.171:8888;";
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      try {
        // Make the call
        var request = await httpClient.getUrl(Uri.parse(url));
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
    }

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
        sku: value['sku'],
      );
      emptyList2.add(item);
    });

    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new CategoryPage(2)),
    );
  }

  _buildCategoryCard(int i) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";
    var data;
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
        sku: value['sku'],
      );
      emptyList2.add(item);
    });

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

  _launchProduct(context, int id, ProductInfo info) {
    print(id);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ProductPage(id, info)),
    );
  }

  _buildCategoryList(BuildContext context, int i) async {
    //var url = "https://www.handsoneducation.ro/api/rest/products";
    var data;
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
        sku: value['sku'],
      );
      emptyList2.add(item);
    });

    return new CarouselSlider(
      items: emptyList2.map((item) {
        return new GestureDetector(
          onTap: () {
            _launchProduct(context, item.id, item);
          },
          child: new Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              new Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                child: new Hero(
                  tag: item.image,
                  child: new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 0.0),
                    decoration: new BoxDecoration(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(0.0)),
                        image: new DecorationImage(
                            image: new NetworkImage(item.image),
                            fit: BoxFit.fitHeight)),
                  ),
                ),
              ),
              new Text(
                item.name,
                style: new TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        );
      }).toList(),
      viewportFraction: 1.0,
      aspectRatio: 1.0,
      autoPlay: true,
    );
  }

  _buildFutureCarousel(BuildContext context, int i) {
    return new FutureBuilder<dynamic>(
      future: _buildCategoryList(context, i), // a Future<String> or null
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
    );
  }

  _buildFutureLoader(BuildContext context, int i, String name) {
    return new Column(
      children: <Widget>[
        new Container(
          height: 10.0,
        ),
        new GestureDetector(
          onTap: () {
            goToCategory(context, i);
          },
          child: new Container(
              child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(
                  name,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                new Expanded(
                    child: new Text('Toate >  ',
                        textAlign: TextAlign.right,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0))),
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
      body: new Stack(
        children: [
          new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Expanded(
                child: new ListView(
                  itemExtent: 230.0,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: new Container(
                        color: Colors.white,
                        height: 200.0,
                        child: _buildFutureCarousel(context, 146),

                        /*Carousel(

                          boxFit: BoxFit.fitHeight,
                          images: [
                          ],
                        )*/
                      ),
                    ),
                    _buildFutureLoader(context, 102, 'Pentru bebelusi'),
                    _buildFutureLoader(context, 99, 'Instrumente muzicale'),
                    _buildFutureLoader(context, 105, 'Joc de rol'),
                    _buildFutureLoader(context, 96, 'Creativitate'),
                    _buildFutureLoader(context, 94, 'Jocuri de constructie'),
                    _buildFutureLoader(context, 110, 'Puzzle'),
                    _buildFutureLoader(context, 125, 'Carti'),
                  ],
                ),
              ),
            ],
          ),
          new Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4.0, 24.0, 4.0, 0.0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Expanded(
                      child: new Card(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                        elevation: 2.0,
                        child: new TextField(
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          keyboardType: TextInputType.text,
                          onSubmitted: (newValue) =>
                              goToCategorySearch(context, newValue),
                          decoration: new InputDecoration(
                              prefixIcon: new Icon(Icons.search),
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Cauta produse'),
                        ),
                      ),
                    ),
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
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
