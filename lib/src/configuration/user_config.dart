// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserConfig {
  String? name;
  String? email;
  String? phone;
  String? countryCode;
  String? countryLetterCode;

  UserConfig({
    this.name,
    this.email,
    this.phone,
    this.countryCode,
    this.countryLetterCode,
  });

  void updateConfig(UserConfig? newConfig) {
    name = newConfig?.name;
    email = newConfig?.email;
    phone = newConfig?.phone;
    countryCode = newConfig?.countryCode;
    countryLetterCode = newConfig?.countryLetterCode;
  }

  @override
  String toString() {
    return 'UserConfig(name: $name, email: $email, phone: $phone, countryCode: $countryCode, countryLetterCode: $countryLetterCode)';
  }
}
