import 'package:flutter/material.dart';
import 'package:kiosk/mainpage.dart';
import 'package:kiosk/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {

  CartPage();

  _launchProduct(context, int id) {
    print(id);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ProductPage(id, null)),
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
    return new Scaffold(
      appBar: new AppBar(title: new Text('Cos')),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('cart').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemExtent: 25.0,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return new ListTile(
                      title: new Text(" ${ds['name']} ${ds['sku']}")
                  );
                }
            );
          }),
    );
  }
}
