import 'package:anbocas_tickets_ui/src/model/order_ticket.dart';

class EventGuest {
  String? id;
  String? orderId;
  String? eventId;
  String? code;
  String? orderTicketId;
  OrderTicket? orderTicket;

  EventGuest.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["order_id"] is String) {
      orderId = json["order_id"];
    }
    if (json["event_id"] is String) {
      eventId = json["event_id"];
    }
    if (json["code"] is String) {
      code = json["code"];
    }
    if (json["order_ticket_id"] is String) {
      orderTicketId = json["order_ticket_id"];
    }
    if (json["order_ticket"] is Map) {
      orderTicket = OrderTicket.fromJson(json['order_ticket']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["order_id"] = orderId;
    data["event_id"] = eventId;
    data["code"] = code;
    data["order_ticket_id"] = orderTicketId;
    data["order_ticket"] = orderTicket?.toJson();

    return data;
  }
}
