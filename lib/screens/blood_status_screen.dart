import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/services/storage_service.dart';

class BloodStatusData {
  final String icon;
  final String name;
  final String description;

  BloodStatusData({
    required this.icon,
    required this.name,
    required this.description,
  });
}

class BloodStatusScreen extends ConsumerStatefulWidget {
  const BloodStatusScreen({super.key});

  @override
  ConsumerState<BloodStatusScreen> createState() => _BloodStatusScreenState();
}

class _BloodStatusScreenState extends ConsumerState<BloodStatusScreen> {
  String? _selectedBloodStatus;

  final List<BloodStatusData> bloodStatuses = [
    BloodStatusData(
      icon: '🧬',
      name: 'Sang-Pur',
      description:
          'Issu d\'une longue lignée de sorciers. Certains t\'admirent, d\'autres se méfient de tes préjugés…',
    ),
    BloodStatusData(
      icon: '🌗',
      name: 'Sang-Mêlé',
      description:
          'Né d\'un parent sorcier et d\'un parent Moldu. La majorité des sorciers partagent ton héritage.',
    ),
    BloodStatusData(
      icon: '✨',
      name: 'Né-Moldu',
      description:
          'Tes parents sont Moldus, mais la magie t\'a choisi. Hermione Granger elle-même était comme toi.',
    ),
    BloodStatusData(
      icon: '🐾',
      name: 'Cracmols',
      description:
          'Né de deux parents Moldus sans aucun don magique. Ta présence à Poudlard relève du miracle.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFF5E6C8);
    const darkFieldColor = Color(0xFF2C0000);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD3A625)),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: Text(
          'Statut de Sang',
          style: GoogleFonts.cinzel(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD3A625),
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0000), Color(0xFF2C0000)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Étape indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Text(
                      'Étape 2 / 8',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        color: const Color(0xFFF5E6C8),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Quel est ton héritage magique ?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cinzel(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: creamColor,
                      letterSpacing: 1.0,
                    ),
                  ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideX(),
                  const SizedBox(height: 40),

                  // Blood Status Cards
                  ...List.generate(bloodStatuses.length, (index) {
                    final status = bloodStatuses[index];
                    final isSelected = _selectedBloodStatus == status.name;

                    return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedBloodStatus = status.name;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? darkFieldColor.withValues(alpha: 0.9)
                                    : darkFieldColor,
                                border: Border.all(
                                  color: goldColor,
                                  width: isSelected ? 3 : 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Icon
                                  Text(
                                    status.icon,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(width: 16),

                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          status.name,
                                          style: GoogleFonts.cinzel(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: goldColor,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          status.description,
                                          style: GoogleFonts.raleway(
                                            fontSize: 12,
                                            color: creamColor.withValues(
                                              alpha: 0.8,
                                            ),
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Checkmark
                                  if (isSelected)
                                    Text(
                                          '✓',
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: goldColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(duration: 300.ms)
                                        .scale(),
                                ],
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(
                          duration: Duration(milliseconds: 800 + (index * 150)),
                        )
                        .slideX(
                          begin: 0.2,
                          end: 0,
                          duration: Duration(milliseconds: 800 + (index * 150)),
                        );
                  }),
                  const SizedBox(height: 40),

                  // Continue Button
                  SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedBloodStatus != null
                              ? () async {
                                  // Update Riverpod provider with blood status
                                  ref
                                      .read(characterProvider.notifier)
                                      .updateBloodStatus(_selectedBloodStatus!);

                                  // Persist to Hive
                                  await StorageService().saveCharacter(
                                    ref.read(characterProvider),
                                  );

                                  // Navigate to next screen
                                  if (mounted) {
                                    context.push('/house');
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
                      )
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 1200))
                      .slideX(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
