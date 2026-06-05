import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/services/storage_service.dart';

class SchoolingScreen extends ConsumerStatefulWidget {
  const SchoolingScreen({super.key});

  @override
  ConsumerState<SchoolingScreen> createState() => _SchoolingScreenState();
}

class _SchoolingScreenState extends ConsumerState<SchoolingScreen> {
  int _arrivalYear = 1991;
  String? _currentYear;

  final Map<String, List<String>> courses = {
    '1': [
      'Potions',
      'Métamorphose',
      'Défense contre les forces du Mal',
      'Sortilèges',
      'Astronomie',
      'Herbologie',
      'Histoire de la Magie',
    ],
    '2': [
      'Potions (avancé)',
      'Métamorphose',
      'Défense contre les forces du Mal',
      'Sortilèges',
      'Alchimie',
      'Herbologie',
      'Divination',
    ],
    '3': [
      'Potions (expert)',
      'Métamorphose',
      'Défense contre les forces du Mal (élite)',
      'Sortilèges avancés',
      'Alchimie',
      'Soins aux créatures magiques',
      'Arithmancie',
    ],
    '4': [
      'Potions (maître)',
      'Métamorphose complexe',
      'Défense et Attaque',
      'Duellisme',
      'Alchimie avancée',
      'Droits magiques',
      'Enchantements',
    ],
    '5': [
      'Potions (perfectionnement)',
      'Métamorphose',
      'Défense contre les forces du Mal',
      'Epreuve de maîtrise',
      'Magie ancienne',
      'Rituel magique',
      'Théorie de la magie',
    ],
    '6': [
      'Alchemy Master',
      'Transfiguration avancée',
      'Défense Impériale',
      'Combat magique',
      'Magie ancienne',
      'Enchantements maîtrise',
      'Spécialisation personnelle',
    ],
    '7': [
      'Potions maîtrise',
      'Métamorphose épique',
      'Défense suprême',
      'Magie noire blanche',
      'Alchimie suprême',
      'Magie ancienne',
      'Thèse à présenter',
    ],
    'Diplômé': [
      'Études supérieures',
      'Recherche personnelle',
      'Spécialisation professionnelle',
      'Alchimie avancée',
      'Magie ancienne',
      'Mentoring',
      'Création de sorts',
    ],
  };

  String _getHistoricalContext(int year) {
    if (year >= 1991 && year <= 1998) {
      return '⚡ Tu étudies aux côtés de Harry Potter';
    } else if (year >= 1970 && year <= 1990) {
      return '🌑 Tu vis l\'ère sombre de Voldemort';
    } else if (year >= 1850 && year <= 1969) {
      return '📜 Tu fais partie de l\'ère classique de Poudlard';
    } else if (year >= 1999 && year <= 2010) {
      return '🌟 Tu reconstruis le monde après la bataille';
    } else {
      return '✨ Tu fais partie de la nouvelle génération';
    }
  }

  String _getTimelinePeriod(int year) {
    return 'Arrivée en $year → Diplôme en ${year + 7}';
  }

  Future<void> _continuePressed() async {
    if (_currentYear == null) return;

    ref
        .read(characterProvider.notifier)
        .updateSchooling(_arrivalYear, _currentYear!);

    // Persist to Hive
    await StorageService().saveCharacter(ref.read(characterProvider));

    if (mounted) {
      context.push('/summary');
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
                  'Ta Scolarité',
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
                  'Étape 8 / 8',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    color: const Color(0xFFF5E6C8),
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // Section 1 - Année d'arrivée
                        _buildArrivalYearSection(goldColor, creamColor),

                        const SizedBox(height: 24),

                        // Séparateur doré
                        Center(
                          child: Text(
                            '◆',
                            style: TextStyle(color: goldColor, fontSize: 24),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Section 2 - Année en cours
                        _buildCurrentYearSection(goldColor, creamColor),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // Bouton Continuer
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _currentYear != null ? _continuePressed : null,
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
                        color: _currentYear != null
                            ? creamColor
                            : creamColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArrivalYearSection(Color goldColor, Color creamColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Quand as-tu rejoint Poudlard ?',
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: 16,
            color: creamColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),

        // Sélecteur d'année
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton précédent
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_arrivalYear > 1850) _arrivalYear--;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: goldColor, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.chevron_left, color: goldColor, size: 24),
              ),
            ),

            const SizedBox(width: 24),

            // Année affichée
            Text(
              _arrivalYear.toString(),
              style: GoogleFonts.cinzel(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: goldColor,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(width: 24),

            // Bouton suivant
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_arrivalYear < 2100) _arrivalYear++;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: goldColor, width: 1.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.chevron_right, color: goldColor, size: 24),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Frise temporelle
        Text(
          _getTimelinePeriod(_arrivalYear),
          style: GoogleFonts.raleway(
            fontSize: 12,
            color: creamColor,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        // Contexte historique
        Text(
          _getHistoricalContext(_arrivalYear),
          textAlign: TextAlign.center,
          style: GoogleFonts.raleway(
            fontSize: 13,
            color: goldColor,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentYearSection(Color goldColor, Color creamColor) {
    final years = ['1', '2', '3', '4', '5', '6', '7', 'Diplômé'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'En quelle année es-tu ?',
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            fontSize: 16,
            color: creamColor,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

        // Grille 4x2 de boutons
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2,
          ),
          itemCount: years.length,
          itemBuilder: (context, index) {
            final year = years[index];
            final isSelected = _currentYear == year;

            return GestureDetector(
              onTap: () {
                setState(() => _currentYear = year);
              },
              child:
                  Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFAE0001)
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFAE0001)
                                : goldColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            year == 'Diplômé' ? '📜' : '$year\u{00B0}e',
                            style: GoogleFonts.raleway(
                              fontSize: year == 'Diplômé' ? 18 : 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : creamColor,
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 300))
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.0, 1.0),
                        duration: const Duration(milliseconds: 300),
                      ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Liste des cours
        if (_currentYear != null)
          Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: goldColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tes cours:',
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...courses[_currentYear]!.map((course) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              '▸ ',
                              style: TextStyle(color: goldColor, fontSize: 12),
                            ),
                            Expanded(
                              child: Text(
                                course,
                                style: GoogleFonts.raleway(
                                  fontSize: 12,
                                  color: creamColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              )
              .animate()
              .slideY(
                begin: 0.2,
                end: 0,
                duration: const Duration(milliseconds: 400),
              )
              .fadeIn(duration: const Duration(milliseconds: 400)),
      ],
    );
  }
}
