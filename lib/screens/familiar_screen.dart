import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/services/storage_service.dart';

// État pour l'onglet actif
final familiarTabProvider = StateProvider<String>((ref) => 'owls');

// État pour le familier sélectionné
final selectedFamiliarProvider = StateProvider<String?>((ref) => null);

class FamiliarScreen extends ConsumerStatefulWidget {
  const FamiliarScreen({super.key});

  @override
  ConsumerState<FamiliarScreen> createState() => _FamiliarScreenState();
}

class _FamiliarScreenState extends ConsumerState<FamiliarScreen> {
  late TextEditingController _nameController;

  final Map<String, List<Map<String, String>>> familiars = {
    'owls': [
      {'emoji': '🦉', 'name': 'Harfang des neiges'},
      {'emoji': '🦉', 'name': 'Effraie'},
      {'emoji': '🦉', 'name': 'Grand-duc'},
      {'emoji': '🦉', 'name': 'Chevêche'},
      {'emoji': '🦉', 'name': 'Hulotte'},
      {'emoji': '🦉', 'name': 'Petit-duc'},
    ],
    'cats': [
      {'emoji': '🐈', 'name': 'Persan'},
      {'emoji': '🐈', 'name': 'Abyssin'},
      {'emoji': '🐈', 'name': 'Roux'},
      {'emoji': '🐈', 'name': 'Tigré'},
      {'emoji': '🐈', 'name': 'Noir'},
      {'emoji': '🐈', 'name': 'Siamois'},
    ],
    'toads': [
      {'emoji': '🐸', 'name': 'Commun'},
      {'emoji': '🐸', 'name': 'Cornu'},
      {'emoji': '🐸', 'name': 'Arboricole'},
      {'emoji': '🐸', 'name': 'Goliath'},
      {'emoji': '🐸', 'name': 'Vert'},
      {'emoji': '🐸', 'name': 'Sonneur'},
    ],
  };

  final tabColors = {
    'owls': const Color(0xFF8B4513),
    'cats': const Color(0xFFD2a679),
    'toads': const Color(0xFF4CAF50),
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(familiarTabProvider);
    final selectedFamiliar = ref.watch(selectedFamiliarProvider);
    final goldColor = const Color(0xFFD4AF37);
    final creamColor = const Color(0xFFFAF0E6);

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
                  'Ton Familier',
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
                  'Étape 7 / 8',
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
                  'Quel compagnon t\'accompagnera ?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    color: creamColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Onglets de catégories
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabButton(
                      'owls',
                      '🦉 Chouette',
                      currentTab,
                      goldColor,
                      creamColor,
                    ),
                    _buildTabButton(
                      'cats',
                      '🐈 Chat',
                      currentTab,
                      goldColor,
                      creamColor,
                    ),
                    _buildTabButton(
                      'toads',
                      '🐸 Crapaud',
                      currentTab,
                      goldColor,
                      creamColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Grille de familiers
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: familiars[currentTab]!.length,
                    itemBuilder: (context, index) {
                      final familiar = familiars[currentTab]![index];
                      final familiarKey = '${currentTab}_${familiar['name']}';
                      final isSelected = selectedFamiliar == familiarKey;

                      return _buildFamiliarCard(
                        familiar: familiar,
                        isSelected: isSelected,
                        index: index,
                        goldColor: goldColor,
                        creamColor: creamColor,
                        onTap: () {
                          ref.read(selectedFamiliarProvider.notifier).state =
                              familiarKey;
                          _nameController.text = familiar['name']!;
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // TextField pour nommer le familier
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _nameController,
                  style: GoogleFonts.raleway(fontSize: 14, color: creamColor),
                  decoration: InputDecoration(
                    labelText: 'Donne un nom à ton familier',
                    labelStyle: GoogleFonts.raleway(
                      fontSize: 12,
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.7),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A0000).withValues(alpha: 0.6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0xFFD4AF37),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0xFFD4AF37),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0xFFD4AF37),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Bouton Continuer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: selectedFamiliar != null
                        ? () async {
                            ref
                                .read(characterProvider.notifier)
                                .updateFamiliar(
                                  species: selectedFamiliar.split('_')[1],
                                  name: _nameController.text,
                                );

                            // Sauvegarder le personnage en Hive
                            await StorageService().saveCharacter(
                              ref.read(characterProvider),
                            );

                            if (mounted) {
                              context.push('/schooling');
                            }
                          }
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
                        color: selectedFamiliar != null
                            ? const Color(0xFFFAF0E6)
                            : const Color(0xFFFAF0E6).withValues(alpha: 0.5),
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

  Widget _buildTabButton(
    String tabId,
    String label,
    String currentTab,
    Color goldColor,
    Color creamColor,
  ) {
    final isActive = tabId == currentTab;

    return GestureDetector(
      onTap: () {
        ref.read(familiarTabProvider.notifier).state = tabId;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFAE0001) : Colors.transparent,
          border: Border.all(
            color: isActive ? const Color(0xFFAE0001) : goldColor,
            width: isActive ? 0 : 1.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : creamColor,
          ),
        ),
      ),
    );
  }

  Widget _buildFamiliarCard({
    required Map<String, String> familiar,
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
                        familiar['emoji']!,
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
                    familiar['name']!,
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
