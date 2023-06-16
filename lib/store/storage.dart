import 'dart:async';
import 'dart:convert';
import 'package:drnk/utils/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

String storageUserProfileKey = "userProfile";
String storageDrinkListKey = "drinkList";
String storagePreferenceKey = "preference";

Future<void> saveList<T extends Mappable>(String key, List<T>? list) async {
  if (list == null) {
    await clearList(key);
    return;
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> listFormatted = list.map<String>((item) {
    return jsonEncode(item.toMap());
  }).toList();

  await prefs.setStringList(key, listFormatted);
}

Future<List<T>> loadList<T>(
    String key, T Function(Map<String, dynamic>) fromMap) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(key)) {
    List<String> dataListString = prefs.getStringList(key)!;
    List<dynamic> dataListData =
        dataListString.map((str) => jsonDecode(str)).toList();
    List<T> dataList = dataListData
        .map((data) => fromMap(data as Map<String, dynamic>))
        .toList();

    return dataList;
  } else {
    return [];
  }
}

Future<void> clearList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

Future<T?> loadItem<T extends Mappable>(
    String key, T Function(Map<String, dynamic>) fromMap) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(key)) {
    String itemString = prefs.getString(key)!;
    Map<String, dynamic> itemData = jsonDecode(itemString);
    T item = fromMap(itemData);

    return item;
  } else {
    return null;
  }
}

Future<void> saveItem<T extends Mappable>(String key, T? item) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (item == null) {
    await prefs.remove(key);
  } else {
    await prefs.setString(key, jsonEncode(item.toMap()));
  }
}

Future<void> saveString(String key, String? value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (value == null) {
    await prefs.remove(key);
  } else {
    await prefs.setString(key, value);
  }
}

Future<String?> loadString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(key)) {
    return prefs.getString(key);
  } else {
    return null;
  }
}

Future<void> saveInt(String key, int? value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (value == null) {
    await prefs.remove(key);
  } else {
    await prefs.setInt(key, value);
  }
}
