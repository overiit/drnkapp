import "package:drnk/store/drinks.dart";
import "package:drnk/utils/colors.dart";
import "package:flutter/material.dart";

import "./types.dart";

Liquid convertLiquid(Liquid from, LiquidUnit to) {
  double amount = from.amount;
  if (from.unit == LiquidUnit.ml) {
    if (to == LiquidUnit.oz) {
      amount *= 0.033814;
    } else if (to == LiquidUnit.pt) {
      amount *= 0.00211338;
    }
  } else if (from.unit == LiquidUnit.oz) {
    if (to == LiquidUnit.ml) {
      amount *= 29.5735;
    } else if (to == LiquidUnit.pt) {
      amount *= 0.0625;
    }
  } else if (from.unit == LiquidUnit.pt) {
    if (to == LiquidUnit.ml) {
      amount *= 473.176;
    } else if (to == LiquidUnit.oz) {
      amount *= 16;
    }
  }
  return Liquid(amount: amount, unit: to);
}

Weight convertWeight(Weight from, WeightUnit to) {
  double amount = from.amount;
  if (from.unit == WeightUnit.kg) {
    if (to == WeightUnit.lb) {
      amount *= 2.20462;
    }
  } else if (from.unit == WeightUnit.lb) {
    if (to == WeightUnit.kg) {
      amount *= 0.453592;
    }
  }
  return Weight(amount: amount, unit: to);
}

Drink? defaultDrinkValues(DrinkType type) {
  if (type == DrinkType.beer) {
    return Drink(
        type: type,
        liquid: Liquid(amount: 300, unit: LiquidUnit.ml),
        percentage: 5,
        timestamp: 0);
  } else if (type == DrinkType.wine) {
    return Drink(
        type: type,
        liquid: Liquid(amount: 150, unit: LiquidUnit.ml),
        percentage: 12,
        timestamp: 0);
  } else if (type == DrinkType.spirit) {
    return Drink(
        type: type,
        liquid: Liquid(amount: 50, unit: LiquidUnit.ml),
        percentage: 40,
        timestamp: 0);
  } else {
    return null;
  }
}

String timeAgo({required int time, bool short = false}) {
  int now = DateTime.now().millisecondsSinceEpoch;
  int diff = now - time;
  int seconds = (diff / 1000).floor();
  int minutes = (seconds / 60).floor();
  int hours = (minutes / 60).floor();
  int days = (hours / 24).floor();
  String d = short ? ' d' : ' day${days > 1 ? 's' : ''}';
  String h =
      short ? ' hr${hours > 1 ? 's' : ''}' : ' hour${hours > 1 ? 's' : ''}';
  String m = short
      ? ' min${minutes > 1 ? 's' : ''}'
      : ' minute${minutes > 1 ? 's' : ''}';
  if (days > 0) {
    return '${days}${d} ago';
  } else if (hours > 0) {
    return '${hours}${h} ago';
  } else if (minutes > 0) {
    return '${minutes}${m} ago';
  } else {
    return 'Just now';
  }
}

String timeSpanDuration(int timeMs, [num Function(num)? numberModifier]) {
  numberModifier ??= (num x) => x.floor();

  num seconds = timeMs / 1000;
  num minutes = seconds / 60;
  num hours = minutes / 60;
  num days = hours / 24;

  if (days >= 1) {
    days = numberModifier(days);
    hours = numberModifier(hours % 24);
    minutes = numberModifier(minutes % 60);
    return '${days}d ${hours}h ${minutes}m';
  } else if (hours >= 1) {
    hours = numberModifier(hours);
    minutes = numberModifier(minutes % 60);
    return '${hours}h ${minutes}m';
  } else {
    minutes = numberModifier(minutes);
    return '${minutes}m';
  }
}

// Example constants
const avgAlcoholBloodDistributionValue = 5.14; // replace this value accordingly
double alcoholDistributionRatio(Gender gender) {
  if (gender == Gender.male) return 0.73;
  if (gender == Gender.female) return 0.66;
  return 0.7; // avg
}

// calculate the bac decrease per ms
double bacDecrease(int durationMs) =>
    (durationMs / (1000.0 * 60.0 * 60.0)) * 0.015;

// calculate the bac at the start of a drink
double calculateBacAtStart(
    UserProfile userProfile, Drink drink, Drink? previousDrink) {
  var bacAtStart = 0.0;
  if (previousDrink != null) {
    final bacStart = previousDrink.calc?.bacStart ?? 0;
    final bacDrink = previousDrink.calc?.bacDrink ?? 0;
    final timeSinceLastDrink = drink.timestamp - previousDrink.timestamp;
    final decreasedBac = bacDecrease(timeSinceLastDrink);
    final currentBac = (bacStart + bacDrink) - decreasedBac;
    if (currentBac > 0) {
      bacAtStart += currentBac;
    }
  }
  return bacAtStart;
}

// calculate the bac for a drink
double calculateDrinkBac(UserProfile userProfile, Drink drink) {
  final weight = userProfile.weight;
  final gender = userProfile.gender;
  final percentage = drink.percentage;

  final alcoholInOz =
      convertLiquid(drink.liquid, LiquidUnit.oz).amount * (percentage / 100);
  final weightInLbs = convertWeight(weight, WeightUnit.lb);
  double alcoholDistRatio = alcoholDistributionRatio(gender);
  final drinkBac = ((alcoholInOz * avgAlcoholBloodDistributionValue) /
      (weightInLbs.amount * alcoholDistRatio));

  return drinkBac;
}

