import 'package:flutter/services.dart';

class RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int? value = int.tryParse(newValue.text);
    if (value != null && value >= min && value <= max) {
      return newValue;
    }
    return oldValue;
  }
}
