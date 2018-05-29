import 'package:flutter/material.dart';
import 'package:kiosk/category.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class Info {

  final int id;

  final String name;

  final String description;

  final String image;

  final double price;

  Info({this.id, this.name, this.description, this.image, this.price});
}

class _MainPageState extends State<MainPage> {
  int _counter = 0;
  var _image = new Image.network(
      'https://www.handsoneducation.ro/media/wysiwyg/iStock_000048505076XXX_457x367.jpg');

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter--;
    });
  }

  Future pickImage() async {
    /*
    var image = new Image.network(
        'https://reges.inspectiamuncii.ro/DefaultCaptcha/Generate?t=');

    setState(() {
      _image = image;
    });
    */



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
    var emptyList2 = List<Info>();

    data.forEach((key, value)  {

      print(key);
      print(value['name']);
      double _price = 0.0;
      if (value['final_price_with_tax'] != null)
        _price = value['final_price_with_tax'].toDouble();

      var item = new Info(
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        title: new TextField(
          decoration:
          new InputDecoration.collapsed(hintText: 'Cauta in magazin'),
        ),
      ),
      drawer: new Drawer(
        child: _image,
      ),
      body: new SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _image,
            new FlatButton(
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
                      height: 80.0,
                      onPressed: () {
                        goToCategory(94);
                      },
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/vandute.png'),
                          Text(
                            'Cele mai vandute',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Flexible(
                    flex: 1,
                    child: new MaterialButton(
                        height: 80.0,
                        onPressed: () {
                          goToCategory(97);
                        },
                        child: new Column(
                          children: <Widget>[
                            Image.asset('assets/dolar.png'),
                            Text(
                              'Oferte promotionale',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ),
                  new Flexible(
                    flex: 1,
                    child: new MaterialButton(
                        height: 80.0,
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
