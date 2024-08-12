import 'package:intl/intl.dart';

mixin StringHelperMixin {
  String changePrice(String price) {
    String returnPrice = price;
    if (price != '') {
      double parseString = double.parse(price);
      var f = NumberFormat('###0.00', 'en_Us');
      returnPrice = f.format(parseString);
    } else {
      returnPrice = '0.00';
    }
    return returnPrice;
  }
}
