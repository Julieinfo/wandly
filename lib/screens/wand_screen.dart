import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/services/storage_service.dart';

class WandScreen extends ConsumerStatefulWidget {
  const WandScreen({super.key});

  @override
  ConsumerState<WandScreen> createState() => _WandScreenState();
}

class _WandScreenState extends ConsumerState<WandScreen> {
  String? _selectedWood;
  String? _selectedCore;
  double _selectedLength = 11.0;
  int _selectedFlexibility =
      1; // 0: Rigide, 1: Assez rigide, 2: Souple, 3: Très souple

  final List<String> woods = [
    'Chêne',
    'Houx',
    'Sureau',
    'Saule',
    'Ébène',
    'Frêne',
    'Cerisier',
    'Tilleul',
    'Noisetier',
    'Pin',
    'Vigne',
    'Cyprès',
    'Acacia',
    'Aulne',
    'Bouleau',
  ];

  final List<String> cores = [
    'Plume de Phénix',
    'Crin de Licorne',
    'Cœur de Dragon',
    'Cheveu de Veela',
    'Corne de Narval',
    'Écaille de Basilic',
  ];

  final List<String> flexibilityLevels = [
    'Rigide',
    'Assez rigide',
    'Souple',
    'Très souple',
  ];

  String _generateDescription() {
    if (_selectedWood == null || _selectedCore == null) {
      return 'Sélectionne un bois et un noyau pour découvrir ta baguette...';
    }

    final length = _selectedLength.toStringAsFixed(1);
    final flexibility = flexibilityLevels[_selectedFlexibility];
    return 'Ta baguette idéale : $length pouces de $_selectedWood avec un noyau de $_selectedCore, caractère $flexibility.';
  }

  Future<void> _continuePressed() async {
    if (_selectedWood == null || _selectedCore == null) return;

    // Sauvegarder les informations de baguette
    final notifier = ref.read(characterProvider.notifier);
    notifier.updateWand(
      _selectedWood!,
      _selectedCore!,
      _selectedLength.toStringAsFixed(1),
      flexibilityLevels[_selectedFlexibility],
    );

    // Persist to Hive
    await StorageService().saveCharacter(ref.read(characterProvider));

    if (mounted) {
      context.push('/patronus');
    }
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFF5E6C8);

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
                  'Ta Baguette',
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
                  'Étape 4 / 8',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    color: const Color(0xFFF5E6C8),
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1 - Bois
                      Text(
                        'Bois',
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: woods.length,
                          itemBuilder: (context, index) {
                            final wood = woods[index];
                            final isSelected = _selectedWood == wood;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(
                                    () =>
                                        _selectedWood = selected ? wood : null,
                                  );
                                },
                                label: Text(wood),
                                backgroundColor: const Color(0xFF2C0000),
                                selectedColor: const Color(0xFFAE0001),
                                labelStyle: GoogleFonts.raleway(
                                  fontSize: 12,
                                  color: isSelected ? Colors.white : creamColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : goldColor,
                                  width: 1.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Séparateur
                      Center(
                        child: Text(
                          '◆',
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            color: goldColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 2 - Noyau
                      Text(
                        'Noyau',
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: cores.length,
                          itemBuilder: (context, index) {
                            final core = cores[index];
                            final isSelected = _selectedCore == core;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(
                                    () =>
                                        _selectedCore = selected ? core : null,
                                  );
                                },
                                label: Text(core),
                                backgroundColor: const Color(0xFF2C0000),
                                selectedColor: const Color(0xFFAE0001),
                                labelStyle: GoogleFonts.raleway(
                                  fontSize: 12,
                                  color: isSelected ? Colors.white : creamColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.transparent
                                      : goldColor,
                                  width: 1.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Séparateur
                      Center(
                        child: Text(
                          '◆',
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            color: goldColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 3 - Longueur
                      Text(
                        'Longueur',
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '9"',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              color: creamColor.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            '${_selectedLength.toStringAsFixed(1)} pouces',
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
                              color: goldColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '15"',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              color: creamColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider(
                        value: _selectedLength,
                        min: 9,
                        max: 15,
                        divisions: 12,
                        activeColor: goldColor,
                        inactiveColor: const Color(0xFF2C0000),
                        onChanged: (value) {
                          setState(() => _selectedLength = value);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Séparateur
                      Center(
                        child: Text(
                          '◆',
                          style: GoogleFonts.cinzel(
                            fontSize: 16,
                            color: goldColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 4 - Souplesse
                      Text(
                        'Souplesse',
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          flexibilityLevels.length,
                          (index) => Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedFlexibility = index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedFlexibility == index
                                      ? const Color(0xFFAE0001)
                                      : const Color(0xFF2C0000),
                                  border: Border.all(
                                    color: _selectedFlexibility == index
                                        ? Colors.transparent
                                        : goldColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  flexibilityLevels[index],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: _selectedFlexibility == index
                                        ? Colors.white
                                        : creamColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description dynamique
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: goldColor, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _generateDescription(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: creamColor,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Bouton Continuer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:
                      ElevatedButton(
                        onPressed:
                            _selectedWood != null && _selectedCore != null
                            ? _continuePressed
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFAE0001),
                          disabledBackgroundColor: const Color(
                            0xFFAE0001,
                          ).withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Continuer →',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: creamColor,
                          ),
                        ),
                      ).animate().fadeIn(
                        duration: const Duration(milliseconds: 900),
                      ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
