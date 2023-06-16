String capitalize(String str) {
  return str[0].toUpperCase() + str.substring(1);
}

String doubleToString(double value) {
  int intValue = value.toInt();

  if (intValue == value) {
    return intValue.toString();
  } else {
    return value.toString();
  }
}
