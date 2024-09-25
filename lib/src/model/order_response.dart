// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anbocas_tickets_ui/src/model/event_guest.dart';
import 'package:anbocas_tickets_ui/src/model/event_response.dart';
import 'package:anbocas_tickets_ui/src/model/order_ticket.dart';
import 'package:anbocas_tickets_ui/src/model/single_company.dart';
class OrderResponse {
  OrderData? data;
  String? paymentUrl;

  OrderResponse({this.data, this.paymentUrl});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    if (json["data"] is Map) {
      data = json["data"] == null ? null : OrderData.fromJson(json["data"]);
    }
    if (json["paymentUrl"] is String) {
      paymentUrl = json["paymentUrl"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["data"] = data?.toJson();
    _data["paymentUrl"] = paymentUrl;
    return _data;
  }
}

class OrderData {
  String? id;
  String? orderNumber;
  String? companyId;
  String? eventId;
  String? coupon;
  double subTotal = 0.0;
  double discountAmount = 0.0;
  double convenienceFee = 0.0;
  double convenienceTax = 0.0;
  double totalConvenienceFee = 0.0;
  double pgFee = 0.0;
  double parentOrganiserCommission = 0.0;
  double totalPayable = 0.0;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? currencyId;
  int? isGuestCheckout;
  String? status;
  late List<OrderTicket> tickets;
  late List<EventGuest> guests;
  EventResponse? event;
  Company? company;
  Payment? payment;
  String? createdAt;

  OrderData.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["order_number"] is String) {
      orderNumber = json["order_number"];
    }
    if (json["company_id"] is String) {
      companyId = json["company_id"];
    }
    if (json["event_id"] is String) {
      eventId = json["event_id"];
    }
    if (json["coupon"] is String) {
      coupon = json["coupon"];
    }
    if (json["sub_total"] is int || json["sub_total"] is double) {
      subTotal = json["sub_total"] is int
          ? (json["sub_total"] as int).toDouble()
          : json["sub_total"];
    } else if (json["sub_total"] is String) {
      subTotal = json["sub_total"] != null
          ? double.tryParse(json["sub_total"]) ?? 0.0
          : 0.0;
    }

    if (json["discount_amount"] is int || json["discount_amount"] is double) {
      discountAmount = json["discount_amount"] is int
          ? (json["discount_amount"] as int).toDouble()
          : json["discount_amount"];
    } else if (json["discount_amount"] is String) {
      discountAmount = json["discount_amount"] != null
          ? double.tryParse(json["discount_amount"]) ?? 0.0
          : 0.0;
    }

    if (json["convenience_fee"] is int || json["convenience_fee"] is double) {
      convenienceFee = json["convenience_fee"] is int
          ? (json["convenience_fee"] as int).toDouble()
          : json["convenience_fee"];
    } else if (json["convenience_fee"] is String) {
      convenienceFee = json["convenience_fee"] != null
          ? double.tryParse(json["convenience_fee"]) ?? 0.0
          : 0.0;
    }

    if (json["convenience_tax"] is double || json["convenience_tax"] is int) {
      convenienceTax = json["convenience_tax"] is int
          ? (json["convenience_tax"] as int).toDouble()
          : json["convenience_tax"];
    } else if (json["convenience_tax"] is String) {
      convenienceTax = json["convenience_tax"] != null
          ? double.tryParse(json["convenience_tax"]) ?? 0.0
          : 0.0;
    }

    if (json["total_convenience_fee"] is double ||
        json["total_convenience_fee"] is int) {
      totalConvenienceFee = json["total_convenience_fee"] is int
          ? (json["total_convenience_fee"] as int).toDouble()
          : json["total_convenience_fee"];
    } else if (json["total_convenience_fee"] is String) {
      totalConvenienceFee = json["total_convenience_fee"] != null
          ? double.tryParse(json["total_convenience_fee"]) ?? 0.0
          : 0.0;
    }

    if (json["total_convenience_fee"] is double ||
        json["total_convenience_fee"] is int) {
      totalConvenienceFee = json["total_convenience_fee"] is int
          ? (json["total_convenience_fee"] as int).toDouble()
          : json["total_convenience_fee"];
    } else if (json["total_convenience_fee"] is String) {
      totalConvenienceFee = json["total_convenience_fee"] != null
          ? double.tryParse(json["total_convenience_fee"]) ?? 0.0
          : 0.0;
    }

    if (json["pg_fee"] is double || json["pg_fee"] is int) {
      pgFee = json["pg_fee"] is int
          ? (json["pg_fee"] as int).toDouble()
          : json["pg_fee"];
    } else if (json["pg_fee"] is String) {
      pgFee =
          json["pg_fee"] != null ? double.tryParse(json["pg_fee"]) ?? 0.0 : 0.0;
    }

    if (json["parent_organiser_commission"] is double ||
        json["parent_organiser_commission"] is int) {
      parentOrganiserCommission = json["parent_organiser_commission"] is int
          ? (json["parent_organiser_commission"] as int).toDouble()
          : json["parent_organiser_commission"];
    } else if (json["parent_organiser_commission"] is String) {
      parentOrganiserCommission = json["parent_organiser_commission"] != null
          ? double.tryParse(json["parent_organiser_commission"]) ?? 0.0
          : 0.0;
    }

    if (json["total_payable"] is double || json["total_payable"] is int) {
      totalPayable = json["total_payable"] is int
          ? (json["total_payable"] as int).toDouble()
          : json["total_payable"];
    } else if (json["total_payable"] is String) {
      totalPayable = json["total_payable"] != null
          ? double.tryParse(json["total_payable"]) ?? 0.0
          : 0.0;

      if (json['created_at'] is String) {
        createdAt = json['created_at'];
      }
    }

