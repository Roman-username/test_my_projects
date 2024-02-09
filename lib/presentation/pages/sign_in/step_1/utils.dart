import 'package:flutter/services.dart';

class PhoneMaskFormatter extends TextInputFormatter {
  final String wildcard;

  const PhoneMaskFormatter(this.wildcard);

  String get mask =>
      '+7 (${wildcard * 3}) ${wildcard * 3} ${wildcard * 2} ${wildcard * 2}';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldText = oldValue.text;
    final curText = newValue.text;
    int wildcardIdx = oldText.indexOf(wildcard);

    // удаление
    if (curText.length < mask.length) {
      // удалили последний символ
      if (_findLastDigitIndex(oldText) == 17) {
        return TextEditingValue(text: '$curText$wildcard');
      }
      int? lastDigitIdx = _findLastDigitIndex(curText, 3);
      // удалили первую цифру цифру
      if (lastDigitIdx == null) return oldValue;

      final newText = curText.substring(0, lastDigitIdx) +
          wildcard +
          oldText.substring(lastDigitIdx + 1);
      return TextEditingValue(text: newText);
    }

    final newChar = curText[curText.length - 1];
    if (wildcardIdx == -1 || // уже всё заполнено цифрами
            int.tryParse(newChar) == null // добавили не цифру
        ) return oldValue;

    // добавление
    final newText = oldText.substring(0, wildcardIdx) +
        newChar +
        oldText.substring(wildcardIdx + 1);
    return TextEditingValue(text: newText);
  }
}

int? _findLastDigitIndex(String str, [int? start]) {
  for (int i = str.length - 1; i >= (start ?? 0); i--) {
    if (RegExp(r'\d').hasMatch(str[i])) {
      return i;
    }
  }
  return null;
}

String? phoneMaskValidator(String? value, String wildcard) {
  if (value!.isEmpty) return 'Введите телефон';
  bool phonelValid = !value.contains(wildcard);
  if (!phonelValid) return 'Телефон введён в ошибкой';
  return null;
}
