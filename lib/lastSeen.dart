import 'dart:collection';
import 'package:kiosk/product.dart';

class LastSeen {
  static final LastSeen _singleton = new LastSeen._internal();

  static final Queue<ProductInfo> queue = new Queue<ProductInfo>();

  factory LastSeen() => _singleton;

  LastSeen._internal();

  static push(ProductInfo info)
  {
    queue.removeWhere((elem) => elem.id == info.id );
    queue.addFirst(info);
  }
}