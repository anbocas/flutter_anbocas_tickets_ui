class EventResponse {
  String? id;
  String? categoryId;
  String? companyId;
  String? name;
  String? slug;
  String? imageUrl;
  String? description;
  String? website;
  String? location;
  double? latitude;
  double? longitude;
  String? locationType;
  dynamic meetingLink;
  String? startDate;
  String? endDate;
  int? isBookingOpen;
  int? isFree;
  int? isPublic;
  int? groupTicketingAllowed;
  int? commission;
  String? status;
  String? createdBy;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  EventResponse(
      {this.id,
      this.categoryId,
      this.companyId,
      this.name,
      this.slug,
      this.imageUrl,
      this.description,
      this.website,
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
      this.createdBy,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  EventResponse.fromJson(Map<String, dynamic> json) {
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
    meetingLink = json["meeting_link"];
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
    if (json["created_by"] is String) {
      createdBy = json["created_by"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    deletedAt = json["deleted_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["category_id"] = categoryId;
    data["company_id"] = companyId;
    data["name"] = name;
    data["slug"] = slug;
    data["imageUrl"] = imageUrl;
    data["description"] = description;
    data["website"] = website;
    data["location"] = location;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["location_type"] = locationType;
    data["meeting_link"] = meetingLink;
    data["start_date"] = startDate;
    data["end_date"] = endDate;
    data["is_booking_open"] = isBookingOpen;
    data["is_free"] = isFree;
    data["is_public"] = isPublic;
    data["group_ticketing_allowed"] = groupTicketingAllowed;
    data["commission"] = commission;
    data["status"] = status;
    data["created_by"] = createdBy;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    return data;
  }
}
