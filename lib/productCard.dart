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
import 'package:kiosk/product.dart';
import 'package:kiosk/utils.dart';
import 'package:zoomable_image/zoomable_image.dart';

class ProductCard extends StatelessWidget {
  final ProductInfo _info;

  ProductCard(this._info);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Card(
      elevation: 0.0,
      child: new Container(
        height: 180.0,
        width: 140.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
              child: new Container(
                height: 114.0,
                width: 116.0,
                child: new Hero(
                  tag: _info.image,
                  child: new Image(
                    image: new AdvancedNetworkImage(_info.image),
                  ),
                ),
              ),
            ),
            new Container(
                height: 32.0,
                width: 130.0,
                child: new Text(
                  _info.name,
                  style: new TextStyle(fontSize: 14.0),
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
                            priceIntreg(_info.price).toString(),
                            style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          new Column(
                            children: <Widget>[
                              new Text(
                                priceDecimals(_info.price).toString(),
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          new Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: new Text(
                              ' Lei',
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
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