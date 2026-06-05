import 'package:hive_flutter/hive_flutter.dart';
import 'package:wandly/models/character_model.dart';

class StorageService {
  static const String _characterBoxName = 'character_box';
  static const String _characterKey = 'character';

  /// Initialise Hive et ouvre la box
  Future<void> init() async {
    try {
      print('[HIVE] Initializing Hive Flutter...');
      await Hive.initFlutter();
      print('[HIVE] Hive Flutter initialized');

      print('[HIVE] Registering CharacterModelAdapter...');
      Hive.registerAdapter(CharacterModelAdapter());
      print('[HIVE] CharacterModelAdapter registered');

      print('[HIVE] Opening character_box...');
      await Hive.openBox<CharacterModel>(_characterBoxName);
      print('[HIVE] character_box opened successfully');
    } catch (e, stackTrace) {
      print('[ERROR] Hive initialization failed: $e');
      print('[ERROR] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Sauvegarde le profil du personnage
  Future<void> saveCharacter(CharacterModel character) async {
    try {
      final box = Hive.box<CharacterModel>(_characterBoxName);
      await box.put(_characterKey, character);
    } catch (e) {
      print('Erreur lors de la sauvegarde du personnage: $e');
    }
  }

  /// Récupère le profil du personnage
  CharacterModel? getCharacter() {
    try {
      final box = Hive.box<CharacterModel>(_characterBoxName);
      return box.get(_characterKey);
    } catch (e) {
      print('Erreur lors de la récupération du personnage: $e');
      return null;
    }
  }

  /// Supprime le profil du personnage
  Future<void> deleteCharacter() async {
    try {
      final box = Hive.box<CharacterModel>(_characterBoxName);
      await box.delete(_characterKey);
    } catch (e) {
      print('Erreur lors de la suppression du personnage: $e');
    }
  }

  /// Ferme Hive (optionnel)
  Future<void> close() async {
    try {
      await Hive.close();
    } catch (e) {
      print('Erreur lors de la fermeture de Hive: $e');
    }
  }
}
