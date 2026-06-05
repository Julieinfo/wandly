// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterModelAdapter extends TypeAdapter<CharacterModel> {
  @override
  final int typeId = 0;

  @override
  CharacterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterModel(
      firstName: fields[0] as String?,
      lastName: fields[1] as String?,
      birthDate: fields[2] as DateTime?,
      gender: fields[3] as String?,
      country: fields[4] as String?,
      photoPath: fields[5] as String?,
      bloodStatus: fields[6] as String?,
      house: fields[7] as String?,
      familiarSpecies: fields[8] as String?,
      familiarName: fields[9] as String?,
      specialty1: fields[10] as String?,
      specialty2: fields[11] as String?,
      specialtyTitle: fields[12] as String?,
      arrivalYear: fields[13] as int?,
      currentYear: fields[14] as String?,
      wandWood: fields[15] as String?,
      wandCore: fields[16] as String?,
      wandLength: fields[17] as String?,
      wandFlexibility: fields[18] as String?,
      patronus: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.birthDate)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.photoPath)
      ..writeByte(6)
      ..write(obj.bloodStatus)
      ..writeByte(7)
      ..write(obj.house)
      ..writeByte(8)
      ..write(obj.familiarSpecies)
      ..writeByte(9)
      ..write(obj.familiarName)
      ..writeByte(10)
      ..write(obj.specialty1)
      ..writeByte(11)
      ..write(obj.specialty2)
      ..writeByte(12)
      ..write(obj.specialtyTitle)
      ..writeByte(13)
      ..write(obj.arrivalYear)
      ..writeByte(14)
      ..write(obj.currentYear)
      ..writeByte(15)
      ..write(obj.wandWood)
      ..writeByte(16)
      ..write(obj.wandCore)
      ..writeByte(17)
      ..write(obj.wandLength)
      ..writeByte(18)
      ..write(obj.wandFlexibility)
      ..writeByte(19)
      ..write(obj.patronus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
