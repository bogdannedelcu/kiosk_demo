import 'package:flutter/material.dart';
import 'package:kiosk/mainpage.dart';
import 'package:kiosk/product.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

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
                        image: new AdvancedNetworkImage(_info.image),
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

class CategoryPage extends StatelessWidget {
  final List<ProductInfo> data;

  CategoryPage(this.data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            child: new GridView.count(

          crossAxisCount: 2,
          children: _buildItems(),
        )));
  }

  List<CategoryItem> _buildItems() {
    return data.map((info) => new CategoryItem(info)).toList();
  }
}
