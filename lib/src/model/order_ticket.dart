import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';

class OrderTicket {
  String? id;
  String? orderId;
  String? ticketId;
  String? description;
  double price = 0.00;
  int quantity = 1;
  SingleTicket? singleTicket;

  OrderTicket.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["order_id"] is String) {
      orderId = json["order_id"];
    }
    if (json["ticket_id"] is String) {
      ticketId = json["ticket_id"];
    }

    price = double.parse(json["price"].toString());

    if (json["quantity"] is int) {
      quantity = json["quantity"];
    }
    if (json['ticket'] is Map) {
      singleTicket = SingleTicket.fromJson(json['ticket']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["order_id"] = orderId;
    data["ticket_id"] = ticketId;
    data["price"] = price;
    data["quantity"] = quantity;

    return data;
  }
}
