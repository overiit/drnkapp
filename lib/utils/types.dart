import 'package:flutter/material.dart';

enum HeaderViewType { alcohol, time }

// Drink Types
enum DrinkType { beer, wine, spirit, other }

enum LiquidUnit { ml, oz, pt }

class Liquid {
  double amount;
  LiquidUnit unit;

  Liquid({required this.amount, required this.unit});

  @override
  String toString() {
    return '$amount${unit.name}';
  }
}

IconData getDrinkTypeIcon(DrinkType type) {
  if (type == DrinkType.beer) {
    return Icons.sports_bar;
  } else if (type == DrinkType.wine) {
    return Icons.wine_bar;
  } else if (type == DrinkType.spirit) {
    return Icons.local_bar;
  } else {
    return Icons.local_drink;
  }
}

Drink noDrink = Drink(
    type: DrinkType.other,
    liquid: Liquid(amount: 0, unit: LiquidUnit.ml),
    percentage: 0,
    timestamp: 0);

class DrinkCalc {
  double bacStart;
  double bacDrink;

  DrinkCalc({required this.bacStart, required this.bacDrink});
}

class Drink {
  DrinkType type;
  // liquid
  Liquid liquid;
  // percentage
  double percentage;
  // time drank
  int timestamp;

  DrinkCalc? calc;

  Drink(
      {required this.type,
      required this.liquid,
      required this.percentage,
      required this.timestamp,
      this.calc});

  @override
  String toString() {
    return "Drink: $type, $liquid, $percentage, $timestamp";
  }
}

enum WeightUnit { kg, lb }

class Weight {
  double amount;
  WeightUnit unit;

  Weight({required this.amount, required this.unit});
}

enum Gender { male, female }

class UserProfile {
  Gender gender;
  Weight weight;

  UserProfile({required this.gender, required this.weight});
}