import 'package:anbocas_tickets_ui/src/screens/ticket_purchase/anbocas_booking_success_screen.dart';

class Status {
  int all = 0;
  int available = 0;
  int outOfStock = 0;

  Status.fromJson(Map<String, dynamic> json) {
    if (json["ALL"] is int) {
      all = json["ALL"];
    }
    if (json["AVAILABLE"] is int) {
      available = json["AVAILABLE"];
    }
    if (json["OUT_OF_STOCK"] is int) {
      outOfStock = json["OUT_OF_STOCK"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ALL"] = all;
    data["AVAILABLE"] = available;
    data["OUT_OF_STOCK"] = outOfStock;
    return data;
  }
}

class TicketByEventData {
  List<SingleTicketByEvent>? data;
  Status? status;

  TicketByEventData({this.data, this.status});

  TicketByEventData.fromJson(Map<String, dynamic> json) {
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List)
              .map((e) => SingleTicketByEvent.fromJson(e))
              .toList();
    }
    if (json["status"] is Map) {
      status = json["status"] == null ? null : Status.fromJson(json["status"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonMap = <String, dynamic>{};

    jsonMap["data"] = data?.map((e) => e.toJson()).toList();

    if (status != null) {
      jsonMap["status"] = status?.toJson();
    }

    return jsonMap;
  }
}

class SingleTicketByEvent {
  String? id;
  String? eventId;
  String? name;
  String? description;
  String? price;
  late int capacity;
  late int available;
  int sold = 0;
  String? availableFrom;
  String? availableTo;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? formattedPrice;
  String? parentCommission;
  num? guestCount;

  String getCapacity() {
    if (capacity == -1) {
      return 'Unlimited';
    }
    return capacity.toString();
  }

  String getCurrentAvailablity() {
    if (capacity == -1) {
      return 'Unlimited';
    } else {
      return '${getAvailable()}/${getCapacity()}';
    }
  }

  String getAvailable() {
    if (available == -1) {
      return 'Unlimited';
    }
    return available.toString();
  }

  String getAvailableFrom() {
    if (availableFrom == null) {
      return 'N/A';
    }
    final dateTime = DateTime.parse(availableFrom!);

    return DateFormatter.formatDate(dateTime);
  }

  String getAvailableTo() {
    if (availableTo == null) {
      return 'N/A';
    }
    final dateTime = DateTime.parse(availableTo!);

    return DateFormatter.formatDate(dateTime);
  }

  SingleTicketByEvent(
      {this.id,
      this.eventId,
      this.name,
      this.description,
      this.price,
      this.capacity = -1,
      this.available = -1,
      this.sold = 0,
      this.availableFrom,
      this.availableTo,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.formattedPrice,
      this.parentCommission,
      this.guestCount});

  SingleTicketByEvent.fromJson(Map<String, dynamic> json) {
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
      price = json["price"].toString();
    } else if (json["price"] is String) {
      price = json["price"];
    }

    if (json["capacity"] is int) {
      capacity = json["capacity"];
    }
    if (json["available"] is int) {
      available = json["available"];
    }
    if (json["available_from"] is String) {
      availableFrom = json["available_from"];
    }
    if (json["available_to"] is String) {
      availableTo = json["available_to"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    if (json["formatted_price"] is String) {
      formattedPrice = json["formatted_price"];
    }
    if (json["parent_commission"] is String) {
      parentCommission = json["parent_commission"];
    }
    if (json["guest_count"] is num) {
      guestCount = json["guest_count"];
    }
    if (json["sold"] is int) {
      sold = json["sold"];
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
    data["available"] = available;
    data["available_from"] = availableFrom;
    data["available_to"] = availableTo;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["formatted_price"] = formattedPrice;
    data["parent_commission"] = parentCommission;
    data["guest_count"] = guestCount;
    return data;
  }
}
