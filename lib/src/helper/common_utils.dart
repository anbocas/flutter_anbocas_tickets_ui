bool isValidPrice(String priceInput) {
  // Regular expression to match the price pattern
  final RegExp priceRegex = RegExp(r'^\d+(\.\d{0,2})?$');

  // Check if the input matches the regex
  if (!priceRegex.hasMatch(priceInput)) {
    return false;
  }

  // Convert string to double and check if it is positive
  try {
    final double price = double.parse(priceInput);
    return price >= 0;
  } catch (e) {
    // If parsing fails, return false
    return false;
  }
}
