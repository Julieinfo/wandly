import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wandly/models/character_model.dart';
import 'package:wandly/services/storage_service.dart';
import 'package:wandly/services/character_provider.dart';
import 'dart:io';

class IdentityScreen extends ConsumerStatefulWidget {
  const IdentityScreen({super.key});

  @override
  ConsumerState<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends ConsumerState<IdentityScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime? _birthDate;
  String? _selectedGender;
  String? _selectedCountry;
  File? _profilePhoto;

  final List<String> francophoneCountries = [
    'Sélectionner un pays',
    'France',
    'Belgique',
    'Suisse',
    'Canada',
    'Maroc',
    'Madagascar',
    'Algérie',
    'Tunisie',
    'Sénégal',
    'Côte d\'Ivoire',
    'Cameroun',
    'Congo',
    'Luxembourg',
    'Haïti',
    'Liban',
    'Autres',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingCharacter();
  }

  Future<void> _loadExistingCharacter() async {
    final storageService = StorageService();
    final existingCharacter = storageService.getCharacter();

    if (existingCharacter != null && mounted) {
      setState(() {
        if (existingCharacter.firstName != null) {
          _firstNameController.text = existingCharacter.firstName!;
        }
        if (existingCharacter.lastName != null) {
          _lastNameController.text = existingCharacter.lastName!;
        }
        if (existingCharacter.birthDate != null) {
          _birthDate = existingCharacter.birthDate;
        }
        if (existingCharacter.gender != null) {
          _selectedGender = existingCharacter.gender;
        }
        if (existingCharacter.country != null) {
          _selectedCountry = existingCharacter.country;
        }
        if (existingCharacter.photoPath != null) {
          _profilePhoto = File(existingCharacter.photoPath!);
        }
      });
    }
  }

