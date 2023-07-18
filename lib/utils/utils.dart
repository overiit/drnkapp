String capitalize(String str) {
  return str[0].toUpperCase() + str.substring(1);
}

String unpadDecimalZeros(String str, {int fractionDigits = 0}) {
  if (str.contains('.')) {
    int i = str.length - 1;
    while (str[i] == '0') {
      i--;
    }
    if (str[i] == '.') {
      i--;
    }
    str = str.substring(0, i + 1);
  }

  if (fractionDigits > 0) {
    int decimalIndex = str.indexOf('.');
    if (!str.contains('.')) {
      str += '.';
      decimalIndex = str.length - 1;
    }
    int decimals = str.length - decimalIndex - 1;
    if (decimals < fractionDigits) {
      str += '0' * (fractionDigits - decimals);
    }
  }
  return str;
}

String doubleToString(double value,
    {int fractionDigits = 2, int visualFractionDigits = 0}) {
  int intValue = value.toInt();

  if (intValue == value) {
    return intValue.toString();
  } else {
    return unpadDecimalZeros(
      value.toStringAsFixed(fractionDigits),
      fractionDigits: visualFractionDigits,
    );
  }
}
