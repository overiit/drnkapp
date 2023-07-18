import 'package:drnk/store/storage.dart';
import 'package:drnk/utils/apiservice.dart';
import 'package:drnk/utils/fns.dart';
import 'package:drnk/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileModel extends GetxController implements Mappable {
  final Rx<Weight> _weight = Weight(amount: 0, unit: WeightUnit.kg).obs;
  final Rx<Sex> _sex = Sex.male.obs;

  Future<void> load() async {
    await loadItem(storageUserProfileKey, overrideFromMap);
    update();
  }

  Weight get weight {
    return _weight.value;
  }

  Sex get sex {
    return _sex.value;
  }

  set sex(Sex sex) {
    _sex.value = sex;
  }

  set weight(Weight weight) {
    _weight.value = weight;
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    saveItem(storageUserProfileKey, this);
    super.update(ids, condition);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'weight': _weight.value.toMap(),
      'sex': _sex.toString(),
    };
  }

  UserProfileModel overrideFromMap(Map<String, dynamic> map) {
    weight = Weight.fromMap(map['weight']);
    sex = Sex.values.firstWhere((element) => element.toString() == map['sex']);
    update();
    return this;
  }

  void reset() {
    weight = Weight(amount: 0, unit: WeightUnit.kg);
    sex = Sex.male;
  }
}

class MarkedDrinkTimesModel extends GetxController {
  final RxList<MarkedTime> _lastMarkedDrinkTimes = <MarkedTime>[].obs;

  Future<void> load() async {
    _lastMarkedDrinkTimes.value =
        await loadList(storageMarkedDrinkTimesKey, MarkedTime.fromMap);
    update();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    saveList(storageMarkedDrinkTimesKey, _lastMarkedDrinkTimes.toList());
    super.update(ids, condition);
  }

  void reset() {
    _lastMarkedDrinkTimes.value = [];
  }
}

class DrinksModel extends GetxController {
  RxList<Drink> drinks = <Drink>[].obs;

  Future<void> load() async {
    drinks.value = await loadList(storageDrinkListKey, Drink.fromMap);
    update();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    saveList(storageDrinkListKey, drinks.toList());
    super.update(ids, condition);
  }

  void addDrink(Drink drinkInput) {
    UserProfileModel userProfile = Get.find<UserProfileModel>();

    // sort the drinks by timestamp (oldest to newest)
    drinks.sort((a, b) => a.timestamp - b.timestamp);
    // if there is a drink with the exact same drank_at, add 1 millisecond to the new drink
    var done = false;
    while (!done) {
      Drink? sameTimeDrink =
          drinks.firstWhereOrNull((d) => d.timestamp == drinkInput.timestamp);
      if (sameTimeDrink != null) {
        drinkInput.timestamp++;
      } else {
        done = true;
      }
    }

    // get the most drink that was before the new drink
    Drink? previousDrink =
        drinks.lastWhereOrNull((d) => d.timestamp < drinkInput.timestamp);

    // calculate the bac for the new drink
    drinkInput.calc = DrinkCalc(
      bacStart: calculateBacAtStart(
        userProfile,
        drinkInput,
        previousDrink == noDrink ? null : previousDrink,
      ),
      bacDrink: calculateDrinkBac(
        userProfile,
        drinkInput,
      ),
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

    // calculate for all drinks after the new drink
    calculateDrinkHistory(drinks, drinkInput.timestamp);

    // reverse the drinks for the UI
    drinks.sort((a, b) => b.timestamp - a.timestamp);

    update();

    // Tracking
    ApiService.sendTracking("ADD_DRINK");
  }

  void calculateDrinkHistory(List<Drink> drinks, int startTimestamp) {
    UserProfileModel userProfile = Get.find<UserProfileModel>();
    if (drinks.isEmpty) return;

    if (drinks.length == 1) {
      final drink = drinks.first;
      drink.calc = DrinkCalc(
        bacStart: calculateBacAtStart(userProfile, drink, null),
        bacDrink: calculateDrinkBac(userProfile, drink),
      );
      return;
    }

    // sort the drinks by timestamp (oldest to newest)
    drinks.sort((a, b) => a.timestamp - b.timestamp);

    // get the most recent drink that was before the timestamp
    int firstDrinkIndex =
        drinks.indexWhere((d) => d.timestamp >= startTimestamp);
    if (firstDrinkIndex == -1) {
      firstDrinkIndex = 0;
    }
    // calculate the bac for all drinks after the timestamp
    for (var i = firstDrinkIndex; i < drinks.length; i++) {
      final drink = drinks[i];
      final previousDrink = i > 0 ? drinks.elementAt(i - 1) : noDrink;
      // check if the previous drink is actually the previous drink and throw an error if not
      if (previousDrink != noDrink &&
          drink.timestamp < previousDrink.timestamp) {
        print('Drinks are not sorted correctly');
      }
      drink.calc = DrinkCalc(
        bacStart: calculateBacAtStart(userProfile, drink,
            previousDrink == noDrink ? null : previousDrink),
        bacDrink: calculateDrinkBac(userProfile, drink),
      );
    }
  }

  void removeDrinks(List<Drink> drinksToRemove) {
    drinks.removeWhere((drink) {
      return drinksToRemove.contains(drink);
    });

    // calculate for all drinks after the oldest drink (by timestamp)
    Drink oldestDrink =
        drinksToRemove.reduce((a, b) => a.timestamp < b.timestamp ? a : b);

    calculateDrinkHistory(drinks, oldestDrink.timestamp);

    // reverse the drinks for the UI
    drinks.sort((a, b) => b.timestamp - a.timestamp);

    saveList(storageDrinkListKey, drinks.toList());
    update();

    // Tracking
    ApiService.sendTracking("DELETE_DRINK");
  }

  void reset() {
    drinks.value = [];
  }
}

class PreferenceModel extends GetxController implements Mappable {
  final Rx<LiquidUnit> _liquidUnit = LiquidUnit.ml.obs;
  final Rx<bool> _tracking = RxBool(true);

