class Company {
  String? id;
  String? userId;
  String? currencyId;
  String? name;
  String? slug;
  dynamic logo;
  dynamic banner;
  String? website;
  dynamic location;
  dynamic phone;
  String? taxId;
  String? status;

  Currency? currency;

  Company(
      {this.id,
      this.userId,
      this.currencyId,
      this.name,
      this.slug,
      this.logo,
      this.banner,
      this.website,
      this.location,
      this.phone,
      this.taxId,
      this.status,
      this.currency});

  Company.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["user_id"] is String) {
      userId = json["user_id"];
    }
    if (json["currency_id"] is String) {
      currencyId = json["currency_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["slug"] is String) {
      slug = json["slug"];
    }
    logo = json["logo"];
    banner = json["banner"];
    if (json["website"] is String) {
      website = json["website"];
    }
    location = json["location"];
    phone = json["phone"];
    if (json["tax_id"] is String) {
      taxId = json["tax_id"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["currency"] is Map) {
      currency =
          json["currency"] == null ? null : Currency.fromJson(json["currency"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["user_id"] = userId;
    data["currency_id"] = currencyId;
    data["name"] = name;
    data["slug"] = slug;
    data["logo"] = logo;
    data["banner"] = banner;
    data["website"] = website;
    data["location"] = location;
    data["phone"] = phone;
    data["tax_id"] = taxId;
    data["status"] = status;
    if (currency != null) {
      data["currency"] = currency?.toJson();
    }
    return data;
  }
}

class Currency {
  String? id;
  String? name;
  String? code;
  String? symbol;
  String? status;
  String? createdAt;
  String? updatedAt;

  Currency(
      {this.id,
      this.name,
      this.code,
      this.symbol,
      this.status,
      this.createdAt,
      this.updatedAt});

  Currency.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["code"] is String) {
      code = json["code"];
    }
    if (json["symbol"] is String) {
      symbol = json["symbol"];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["code"] = code;
    data["symbol"] = symbol;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
