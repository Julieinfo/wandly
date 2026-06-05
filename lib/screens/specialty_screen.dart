import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/services/storage_service.dart';

class SpecialtyScreen extends ConsumerStatefulWidget {
  const SpecialtyScreen({super.key});

  @override
  ConsumerState<SpecialtyScreen> createState() => _SpecialtyScreenState();
}

class _SpecialtyScreenState extends ConsumerState<SpecialtyScreen> {
  final List<Map<String, dynamic>> specialties = [
    {
      'emoji': '🔮',
      'name': 'Divination',
      'description': 'Voir le passé et l\'avenir',
      'id': 'divination',
    },
    {
      'emoji': '🌿',
      'name': 'Herboriste',
      'description': 'Maîtrise des plantes magiques',
      'id': 'herboriste',
    },
    {
      'emoji': '⚡',
      'name': 'Duelliste',
      'description': 'Expert en sorts de combat',
      'id': 'duelliste',
    },
    {
      'emoji': '🧪',
      'name': 'Potionneur',
      'description': 'Création de potions complexes',
      'id': 'potionneur',
    },
    {
      'emoji': '🐉',
      'name': 'Dragonologue',
      'description': 'Communication avec les créatures',
      'id': 'dragonologue',
    },
    {
      'emoji': '🌌',
      'name': 'Astronome',
      'description': 'Navigation et sorts célestes',
      'id': 'astronome',
    },
    {
      'emoji': '🛡️',
      'name': 'Auror',
      'description': 'Protection contre les forces du mal',
      'id': 'auror',
    },
    {
      'emoji': '📜',
      'name': 'Enchanteur',
      'description': 'Création d\'artefacts magiques',
      'id': 'enchanteur',
    },
    {
      'emoji': '🧠',
      'name': 'Occlumente',
      'description': 'Maîtrise de l\'esprit',
      'id': 'occlumente',
    },
    {
      'emoji': '🌀',
      'name': 'Animagus',
      'description': 'Transformation en animal',
      'id': 'animagus',
    },
  ];

  final Set<String> _selectedSpecialties = {};

  String _generateSpecialtyTitle() {
    if (_selectedSpecialties.length != 2) return '';

    final ids = _selectedSpecialties.toList();
    final pair = ids.toSet();

    if ((pair.contains('duelliste') && pair.contains('auror'))) {
      return '🏅 Défenseur de l\'Ordre';
    } else if ((pair.contains('potionneur') && pair.contains('herboriste'))) {
      return '🌱 Maître des Éléments';
    } else if ((pair.contains('animagus') && pair.contains('occlumente'))) {
      return '🌑 Ombre Silencieuse';
    } else if ((pair.contains('divination') && pair.contains('astronome'))) {
      return '✨ Gardien des Étoiles';
    } else {
      return '🧙 Sorcier Polyvalent';
    }
  }

  Future<void> _continuePressed() async {
    if (_selectedSpecialties.length != 2) return;

    final specialtyList = _selectedSpecialties.toList();
    final title = _generateSpecialtyTitle();

    ref
        .read(characterProvider.notifier)
        .updateSpecialties(specialtyList[0], specialtyList[1], title);

    // Persist to Hive
    await StorageService().saveCharacter(ref.read(characterProvider));

    if (mounted) {
      context.push('/familiar');
    }
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);
    const creamColor = Color(0xFFFAF0E6);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0000), Color(0xFF2C0000)],
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
                  'Tes Spécialités',
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
                  'Étape 6 / 8',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    color: const Color(0xFFF5E6C8),
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              // Titre section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Text(
                  'Dans quels domaines excelles-tu ?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    color: creamColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Sous-titre avec compteur
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choisis 2 spécialités',
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        color: goldColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${_selectedSpecialties.length}/2 sélectionnées)',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: creamColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Grille de spécialités
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: specialties.length,
                    itemBuilder: (context, index) {
                      final specialty = specialties[index];
                      final id = specialty['id'] as String;
                      final isSelected = _selectedSpecialties.contains(id);
                      final isDisabled =
                          _selectedSpecialties.length == 2 && !isSelected;

                      return _buildSpecialtyCard(
                        specialty: specialty,
                        isSelected: isSelected,
                        isDisabled: isDisabled,
                        index: index,
                        goldColor: goldColor,
                        creamColor: creamColor,
                        onTap: isDisabled
                            ? null
                            : () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedSpecialties.remove(id);
                                  } else {
                                    _selectedSpecialties.add(id);
                                  }
                                });
                              },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card titre spécial (affiché quand 2 sélectionnées)
              if (_selectedSpecialties.length == 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  goldColor.withValues(alpha: 0.2),
                                  goldColor.withValues(alpha: 0.4),
                                ],
                              ),
                              border: Border.all(color: goldColor, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                _generateSpecialtyTitle(),
                                style: GoogleFonts.cinzel(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: goldColor,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            duration: const Duration(milliseconds: 400),
                          )
                          .fadeIn(duration: const Duration(milliseconds: 400)),
                )
              else
                const SizedBox(height: 36),

              const SizedBox(height: 16),

              // Bouton Continuer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _selectedSpecialties.length == 2
                        ? _continuePressed
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAE0001),
                      disabledBackgroundColor: const Color(
                        0xFFAE0001,
                      ).withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continuer →',
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _selectedSpecialties.length == 2
                            ? creamColor
                            : creamColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyCard({
    required Map<String, dynamic> specialty,
    required bool isSelected,
    required bool isDisabled,
    required int index,
    required Color goldColor,
    required Color creamColor,
    required VoidCallback? onTap,
  }) {
    final emoji = specialty['emoji'] as String;
    final name = specialty['name'] as String;
    final description = specialty['description'] as String;

    return GestureDetector(
      onTap: onTap,
      child:
          Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFAE0001)
                      : const Color(0xFF2C0000),
                  border: Border.all(
                    color: isSelected
                        ? goldColor
                        : goldColor.withValues(alpha: 0.6),
                    width: isSelected ? 2 : 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Contenu
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 48)),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cinzel(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              fontSize: 11,
                              color: creamColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Coche sélection
                    if (isSelected)
                      Positioned(
                        top: 6,
                        right: 6,
                        child:
                            Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: goldColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Color(0xFF1A0000),
                                      size: 14,
                                      weight: 900,
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(
                                  duration: const Duration(milliseconds: 300),
                                )
                                .scale(
                                  begin: const Offset(0.5, 0.5),
                                  end: const Offset(1.0, 1.0),
                                  duration: const Duration(milliseconds: 300),
                                ),
                      ),

                    // Désactivé overlay
                    if (isDisabled)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                  ],
                ),
              )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: index * 50),
                duration: const Duration(milliseconds: 400),
              )
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                delay: Duration(milliseconds: index * 50),
                duration: const Duration(milliseconds: 400),
              ),
    );
  }
}
