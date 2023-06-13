import 'dart:async';
import 'dart:convert';
import 'package:drnk/utils/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveDrinksList(List<Drink> drinksList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert List of Drink objects to JSON-like data
  List<Map<String, Object>> drinksListData = drinksList.map((drink) {
    return {
      'type': drink.type.toString(),
      'liquid.amount': drink.liquid.amount,
      'liquid.unit': drink.liquid.unit.toString(),
      'percentage': drink.percentage,
      'timestamp': drink.timestamp,
      'calc.bacStart': drink.calc?.bacStart ?? 0.0,
      'calc.bacDrink': drink.calc?.bacDrink ?? 0.0,
    };
  }).toList();

  // Save the drinks list to SharedPreferences as a string
  await prefs.setString('drinksList', jsonEncode(drinksListData));
}

Future<List<Drink>?> loadDrinksList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if drinksList exists in SharedPreferences
  if (prefs.containsKey('drinksList')) {
    String drinksListDataString = prefs.getString('drinksList')!;

    // Decode the JSON-like data
    List<dynamic> drinksListData = jsonDecode(drinksListDataString);

    // Construct a list of Drink objects using the data
    List<Drink> drinksList = drinksListData.map((data) {
      return Drink(
        type: DrinkType.values
            .firstWhere((element) => element.toString() == data['type']),
        liquid: Liquid(
          amount: data['liquid.amount'],
          unit: LiquidUnit.values.firstWhere(
              (element) => element.toString() == data['liquid.unit']),
        ),
        percentage: data['percentage'],
        timestamp: data['timestamp'],
        calc: DrinkCalc(
          bacStart: data['calc.bacStart'] ?? 0.0,
          bacDrink: data['calc.bacDrink'] ?? 0.0,
        ),
      );
    }).toList();

    return drinksList;
  }

  return null;
}

Future<void> clearDrinksList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('drinksList');
}
