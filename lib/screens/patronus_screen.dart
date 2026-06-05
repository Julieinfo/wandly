import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/services/storage_service.dart';

class PatronusScreen extends ConsumerStatefulWidget {
  const PatronusScreen({super.key});

  @override
  ConsumerState<PatronusScreen> createState() => _PatronusScreenState();
}

class _PatronusScreenState extends ConsumerState<PatronusScreen> {
  String? _selectedPatronus;
  String _searchQuery = '';

  final List<Map<String, String>> allPatronus = [
    {'emoji': '🦌', 'name': 'Cerf'},
    {'emoji': '🦦', 'name': 'Loutre'},
    {'emoji': '🐺', 'name': 'Loup'},
    {'emoji': '🐇', 'name': 'Lièvre'},
    {'emoji': '🐈', 'name': 'Chat'},
    {'emoji': '🐴', 'name': 'Cheval'},
    {'emoji': '🐬', 'name': 'Dauphin'},
    {'emoji': '🦢', 'name': 'Cygne'},
    {'emoji': '🦊', 'name': 'Renard'},
    {'emoji': '🐘', 'name': 'Éléphant'},
    {'emoji': '🦅', 'name': 'Aigle'},
    {'emoji': '🦉', 'name': 'Hibou'},
    {'emoji': '🐻', 'name': 'Ours'},
    {'emoji': '🐗', 'name': 'Sanglier'},
    {'emoji': '🦁', 'name': 'Lion'},
    {'emoji': '🐆', 'name': 'Léopard'},
    {'emoji': '🦋', 'name': 'Papillon'},
    {'emoji': '🐢', 'name': 'Tortue'},
    {'emoji': '🐍', 'name': 'Serpent'},
    {'emoji': '🦜', 'name': 'Perroquet'},
    {'emoji': '🐠', 'name': 'Poisson'},
    {'emoji': '🦈', 'name': 'Requin'},
    {'emoji': '🐊', 'name': 'Crocodile'},
    {'emoji': '🦏', 'name': 'Rhinocéros'},
    {'emoji': '🐧', 'name': 'Pingouin'},
    {'emoji': '🦚', 'name': 'Paon'},
    {'emoji': '🦩', 'name': 'Flamant'},
    {'emoji': '🐺', 'name': 'Loup-garou'},
    {'emoji': '🔥', 'name': 'Phénix'},
    {'emoji': '🦄', 'name': 'Licorne'},
  ];

  List<Map<String, String>> get filteredPatronus {
    if (_searchQuery.isEmpty) {
      return allPatronus;
    }
    return allPatronus
        .where(
          (p) => p['name']!.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  Future<void> _continuePressed() async {
    if (_selectedPatronus == null) return;

    // Sauvegarder le patronus sélectionné
    final notifier = ref.read(characterProvider.notifier);
    notifier.updatePatronus(_selectedPatronus!);

    // Persist to Hive
    await StorageService().saveCharacter(ref.read(characterProvider));

    if (mounted) {
      context.push('/specialty');
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
                  'Ton Patronus',
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
                  'Étape 5 / 8',
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    color: const Color(0xFFF5E6C8),
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Titre principal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child:
                    Text(
                          'Quelle créature protège ton âme ?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cinzel(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: creamColor,
                            letterSpacing: 0.5,
                          ),
                        )
                        .animate()
                        .slideY(begin: 0.2)
                        .fadeIn(duration: const Duration(milliseconds: 600)),
              ),

              const SizedBox(height: 16),

              // Barre de recherche
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: GoogleFonts.raleway(fontSize: 14, color: creamColor),
                  decoration: InputDecoration(
                    hintText: 'Chercher un patronus...',
                    hintStyle: GoogleFonts.raleway(
                      fontSize: 12,
                      color: creamColor.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(Icons.search, color: goldColor),
                    filled: true,
                    fillColor: const Color(0xFF2C0000),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFD3A625),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFD3A625),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFD3A625),
                        width: 1.5,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 700)),
              ),

              const SizedBox(height: 16),

              // Grille de patronus
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: filteredPatronus.length,
                    itemBuilder: (context, index) {
                      final patronus = filteredPatronus[index];
                      final isSelected = _selectedPatronus == patronus['name'];
                      return _buildPatronusCard(
                        patronus: patronus,
                        isSelected: isSelected,
                        index: index,
                        goldColor: goldColor,
                        creamColor: creamColor,
                        onTap: () => setState(
                          () => _selectedPatronus = patronus['name'],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bouton Continuer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:
                      ElevatedButton(
                        onPressed: _selectedPatronus != null
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

  Widget _buildPatronusCard({
    required Map<String, String> patronus,
    required bool isSelected,
    required int index,
    required Color goldColor,
    required Color creamColor,
    required VoidCallback onTap,
  }) {
    final animationDelay = Duration(milliseconds: index * 50);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF2C0000),
          border: Border.all(
            color: isSelected ? goldColor : goldColor.withValues(alpha: 0.5),
            width: isSelected ? 2.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Contenu - centré
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                        patronus['emoji']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 40),
                      )
                      .animate()
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        delay: animationDelay,
                        duration: const Duration(milliseconds: 400),
                      )
                      .fadeIn(
                        delay: animationDelay,
                        duration: const Duration(milliseconds: 400),
                      ),
                  const SizedBox(height: 8),
                  Text(
                    patronus['name']!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 11,
                      color: creamColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(
                    delay: animationDelay,
                    duration: const Duration(milliseconds: 400),
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
                          delay: animationDelay,
                          duration: const Duration(milliseconds: 300),
                        )
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.0, 1.0),
                          delay: animationDelay,
                          duration: const Duration(milliseconds: 300),
                        ),
              ),
          ],
        ),
      ),
    );
  }
}
