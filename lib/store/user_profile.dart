import 'dart:async';
import 'dart:convert';
import 'package:drnk/utils/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Helper functions
Future<void> saveUserProfile(UserProfile? userProfile) async {
  if (userProfile == null) {
    await clearUserProfile();
    return;
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert UserProfile to JSON-like data
  Map<String, Object> userProfileData = {
    'gender': userProfile.gender.toString(),
    'weight.amount': userProfile.weight.amount,
    'weight.unit': userProfile.weight.unit.toString(),
  };

  // Save the user profile to SharedPreferences as a string
  await prefs.setString('userProfile', jsonEncode(userProfileData));
}

Future<UserProfile?> loadUserProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if userProfile exists in SharedPreferences
  if (prefs.containsKey('userProfile')) {
    String userProfileDataString = prefs.getString('userProfile')!;

    // Decode the JSON-like data
    Map<String, dynamic> userProfileData = jsonDecode(userProfileDataString);

    // Construct a UserProfile object using the data
    UserProfile userProfile = UserProfile(
      gender: Gender.values.firstWhere(
          (element) => element.toString() == userProfileData['gender']),
      weight: Weight(
        amount: userProfileData['weight.amount'],
        unit: WeightUnit.values.firstWhere(
            (element) => element.toString() == userProfileData['weight.unit']),
      ),
    );

    return userProfile;
  }

  return null;
}

Future<void> clearUserProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('userProfile');
}
