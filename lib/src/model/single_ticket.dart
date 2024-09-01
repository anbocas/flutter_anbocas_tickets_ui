import 'dart:ffi';

class SingleTicket {
  String? id;
  String? eventId;
  String? name;
  String? description;
  Double? price;
  int capacity = -1;
  String? availableFrom;
  String? availableTo;
  int minQtyPerOrder = 1;
  int maxQtyPerOrder = 10;
  String? status;
  String? formattedPrice;
  int selectedQuantity = 0;

  SingleTicket.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["event_id"] is String) {
      eventId = json["event_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }

    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["price"] is int) {
      price = json["price"];
    }

    if (json["capacity"] is int) {
      capacity = json["capacity"];
    }
    if (json["available_from"] is String) {
      availableFrom = json["available_from"];
    }
    if (json["available_to"] is String) {
      availableTo = json["available_to"];
    }

    if (json["min_qty_per_order"] is int) {
      minQtyPerOrder = json["min_qty_per_order"];
    }
    if (json["max_qty_per_order"] is int) {
      maxQtyPerOrder = json["max_qty_per_order"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["formatted_price"] is String) {
      formattedPrice = json["formatted_price"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["event_id"] = eventId;
    data["name"] = name;
    data["description"] = description;
    data["price"] = price;
    data["capacity"] = capacity;
    data["available_from"] = availableFrom;
    data["available_to"] = availableTo;
    data["min_qty_per_order"] = minQtyPerOrder;
    data["max_qty_per_order"] = maxQtyPerOrder;
    data["status"] = status;
    data["formatted_price"] = formattedPrice;

    return data;
  }
}
