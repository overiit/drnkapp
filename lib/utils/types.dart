import 'package:drnk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum HeaderViewType { alcohol, time }

enum DrinkType { beer, wine, spirit, other }

enum LiquidUnit { ml, oz, pt }

enum LimitType { timeToSober, alcoholLimit }

class Limitation extends Mappable {
  LimitType type;
  double value;
  TimeOfDay timeOfDay;

  Limitation({
    required this.type,
    this.value = 0.1,
    this.timeOfDay = const TimeOfDay(hour: 8, minute: 0),
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString(),
      'value': value,
    };
  }

  static Limitation fromMap(Map<String, dynamic> map) {
    return Limitation(
      type: LimitType.values.firstWhere((e) => e.toString() == map['type']),
      value: map['value'],
    );
  }
}

abstract class Mappable {
  Map<String, dynamic> toMap();
}

Drink noDrink = Drink(
  name: 'No drink',
  type: DrinkType.other,
  liquid: Liquid(amount: 0, unit: LiquidUnit.ml),
  percentage: 0,
  timestamp: 0,
);

class Liquid extends Mappable {
  double amount;
  LiquidUnit unit;

  Liquid({required this.amount, required this.unit});

  clone() {
    return Liquid(amount: amount, unit: unit);
  }

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

class MarkedTime extends Mappable {
  int timestamp;
  String? note;

  MarkedTime({required this.timestamp, this.note});

  @override
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'note': note,
    };
  }

  static MarkedTime fromMap(Map<String, dynamic> map) {
    return MarkedTime(
      timestamp: map['timestamp'],
      note: map['note'],
    );
  }
}

class Drink extends Mappable {
  String name;
  DrinkType type;
  // liquid
  Liquid liquid;
  // percentage
  double percentage;
  // time drank
  int timestamp;

  DrinkCalc? calc;

  Drink({
    required this.name,
    required this.liquid,
    required this.percentage,
    required this.timestamp,
    this.type = DrinkType.other,
    // ^ only these should be initialized
    this.calc,
  });

  clone() {
    return Drink(
      name: name,
      liquid: liquid.clone(),
      percentage: percentage,
      timestamp: timestamp,
    );
  }

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
      'name': name,
      'type': type.toString(),
      'liquid': liquid.toMap(),
      'percentage': percentage,
      'timestamp': timestamp,
      'calc': calc?.toMap(),
    };
  }

  static Drink fromMap(Map<String, dynamic> map) {
    DrinkType type = DrinkType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => DrinkType.other);
    return Drink(
      name: map['name'] ??
          (type != DrinkType.other ? type.name.capitalizeFirst : 'Drink'),
      type: type,
      liquid: Liquid.fromMap(map['liquid']),
      percentage: map['percentage'],
      timestamp: map['timestamp'],
      calc: map['calc'] != null ? DrinkCalc.fromMap(map['calc']) : null,
    );
  }
}

class Event extends Mappable {
  int id;
  String name;
  int timestampStart;
  int? timestampEnd;

  int get duration {
    if (timestampEnd == null) {
      return DateTime.now().millisecondsSinceEpoch;
    }
    return timestampEnd! - timestampStart;
  }

  Event({
    required this.id,
    required this.name,
    required this.timestampStart,
    this.timestampEnd,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'timestampStart': timestampStart,
      'timestampEnd': timestampEnd,
    };
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      timestampStart: map['timestampStart'],
      timestampEnd: map['timestampEnd'],
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
