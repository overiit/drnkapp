import 'package:drnk/store/storage.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:get/get.dart';

class UserProfileModel extends GetxController implements Mappable {
  Rx<Weight> weight = Weight(amount: 0, unit: WeightUnit.kg).obs;
  Rx<Sex> sex = Sex.male.obs;

  Future<void> load() async {
    await loadItem(storageUserProfileKey, overrideFromMap);
    update();
  }

  void setSex(Sex sex) {
    this.sex.value = sex;
  }

  void setWeight(Weight weight) {
    this.weight.value = weight;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'weight': weight.value.toMap(),
      'sex': sex.toString(),
    };
  }

  UserProfileModel overrideFromMap(Map<String, dynamic> map) {
    weight.value = Weight.fromMap(map['weight']);
    sex.value =
        Sex.values.firstWhere((element) => element.toString() == map['sex']);
    update();
    return this;
  }
}

class DrinksModel extends GetxController implements Mappable {
  RxList<Drink> drinks = <Drink>[].obs;

  Future<void> load() async {
    drinks.value = await loadList(storageDrinkListKey, Drink.fromMap);
    update();
  }

  void addDrink(Drink drinkInput) {
    UserProfileModel userProfile = Get.find<UserProfileModel>();

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
      if (previousDrink != noDrink &&
          drink.timestamp < previousDrink.timestamp) {
        print('Drinks are not sorted correctly');
      }
      if (drink.timestamp < lastTimestamp) {
        print('Drinks are not sorted correctly');
      }
      drink.calc = DrinkCalc(
        bacStart: calculateBacAtStart(userProfile, drink,
            previousDrink == noDrink ? null : previousDrink),
        bacDrink: calculateDrinkBac(userProfile, drink),
      );
    }

    // reverse the drinks for the UI
    drinks.sort((a, b) => b.timestamp - a.timestamp);

    // save the drinks to the database
    saveList(storageDrinkListKey, drinks);

    update();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'drinks': drinks.map((e) => e.toMap()).toList(),
    };
  }
}

class PreferenceModel extends GetxController implements Mappable {
  Rx<WeightUnit> weightUnit = WeightUnit.kg.obs;
  Rx<LiquidUnit> liquidUnit = LiquidUnit.ml.obs;

  Future<void> load() async {
    await loadItem(storagePreferenceKey, overrideFromMap);
  }

  void setWeightUnit(WeightUnit weightUnit) {
    this.weightUnit.value = weightUnit;
  }

  void setLiquidUnit(LiquidUnit liquidUnit) {
    this.liquidUnit.value = liquidUnit;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'weightUnit': weightUnit.toString(),
      'liquidUnit': liquidUnit.toString(),
    };
  }

  PreferenceModel overrideFromMap(Map<String, dynamic> map) {
    weightUnit.value = WeightUnit.values.firstWhere(
      (element) => element.toString() == map['weightUnit'],
      orElse: () => WeightUnit.kg,
    );
    liquidUnit.value = LiquidUnit.values.firstWhere(
      (element) => element.toString() == map['liquidUnit'],
      orElse: () => LiquidUnit.ml,
    );
    update();
    return this;
  }
}

class DataLoader extends GetxController {
  RxBool loaded = false.obs;

  @override
  void onReady() {
    load();
    super.onReady();
  }

  Future<void> load() async {
    await Get.find<UserProfileModel>().load();
    await Get.find<DrinksModel>().load();
    await Get.find<PreferenceModel>().load();
    loaded.value = true;
    update();
  }
}
