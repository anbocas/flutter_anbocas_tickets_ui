enum CouponTypeEnum { FIXED, PERCENTAGE, NOTVALID }

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
        return CouponTypeEnum.FIXED;
      case "PERCENT":
        return CouponTypeEnum.PERCENTAGE;
      default:
        return CouponTypeEnum.NOTVALID;
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
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["company_id"] = companyId;
    _data["code"] = code;
    _data["description"] = description;
    _data["type"] = type;
    _data["discount"] = discount;
    _data["expires_on"] = expiresOn;
    _data["status"] = status;
    return _data;
  }
}
