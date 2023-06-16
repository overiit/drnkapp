import 'package:drnk/utils/types.dart';
import 'package:get/get.dart';

class PreferenceModel extends GetxController implements Mappable {
  Rx<WeightUnit> weightUnit = WeightUnit.kg.obs;
  Rx<LiquidUnit> liquidUnit = LiquidUnit.ml.obs;

  void setWeightUnit(WeightUnit weightUnit) {
    this.weightUnit.value = weightUnit;
    update();
  }

  void setLiquidUnit(LiquidUnit liquidUnit) {
    this.liquidUnit.value = liquidUnit;
    update();
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
        orElse: () => WeightUnit.kg);
    liquidUnit.value = LiquidUnit.values.firstWhere(
        (element) => element.toString() == map['liquidUnit'],
        orElse: () => LiquidUnit.ml);
    return this;
  }
}