// calculate the current bac (based on the most recent drink)
double calculateBac(Drink drink) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final bac = drink.calc!.bacStart + drink.calc!.bacDrink;
  final currentBac = bac - bacDecrease(timestamp - drink.timestamp);
  if (currentBac <= 0) {
    return 0;
  }
  return currentBac;
}

double calculateDrunkTime(List<Drink> drinks) {
  var totalBac = 0.0;
  for (final drink in drinks) {
    totalBac += drink.calc?.bacDrink ?? 0;
  }

  return (totalBac / 0.015) * 60.0 * 60.0 * 1000.0;
}

// calculate the time until sober
int calculateTimeUntilSober(Drink drink) {
  final currentBac = calculateBac(drink);
  final timeUntilSober = (currentBac / 0.015) * 60.0 * 60.0 * 1000.0;

  return timeUntilSober.toInt();
}

List<Drink> addDrink(
    UserProfile userProfile, List<Drink> drinks, Drink drinkInput) {
  // sort the drinks by timestamp (oldest to newest)
  drinks.sort((a, b) => a.timestamp - b.timestamp);
  // if there is a drink with the exact same drank_at, add 1 millisecond to the new drink
  var done = false;
  while (!done) {
    final sameTimeDrink = drinks.firstWhere(
        (d) => d.timestamp == drinkInput.timestamp,
        orElse: () => noDrink);
    if (sameTimeDrink != noDrink) {
      drinkInput.timestamp++;
    } else {
      done = true;
    }
  }

// get the most drink that was before the new drink
  final previousDrink = drinks.lastWhere(
      (d) => d.timestamp < drinkInput.timestamp,
      orElse: () => noDrink);

// calculate the bac for the new drink
  drinkInput.calc = DrinkCalc(
    bacStart: calculateBacAtStart(userProfile, drinkInput,
        previousDrink == noDrink ? null : previousDrink),
    bacDrink: calculateDrinkBac(userProfile, drinkInput),
  );

// add the new drink to the drinks array at the index of the most recent drink
  if (previousDrink != noDrink) {
    drinks.insert(drinks.indexOf(previousDrink), drinkInput);
    drinks.sort((a, b) => a.timestamp - b.timestamp);
  } else {
    drinks.insert(0, drinkInput);
  }
  int lastTimestamp = 0;
// calculate the bac for all drinks after the new drink
  for (var i = drinks.indexOf(drinkInput); i < drinks.length; i++) {
    final drink = drinks[i];
    final previousDrink = i > 0 ? drinks.elementAt(i - 1) : noDrink;
// check if the previous drink is actually the previous drink and throw an error if not
    if (previousDrink != noDrink && drink.timestamp < previousDrink.timestamp) {
      print('Drinks are not sorted correctly');
    }
    if (drink.timestamp < lastTimestamp) {
      print('Drinks are not sorted correctly');
    }
    drink.calc = DrinkCalc(
      bacStart: calculateBacAtStart(
          userProfile, drink, previousDrink == noDrink ? null : previousDrink),
      bacDrink: calculateDrinkBac(userProfile, drink),
    );
  }

  // reverse the drinks for the UI
  drinks.sort((a, b) => b.timestamp - a.timestamp);

  // save the drinks to the database
  saveDrinksList(drinks);

  return drinks;
}

class HealthStatus {
  final String description;
  final Color color;
  final bool driverNotice;

  HealthStatus({
    required this.description,
    required this.color,
    this.driverNotice = true,
  });
}

HealthStatus bacHealthStatus(double bac) {
  if (bac < 0.001) {
    return HealthStatus(
      description: 'You are sober',
      color: goodColor,
      driverNotice: false,
    );
  } else if (bac < 0.030) {
    return HealthStatus(
      description:
          'Seems normal; subtle effects detected via special tests.',
      color: goodColor,
      driverNotice: bac > 0.02
    );
  } else if (bac < 0.060) {
    return HealthStatus(
      description:
          'Clear euphoria, lowered inhibitions, higher risk taking, slurred speech.',
      color: okColor,
    );
  } else if (bac < 0.1) {
    return HealthStatus(
      description:
          'Mood swings, irritability, loudness, reduced libido, impaired reflexes, poor coordination, and loss of judgment.',
      color: okColor,
    );
  } else if (bac < 0.2) {
    return HealthStatus(
      description:
          'Disorientation, confusion, nausea, dizziness, higher pain tolerance, with impaired judgment and perception.',
      color: okColor,
    );
  } else if (bac < 0.3) {
    return HealthStatus(
      description:
          'Central nervous system depression, confusion, incomprehension, nausea, potential vomiting, and severe balance loss.',
      color: badColor,
    );
  } else if (bac < 0.4) {
    return HealthStatus(
      description:
          'Potentially unconscious, with lost motor functions, inability to stand/walk, vomiting, and incontinence possible.',
      color: badColor,
    );
  } else if (bac < 0.5) {
    return HealthStatus(
      description:
          'Intense central nervous system depression, weak/absent reflexes, low temperature, stupor, and possible death from respiratory arrest.',
      color: badColor,
    );
  } else {
    return HealthStatus(
      description: 'Death from respiratory arrest.',
      color: badColor,
    );
  }
}