  LiquidUnit get liquidUnit {
    return _liquidUnit.value;
  }

  set liquidUnit(LiquidUnit liquidUnit) {
    _liquidUnit.value = liquidUnit;
  }

  bool get trackingEnabled {
    return _tracking.value;
  }

  set trackingEnabled(bool enabled) {
    _tracking.value = enabled;
    update();
  }

  Future<void> load() async {
    await loadItem(storagePreferenceKey, overrideFromMap);
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    saveItem(storagePreferenceKey, this);
    super.update(ids, condition);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'liquidUnit': liquidUnit.toString(),
      'tracking': trackingEnabled,
    };
  }

  PreferenceModel overrideFromMap(Map<String, dynamic> map) {
    liquidUnit = LiquidUnit.values.firstWhere(
      (element) => element.toString() == map['liquidUnit'],
      orElse: () => LiquidUnit.ml,
    );
    trackingEnabled = map['tracking'] ?? true;
    update();
    return this;
  }

  void reset() {
    liquidUnit = LiquidUnit.ml;
  }
}

class EventsModel extends GetxController {
  final RxList<Event> _events = <Event>[].obs;

  List<Event> get events {
    return _events;
  }

  set events(List<Event> events) {
    _events.value = events;
  }

  Future<void> load() async {
    events = await loadList(storageEventListKey, Event.fromMap);
  }

  Event createEvent({String? name}) {
    Event event = Event(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name ?? "Event #${events.length + 1}",
      timestampStart: DateTime.now().millisecondsSinceEpoch,
    );
    events.add(event);
    update();

    // Tracking
    ApiService.sendTracking("ADD_EVENT");
    return event;
  }

  Event endEvent(Event event) {
    event.timestampEnd = DateTime.now().millisecondsSinceEpoch;
    DrinksModel drinksModel = Get.find<DrinksModel>();
    int drinksInEvent = drinksModel.drinks.where((drink) {
      return drink.timestamp >= event.timestampStart &&
          drink.timestamp <= event.timestampEnd!;
    }).length;

    if (drinksInEvent > 0) {
      events = [...events];
    } else {
      events.remove(event);
      // alert (Event not saved, as no drinks were added)
      Get.snackbar(
        "Event not saved",
        "No drinks were added to this event",
        backgroundColor: Colors.redAccent.withOpacity(.3),
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    }
    update();

    // Tracking
    ApiService.sendTracking("END_EVENT");
    return event;
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    saveList(storageEventListKey, events);
    super.update(ids, condition);
  }

  void reset() {
    events = [];
  }
}

class LimitModel extends GetxController {
  final Rx<Limitation?> _limitation = Rx<Limitation?>(null);

  Limitation? get limitation {
    return _limitation.value;
  }

  set limitation(Limitation? limitation) {
    final LimitType? prevLimitType = _limitation.value?.type;
    _limitation.value = limitation;
    if (limitation != null) {
      ApiService.sendTracking("LIMIT_SET_${limitation.type.name}");
    } else {
      ApiService.sendTracking("LIMIT_REMOVED_${prevLimitType?.name}");
    }
  }

  Future<void> load() async {
    await loadItem(storageLimitKey, Limitation.fromMap);
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    saveItem(storageLimitKey, limitation);
    super.update(ids, condition);
  }

  void reset() {
    limitation = null;
  }
}

class DataLoader extends GetxController {
  final RxBool _loaded = false.obs;

  bool get loaded {
    return _loaded.value;
  }

  set loaded(bool loaded) {
    _loaded.value = loaded;
  }

  @override
  void onReady() {
    load();
    super.onReady();
  }

  Future<void> load() async {
    await Get.find<UserProfileModel>().load();
    await Get.find<DrinksModel>().load();
    await Get.find<PreferenceModel>().load();
    await Get.find<EventsModel>().load();
    await Get.find<LimitModel>().load();
    await Get.find<MarkedDrinkTimesModel>().load();
    loaded = true;
    update();
  }

  void reset() {
    Get.find<UserProfileModel>().reset();
    Get.find<DrinksModel>().reset();
    Get.find<PreferenceModel>().reset();
    Get.find<EventsModel>().reset();
    Get.find<LimitModel>().reset();
    Get.find<MarkedDrinkTimesModel>().reset();
    update();
  }
}