    if (json["user_id"] is String) {
      userId = json["user_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    if (json["is_guest_checkout"] is int) {
      isGuestCheckout = json["is_guest_checkout"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["currency_id"] is String) {
      currencyId = json["currency_id"];
    }
    if (json["tickets"] is List) {
      tickets = json["tickets"] == null
          ? []
          : (json["tickets"] as List)
              .map((e) => OrderTicket.fromJson(e))
              .toList();
    }
    if (json["guests"] is List) {
      guests = json["guests"] == null
          ? []
          : (json["guests"] as List)
              .map((e) => EventGuest.fromJson(e))
              .toList();
    }
    if (json["event"] is Map) {
      event =
          json["event"] == null ? null : EventResponse.fromJson(json["event"]);
    }
    if (json["company"] is Map) {
      company =
          json["company"] == null ? null : Company.fromJson(json["company"]);
    }
    if (json["payment"] is Map) {
      payment =
          json["payment"] == null ? null : Payment.fromJson(json["payment"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["order_number"] = orderNumber;
    data["company_id"] = companyId;
    data["event_id"] = eventId;
    data["coupon"] = coupon;
    data["sub_total"] = subTotal;
    data["discount_amount"] = discountAmount;
    data["convenience_fee"] = convenienceFee;
    data["convenience_tax"] = convenienceTax;
    data["total_convenience_fee"] = totalConvenienceFee;
    data["pg_fee"] = pgFee;
    data["parent_organiser_commission"] = parentOrganiserCommission;
    data["total_payable"] = totalPayable;
    data["user_id"] = userId;
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["is_guest_checkout"] = isGuestCheckout;
    data["status"] = status;
    data["currency_id"] = currencyId;
    data["tickets"] = tickets.map((e) => e.toJson()).toList();
    if (event != null) {
      data["event"] = event?.toJson();
    }
    if (company != null) {
      data["company"] = company?.toJson();
    }
    if (payment != null) {
      data["payment"] = payment?.toJson();
    }
    return data;
  }

  List<String> ticketGuests(String ticketId) {
    return guests
        .where((eg) => eg.orderTicketId == ticketId)
        .map(
          (m) => m.code!,
        )
        .toList();
  }

  Map<String, dynamic> trimmedPayload() {
    final Map<String, dynamic> data = <String, dynamic>{};

    final tempArray = <String>[];

    for (var ticket in tickets) {
      tempArray.add('${ticket.quantity}x ${ticket.singleTicket?.name}');
    }

    data["order_summary"] = tempArray.join(', ');
    data["anbocas_order_id"] = id;
    data["order_number"] = orderNumber;
    data["sub_total"] = subTotal;
    data["discount_amount"] = discountAmount;
    data["total_payable"] = totalPayable;
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["tickets"] = tickets
        .map((e) => {
              'name': e.singleTicket?.name,
              'quantity': e.quantity,
              'codes': guests
                  .where((eg) => eg.orderTicketId == e.id)
                  .map(
                    (m) => m.code,
                  )
                  .toList(),
            })
        .toList();
    data["event_name"] = event?.name;
    data["event_photo"] = event?.imageUrl;

    return data;
  }

  @override
  String toString() {
    return 'OrderData(id: $id, orderNumber: $orderNumber, companyId: $companyId, eventId: $eventId, subTotal: $subTotal, discountAmount: $discountAmount, convenienceFee: $convenienceFee, convenienceTax: $convenienceTax, totalConvenienceFee: $totalConvenienceFee, totalPayable: $totalPayable, userId: $userId, name: $name, email: $email, phone: $phone, currencyId: $currencyId)';
  }
}

class Payment {
  String? id;
  String? gatewayProvider;
  String? gatewayTransactionId;
  String? eventId;
  String? orderId;
  String? method;
  String? email;
  String? phone;
  String? amount;
  String? payerName;
  double? fee;
  double? tax;
  String? createdAt;
  String? updatedAt;

  Payment(
      {this.id,
      this.gatewayProvider,
      this.gatewayTransactionId,
      this.eventId,
      this.orderId,
      this.method,
      this.email,
      this.phone,
      this.amount,
      this.payerName,
      this.fee,
      this.tax,
      this.createdAt,
      this.updatedAt});

  Payment.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["gateway_provider"] is String) {
      gatewayProvider = json["gateway_provider"];
    }
    if (json["gateway_transaction_id"] is String) {
      gatewayTransactionId = json["gateway_transaction_id"];
    }
    if (json["event_id"] is String) {
      eventId = json["event_id"];
    }
    if (json["order_id"] is String) {
      orderId = json["order_id"];
    }
    if (json["method"] is String) {
      method = json["method"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    if (json["amount"] is String) {
      amount = json["amount"];
    }
    if (json["payer_name"] is String) {
      payerName = json["payer_name"];
    }
    if (json["fee"] is double) {
      fee = json["fee"];
    }
    if (json["tax"] is double) {
      tax = json["tax"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["gateway_provider"] = gatewayProvider;
    _data["gateway_transaction_id"] = gatewayTransactionId;
    _data["event_id"] = eventId;
    _data["order_id"] = orderId;
    _data["method"] = method;
    _data["email"] = email;
    _data["phone"] = phone;
    _data["amount"] = amount;
    _data["payer_name"] = payerName;
    _data["fee"] = fee;
    _data["tax"] = tax;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}