  Future<bool> _requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      // Pour Android 13+, utiliser READ_MEDIA_IMAGES ou READ_MEDIA_VIDEO
      final PermissionStatus status;
      if (await Permission.photos.isDenied) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.photos.status;
      }
      return status.isGranted;
    } else {
      // Pour iOS
      final PermissionStatus status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 11)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 120)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 11)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFFD3A625),
              surface: const Color(0xFF2C0000),
              onSurface: const Color(0xFFF5E6C8),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  bool get _isFormValid =>
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty;

  Future<void> _pickAndCropImage(ImageSource source) async {
    // Demander les permissions appropriées
    bool permissionGranted = false;

    if (source == ImageSource.camera) {
      permissionGranted = await _requestCameraPermission();
      if (!permissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Permission d\'accès à la caméra refusée',
                style: GoogleFonts.raleway(color: const Color(0xFFF5E6C8)),
              ),
              backgroundColor: const Color(0xFF8B0000),
            ),
          );
        }
        return;
      }
    } else {
      permissionGranted = await _requestGalleryPermission();
      if (!permissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Permission d\'accès à la galerie refusée',
                style: GoogleFonts.raleway(color: const Color(0xFFF5E6C8)),
              ),
              backgroundColor: const Color(0xFF8B0000),
            ),
          );
        }
        return;
      }
    }

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recadrer la photo',
            toolbarColor: const Color(0xFF2C0000),
            toolbarWidgetColor: const Color(0xFFD3A625),
            backgroundColor: const Color(0xFF1A0000),
            activeControlsWidgetColor: const Color(0xFFD3A625),
            statusBarColor: const Color(0xFF1A0000),
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _profilePhoto = File(croppedFile.path);
        });
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  void _showPhotoBottomSheet() {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFF5E6C8);
    const darkFieldColor = Color(0xFF2C0000);

    showModalBottomSheet(
      context: context,
      backgroundColor: darkFieldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: goldColor, width: 1),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: goldColor),
                title: Text(
                  'Prendre une photo',
                  style: GoogleFonts.raleway(fontSize: 14, color: creamColor),
                ),
                onTap: () => _pickAndCropImage(ImageSource.camera),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.image, color: goldColor),
                title: Text(
                  'Choisir depuis la galerie',
                  style: GoogleFonts.raleway(fontSize: 14, color: creamColor),
                ),
                onTap: () => _pickAndCropImage(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFF5E6C8);
    const darkFieldColor = Color(0xFF2C0000);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF1A0000), const Color(0xFF2C0000)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFFD3A625)),
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go('/home'),
                ),
                title: Text(
                  'Mon Identité',
                  style: GoogleFonts.cinzel(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD3A625),
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              // Indicateur de progression
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Text(
                  'Étape 1 / 8',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    color: const Color(0xFFF5E6C8),
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Formulaire
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section photo de profil
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _showPhotoBottomSheet,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: goldColor,
                                    width: 2,
                                  ),
                                  color: darkFieldColor,
                                ),
                                child: _profilePhoto == null
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 40,
                                            color: goldColor,
                                          ),
                                        ],
                                      )
                                    : ClipOval(
                                        child: Image.file(
                                          _profilePhoto!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ).animate().fadeIn(
                              duration: const Duration(milliseconds: 500),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ajouter une photo',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: creamColor,
                              ),
                            ).animate().fadeIn(
                              duration: const Duration(milliseconds: 550),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Prénom
                      Text(
                        'Prénom',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 600),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _firstNameController,
                        hintText: 'Entrez votre prénom',
                        onChanged: (_) => setState(() {}),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 700),
                      ),
                      const SizedBox(height: 24),

                      // Nom de famille
                      Text(
                        'Nom de famille',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 800),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _lastNameController,
                        hintText: 'Entrez votre nom',
                        onChanged: (_) => setState(() {}),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 900),
                      ),
                      const SizedBox(height: 24),

                      // Date de naissance
                      Text(
                        'Date de naissance',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 1000),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectBirthDate(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: darkFieldColor,
                            border: Border.all(color: goldColor, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: goldColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _birthDate != null
                                    ? DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_birthDate!)
                                    : 'Sélectionner une date',
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  color: _birthDate != null
                                      ? creamColor
                                      : creamColor.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 1100),
                      ),
                      const SizedBox(height: 24),

                      // Sexe
                      Text(
                        'Sexe',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 1200),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildToggleButton(
                              label: 'Masculin',
                              isSelected: _selectedGender == 'Masculin',
                              onPressed: () =>
                                  setState(() => _selectedGender = 'Masculin'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildToggleButton(
                              label: 'Féminin',
                              isSelected: _selectedGender == 'Féminin',
                              onPressed: () =>
                                  setState(() => _selectedGender = 'Féminin'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildToggleButton(
                              label: 'Non précisé',
                              isSelected: _selectedGender == 'Non précisé',
                              onPressed: () => setState(
                                () => _selectedGender = 'Non précisé',
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 1300),
                      ),
                      const SizedBox(height: 24),

                      // Pays d'origine
                      Text(
                        'Pays d\'origine',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 1400),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: darkFieldColor,
                          border: Border.all(color: goldColor, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedCountry ?? 'Sélectionner un pays',
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountry = newValue;
                            });
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: const Color(0xFF1A0000),
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: creamColor,
                          ),
                          items: francophoneCountries
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Text(value),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 1500),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Bouton Continuer
              Padding(
                padding: const EdgeInsets.all(24),
                child:
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isFormValid
                            ? () async {
                                // Créer le modèle de caractère
                                final character = CharacterModel()
                                  ..firstName = _firstNameController.text
                                  ..lastName = _lastNameController.text
                                  ..birthDate = _birthDate
                                  ..gender = _selectedGender
                                  ..country = _selectedCountry
                                  ..photoPath = _profilePhoto?.path;

                                // Mettre à jour le Riverpod provider
                                ref
                                    .read(characterProvider.notifier)
                                    .updateIdentity(
                                      _firstNameController.text,
                                      _lastNameController.text,
                                      _birthDate!,
                                      _selectedGender!,
                                      _selectedCountry!,
                                      _profilePhoto?.path,
                                    );

                                // Sauvegarder via StorageService
                                await StorageService().saveCharacter(character);

                                // Naviguer vers l'étape suivante
                                if (mounted) {
                                  context.push('/blood-status');
                                }
                              }
                            : null,
                        child: Text(
                          'Continuer →',
                          style: GoogleFonts.cinzel(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 1600),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Function(String) onChanged,
  }) {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFF5E6C8);
    const darkFieldColor = Color(0xFF2C0000);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: GoogleFonts.raleway(fontSize: 14, color: creamColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.raleway(
          fontSize: 14,
          color: creamColor.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: darkFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: goldColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: goldColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: goldColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    const goldColor = Color(0xFFD3A625);
    const primaryRed = Color(0xFFAE0001);
    const creamColor = Color(0xFFF5E6C8);
    const darkFieldColor = Color(0xFF2C0000);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? primaryRed : darkFieldColor,
        side: BorderSide(
          color: isSelected ? goldColor : goldColor.withValues(alpha: 0.5),
          width: isSelected ? 2 : 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        style: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected ? creamColor : creamColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
