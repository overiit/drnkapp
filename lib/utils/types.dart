import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';

enum HeaderViewType { alcohol, time }

enum DrinkType { beer, wine, spirit, other }

enum LiquidUnit { ml, oz, pt }

abstract class Mappable {
  Map<String, dynamic> toMap();
}

Drink noDrink = Drink(
  type: DrinkType.other,
  liquid: Liquid(amount: 0, unit: LiquidUnit.ml),
  percentage: 0,
  timestamp: 0,
);

class Liquid extends Mappable {
  double amount;
  LiquidUnit unit;

  Liquid({required this.amount, required this.unit});

  @override
  String toString() {
    return '$amount${unit.name}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'unit': unit.toString(),
    };
  }

  static Liquid fromMap(Map<String, dynamic> map) {
    return Liquid(
      amount: map['amount'],
      unit: LiquidUnit.values.firstWhere((e) => e.toString() == map['unit']),
    );
  }
}

class DrinkCalc extends Mappable {
  double bacStart;
  double bacDrink;

  DrinkCalc({required this.bacStart, required this.bacDrink});

  @override
  Map<String, dynamic> toMap() {
    return {
      'bacStart': bacStart,
      'bacDrink': bacDrink,
    };
  }

  static DrinkCalc fromMap(Map<String, dynamic> map) {
    return DrinkCalc(
      bacStart: map['bacStart'],
      bacDrink: map['bacDrink'],
    );
  }
}

class Drink extends Mappable {
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

  IconData get icon {
    switch (type) {
      case DrinkType.beer:
        return Icons.sports_bar;
      case DrinkType.wine:
        return Icons.wine_bar;
      case DrinkType.spirit:
        return Icons.local_bar;
      default:
        return Icons.local_drink;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'liquid': liquid.toMap(),
      'percentage': percentage,
      'timestamp': timestamp,
      'calc': calc?.toMap(),
    };
  }

  static Drink fromMap(Map<String, dynamic> map) {
    return Drink(
      type: DrinkType.values.firstWhere((e) => e.toString() == map['type']),
      liquid: Liquid.fromMap(map['liquid']),
      percentage: map['percentage'],
      timestamp: map['timestamp'],
      calc: map['calc'] != null ? DrinkCalc.fromMap(map['calc']) : null,
    );
  }
}

enum WeightUnit { kg, lb }

class Weight extends Mappable {
  double amount;
  WeightUnit unit;

  Weight({required this.amount, required this.unit});

  @override
  String toString() {
    return '$amount${unit.name}';
  }

  String toApproxString() {
    return '${doubleToString(amount)}${unit.name}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'unit': unit.toString(),
    };
  }

  static Weight fromMap(Map<String, dynamic> map) {
    return Weight(
      amount: map['amount'],
      unit: WeightUnit.values.firstWhere((e) => e.toString() == map['unit']),
    );
  }
}

enum Sex { male, female }
