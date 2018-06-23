import 'package:flutter/material.dart';
import 'package:kiosk/mainpage.dart';
import 'package:kiosk/product.dart';
import 'package:kiosk/lastSeen.dart';

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
      appBar: new AppBar(
          title: new Text('Produse in cos'),
        actions: <Widget>[
          new FlatButton.icon(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      title: new Text("Detalii despre livrare"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            new TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Adresa de livrare'
                              ),

                            ),
                            new TextFormField(
                              decoration: InputDecoration(
                                  hintText: 'Oras'
                              ),

                            ),
                            new TextFormField(
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                              decoration: InputDecoration(
                                  hintText: 'Telefon'
                              ),

                            ),
                            new Expanded(
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    new MaterialButton(
                                        onPressed: (){},
                                      child: new Text('Comanda!'),
                                      color: Colors.green,
                                        ),
                                    new MaterialButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: new Text('Renunta'),
                                    )

                                  ],
                                ))
                    ]),
                    )
                );
              },
              icon: Icon(Icons.shop),
              label: new Text('Comanda!')),

        ],
      ),
      backgroundColor: Colors.white,
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            title: new Text(LastOrder.queue.elementAt(index).name),
            trailing: new Text(LastOrder.queue.elementAt(index).price.toString()),
            leading: new SizedBox(
              child: Image.network(LastOrder.queue.elementAt(index).image),
              height: 40.0,
            width: 40.0,),
          );
        },
        itemCount: LastOrder.queue.length,
      )

    );
  }
}
