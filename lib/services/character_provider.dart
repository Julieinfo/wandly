import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandly/models/character_model.dart';

class CharacterNotifier extends StateNotifier<CharacterModel> {
  CharacterNotifier()
    : super(
        CharacterModel()
          ..firstName = null
          ..lastName = null
          ..birthDate = null
          ..gender = null
          ..country = null
          ..photoPath = null,
      );

  void updateIdentity(
    String firstName,
    String lastName,
    DateTime birthDate,
    String gender,
    String country,
    String? photoPath,
  ) {
    state = CharacterModel()
      ..firstName = firstName
      ..lastName = lastName
      ..birthDate = birthDate
      ..gender = gender
      ..country = country
      ..photoPath = photoPath;
  }

  void updateBloodStatus(String bloodStatus) {
    state = state.copyWith(bloodStatus: bloodStatus);
  }

  void updateHouse(String house) {
    state = state.copyWith(house: house);
  }

  void updateFamiliar({required String species, required String name}) {
    state = state.copyWith(familiarSpecies: species, familiarName: name);
  }

  void updateSpecialties(String specialty1, String specialty2, String title) {
    state = state.copyWith(
      specialty1: specialty1,
      specialty2: specialty2,
      specialtyTitle: title,
    );
  }

  void updateSchooling(int arrivalYear, String currentYear) {
    state = state.copyWith(arrivalYear: arrivalYear, currentYear: currentYear);
  }

  void updateWand(String wood, String core, String length, String flexibility) {
    state = state.copyWith(
      wandWood: wood,
      wandCore: core,
      wandLength: length,
      wandFlexibility: flexibility,
    );
  }

  void updatePatronus(String patronus) {
    state = state.copyWith(patronus: patronus);
  }

  void reset() {
    state = CharacterModel()
      ..firstName = null
      ..lastName = null
      ..birthDate = null
      ..gender = null
      ..country = null
      ..photoPath = null
      ..bloodStatus = null
      ..house = null
      ..familiarSpecies = null
      ..familiarName = null
      ..specialty1 = null
      ..specialty2 = null
      ..specialtyTitle = null
      ..arrivalYear = null
      ..currentYear = null
      ..wandWood = null
      ..wandCore = null
      ..wandLength = null
      ..wandFlexibility = null
      ..patronus = null;
  }

  void setCharacter(CharacterModel character) {
    state = character;
  }
}

final characterProvider =
    StateNotifierProvider<CharacterNotifier, CharacterModel>(
      (ref) => CharacterNotifier(),
    );
