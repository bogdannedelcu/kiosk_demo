import 'package:flutter/material.dart';
import 'package:kiosk/mainpage.dart';
import 'package:kiosk/product.dart';
import 'package:kiosk/lastSeen.dart';

class CartPage extends StatefulWidget {


  CartPage();



  @override
  CartPageState createState() {
    return new CartPageState();
  }

}

  class CartPageState extends State<CartPage> {

    int _priceIntreg(double price) {
      return price.floor();
    }

    int _priceDecimals(double price) {
      return ((price - price.floor()) * 100).floor();
    }


    double totalCart() {
      double ret = 0.0;
      for (var info in LastOrder.queue) {
        ret += info.price;
      }

      return ret;
    }

    showOrderDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (_) =>
          new AlertDialog(
            title: new Text("Detalii despre livrare"),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
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
                            onPressed: () {},
                            child: new Text('Comanda!'),
                            color: Colors.green,
                          ),
                          new MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: new Text('Renunta'),
                          )

                        ],
                      ))
                ]),
          )
      );
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Produse in cos'),
        actions: <Widget>[
          new FlatButton.icon(
              onPressed: (){
                showOrderDialog(context);
              },
              icon: Icon(Icons.shop),
              label: new Text('Comanda!')),

        ],
      ),
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new Expanded(
            child:           new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final item = LastOrder.queue.elementAt(index);
                return new Dismissible(
                  key: new Key(item.name),
                  direction: DismissDirection.horizontal,
                  background: Container(color: Colors.blue,),
                  secondaryBackground: Container(color: Colors.red,
                  child: new Text("Sterge din cos", ),
                  ),
                  onDismissed: (DismissDirection dir) {
                    LastOrder.queue.remove(item);
                    setState(() {

                    });


                  },
                  child: new ListTile(
                    title: new Text(LastOrder.queue.elementAt(index).name),
                    trailing: new Text(LastOrder.queue.elementAt(index).price.toString()),
                    leading: new SizedBox(
                      child: Image.network(LastOrder.queue.elementAt(index).image),
                      height: 40.0,
                      width: 40.0,),
                  ),
                );
              },
              itemCount: LastOrder.queue.length,
            ),

          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text("Total comanda", textAlign: TextAlign.right, textScaleFactor: 2.0,),
              new SizedBox(width: 100.0,
                child: new Text(totalCart().toStringAsFixed(2), textAlign: TextAlign.left, textScaleFactor: 2.0,style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),)
                ,
              ),
              new Text("Lei", textAlign: TextAlign.left, textScaleFactor: 2.0,),

            ],
          )

        ],
      )

    );
  }
}
