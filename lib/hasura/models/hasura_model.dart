import 'dart:convert';

abstract class HasuraModel {
  List getAll() {
    Map jsonMapped = json.decode(json.encode(this));
    return jsonMapped.keys.toList();
  }
}
