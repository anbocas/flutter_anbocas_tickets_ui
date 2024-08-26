// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anbocas_tickets_ui/src/model/single_company.dart';
import 'package:anbocas_tickets_ui/src/model/single_ticket.dart';

enum TicketLocationType { virtual, inPerson }

class TicketResponse {
  String? id;
  String? categoryId;
  String? companyId;
  String? name;
  String? slug;
  String? imageUrl;
  String? description;
  String? website;
  String? venue;
  String? location;
  double? latitude;
  double? longitude;
  String? locationType;
  String? meetingLink;
  String? startDate;
  String? endDate;
  int? isBookingOpen;
  int? isFree;
  int? isPublic;
  int? groupTicketingAllowed;
  int? commission;
  String? status;
  List<SingleTicket> tickets = [];
  Company? company;

  TicketLocationType getLocationType() {
    if (locationType == "VIRTUAL") {
      return TicketLocationType.virtual;
    } else {
      return TicketLocationType.inPerson;
    }
  }

  TicketResponse({
    this.id,
    this.categoryId,
    this.companyId,
    this.name,
    this.slug,
    this.imageUrl,
    this.description,
    this.website,
    this.venue,
    this.location,
    this.latitude,
    this.longitude,
    this.locationType,
    this.meetingLink,
    this.startDate,
    this.endDate,
    this.isBookingOpen,
    this.isFree,
    this.isPublic,
    this.groupTicketingAllowed,
    this.commission,
    this.status,
    required this.tickets,
    this.company,
  });

  TicketResponse.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["category_id"] is String) {
      categoryId = json["category_id"];
    }
    if (json["company_id"] is String) {
      companyId = json["company_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["slug"] is String) {
      slug = json["slug"];
    }
    if (json["imageUrl"] is String) {
      imageUrl = json["imageUrl"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["website"] is String) {
      website = json["website"];
    }
    if (json["venue"] is String) {
      venue = json["venue"];
    }
    if (json["location"] is String) {
      location = json["location"];
    }
    if (json["latitude"] is double) {
      latitude = json["latitude"];
    }
    if (json["longitude"] is double) {
      longitude = json["longitude"];
    }
    if (json["location_type"] is String) {
      locationType = json["location_type"];
    }

    if (json["meeting_link"] is String) {
      meetingLink = json["meeting_link"];
    }
    if (json["start_date"] is String) {
      startDate = json["start_date"];
    }
    if (json["end_date"] is String) {
      endDate = json["end_date"];
    }
    if (json["is_booking_open"] is int) {
      isBookingOpen = json["is_booking_open"];
    }
    if (json["is_free"] is int) {
      isFree = json["is_free"];
    }
    if (json["is_public"] is int) {
      isPublic = json["is_public"];
    }
    if (json["group_ticketing_allowed"] is int) {
      groupTicketingAllowed = json["group_ticketing_allowed"];
    }
    if (json["commission"] is int) {
      commission = json["commission"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }

    if (json["tickets"] is List) {
      tickets = (json["tickets"] as List)
          .map((e) => SingleTicket.fromJson(e))
          .toList();
    }
    if (json["company"] is Map) {
      company =
          json["company"] == null ? null : Company.fromJson(json["company"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["category_id"] = categoryId;
    _data["company_id"] = companyId;
    _data["name"] = name;
    _data["slug"] = slug;
    _data["imageUrl"] = imageUrl;
    _data["description"] = description;
    _data["website"] = website;
    _data["venue"] = venue;
    _data["location"] = location;
    _data["latitude"] = latitude;
    _data["longitude"] = longitude;
    _data["location_type"] = locationType;
    _data["meeting_link"] = meetingLink;
    _data["start_date"] = startDate;
    _data["end_date"] = endDate;
    _data["is_booking_open"] = isBookingOpen;
    _data["is_free"] = isFree;
    _data["is_public"] = isPublic;
    _data["group_ticketing_allowed"] = groupTicketingAllowed;
    _data["commission"] = commission;
    _data["status"] = status;

    _data["tickets"] = tickets.map((e) => e.toJson()).toList();
    if (company != null) {
      _data["company"] = company?.toJson();
    }
    return _data;
  }

  TicketResponse copyWithSelectedTickets({
    required List<SingleTicket> tickets,
  }) {
    return TicketResponse(
        id: id,
        categoryId: categoryId,
        companyId: companyId,
        name: name,
        slug: slug,
        imageUrl: imageUrl,
        description: description,
        website: website,
        location: location,
        latitude: latitude,
        longitude: longitude,
        locationType: locationType,
        meetingLink: meetingLink,
        startDate: startDate,
        endDate: endDate,
        isBookingOpen: isBookingOpen,
        isFree: isFree,
        isPublic: isPublic,
        groupTicketingAllowed: groupTicketingAllowed,
        commission: commission,
        status: status,
        tickets: tickets,
        company: company);
  }

  TicketResponse copyWith({
    List<SingleTicket>? tickets,
  }) {
    return TicketResponse(
      id: id,
      categoryId: categoryId,
      companyId: companyId,
      name: name,
      slug: slug,
      imageUrl: imageUrl,
      description: description,
      website: website,
      venue: venue,
      location: location,
      latitude: latitude,
      longitude: longitude,
      locationType: locationType,
      meetingLink: meetingLink,
      startDate: startDate,
      endDate: endDate,
      isBookingOpen: isBookingOpen,
      isFree: isFree,
      isPublic: isPublic,
      groupTicketingAllowed: groupTicketingAllowed,
      commission: commission,
      status: status,
      tickets: tickets ?? [],
      company: company,
    );
  }
}
