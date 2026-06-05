import 'package:hive/hive.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel {
  @HiveField(0)
  String? firstName;

  @HiveField(1)
  String? lastName;

  @HiveField(2)
  DateTime? birthDate;

  @HiveField(3)
  String? gender;

  @HiveField(4)
  String? country;

  @HiveField(5)
  String? photoPath;

  @HiveField(6)
  String? bloodStatus;

  @HiveField(7)
  String? house;

  @HiveField(8)
  String? familiarSpecies;

  @HiveField(9)
  String? familiarName;

  @HiveField(10)
  String? specialty1;

  @HiveField(11)
  String? specialty2;

  @HiveField(12)
  String? specialtyTitle;

  @HiveField(13)
  int? arrivalYear;

  @HiveField(14)
  String? currentYear;

  @HiveField(15)
  String? wandWood;

  @HiveField(16)
  String? wandCore;

  @HiveField(17)
  String? wandLength;

  @HiveField(18)
  String? wandFlexibility;

  @HiveField(19)
  String? patronus;

  CharacterModel({
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.country,
    this.photoPath,
    this.bloodStatus,
    this.house,
    this.familiarSpecies,
    this.familiarName,
    this.specialty1,
    this.specialty2,
    this.specialtyTitle,
    this.arrivalYear,
    this.currentYear,
    this.wandWood,
    this.wandCore,
    this.wandLength,
    this.wandFlexibility,
    this.patronus,
  });

  CharacterModel copyWith({
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    String? gender,
    String? country,
    String? photoPath,
    String? bloodStatus,
    String? house,
    String? familiarSpecies,
    String? familiarName,
    String? specialty1,
    String? specialty2,
    String? specialtyTitle,
    int? arrivalYear,
    String? currentYear,
    String? wandWood,
    String? wandCore,
    String? wandLength,
    String? wandFlexibility,
    String? patronus,
  }) {
    return CharacterModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      photoPath: photoPath ?? this.photoPath,
      bloodStatus: bloodStatus ?? this.bloodStatus,
      house: house ?? this.house,
      familiarSpecies: familiarSpecies ?? this.familiarSpecies,
      familiarName: familiarName ?? this.familiarName,
      specialty1: specialty1 ?? this.specialty1,
      specialty2: specialty2 ?? this.specialty2,
      specialtyTitle: specialtyTitle ?? this.specialtyTitle,
      arrivalYear: arrivalYear ?? this.arrivalYear,
      currentYear: currentYear ?? this.currentYear,
      wandWood: wandWood ?? this.wandWood,
      wandCore: wandCore ?? this.wandCore,
      wandLength: wandLength ?? this.wandLength,
      wandFlexibility: wandFlexibility ?? this.wandFlexibility,
      patronus: patronus ?? this.patronus,
    );
  }
}
