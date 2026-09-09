enum CouponTypeEnum { fixed, percentage, notValid }

class CouponModel {
  String? id;
  String? companyId;
  String? code;
  String? description;
  String? type;
  double discount = 0.0;
  String? expiresOn;
  String? status;

  CouponTypeEnum couponType() {
    switch (type) {
      case "FIXED":
        return CouponTypeEnum.fixed;
      case "PERCENT":
        return CouponTypeEnum.percentage;
      default:
        return CouponTypeEnum.notValid;
    }
  }

  CouponModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["company_id"] is String) {
      companyId = json["company_id"];
    }
    if (json["code"] is String) {
      code = json["code"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["discount"] is double) {
      discount = json["discount"];
    }
    if (json["expires_on"] is String) {
      expiresOn = json["expires_on"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["company_id"] = companyId;
    data["code"] = code;
    data["description"] = description;
    data["type"] = type;
    data["discount"] = discount;
    data["expires_on"] = expiresOn;
    data["status"] = status;
    return data;
  }
}
