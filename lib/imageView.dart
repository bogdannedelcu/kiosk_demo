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
import 'package:zoomable_image/zoomable_image.dart';

class ImageView extends StatelessWidget {

  final String _image;

  ImageView(this._image);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        color: Colors.white,
        child: new ZoomableWidget(
          enableZoom: true,
          minScale: 0.3,
          maxScale: 2.0,
          tapCallback: () {
            Navigator.pop(context, null);
          },

          enablePan: true,
          child: new Hero(
            tag: _image,
            child: new Image(
              image: new NetworkImage(_image),
            ),
          ),
        ));
  }
}
