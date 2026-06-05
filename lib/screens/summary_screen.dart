import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/widgets/parchment_background.dart';
import 'dart:io';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const goldColor = Color(0xFFD4AF37);
    const creamColor = Color(0xFFFAF0E6);
    final character = ref.watch(characterProvider);

    // Map pour les maisons avec leurs couleurs
    final houseColors = {
      'Gryffondor': const Color(0xFF8B0000),
      'Poufsouffle': const Color(0xFFCC9900),
      'Serdaigle': const Color(0xFF0044AA),
      'Serpentard': const Color(0xFF006400),
    };

    final houseEmojis = {
      'Gryffondor': '🦁',
      'Poufsouffle': '🦡',
      'Serdaigle': '🦅',
      'Serpentard': '🐍',
    };

    final Map<String, String> bloodStatusIcons = {
      'Sang-Pur': '🧬',
      'Sang-Mêlé': '🌗',
      'Né-Moldu': '✨',
      'Cracmols': '🐾',
    };

    return Scaffold(
      body: ParchmentBackground(
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: const Color(0xFFD3A625),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        'TON RÉSUMÉ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // 👤 Identité
                        if (character.firstName != null)
                          _buildSummaryCard(
                            context: context,
                            title: '👤 Identité',
                            route: '/identity',
                            goldColor: goldColor,
                            creamColor: creamColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (character.photoPath != null &&
                                    character.photoPath!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ClipOval(
                                      child: Image.file(
                                        File(character.photoPath!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (
                                              context,
                                              error,
                                              stackTrace,
                                            ) => Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(0xFF2C0000),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFD3A625,
                                                  ),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '${character.firstName?[0] ?? ''}${character.lastName?[0] ?? ''}',
                                                  style: GoogleFonts.cinzel(
                                                    fontSize: 24,
                                                    color: const Color(
                                                      0xFFD3A625,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                Text(
                                  '${character.firstName} ${character.lastName}',
                                  style: GoogleFonts.cinzel(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: creamColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Né(e) le ${character.birthDate?.day}/${character.birthDate?.month}/${character.birthDate?.year}',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    color: creamColor.withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${character.gender} • ${character.country}',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    color: creamColor.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        // 🧬 Statut de Sang
                        if (character.bloodStatus != null)
                          _buildSummaryCard(
                            context: context,
                            title: '🧬 Statut de Sang',
                            route: '/blood-status',
                            goldColor: goldColor,
                            creamColor: creamColor,
                            child: Row(
                              children: [
                                Text(
                                  bloodStatusIcons[character.bloodStatus] ??
                                      '?',
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  character.bloodStatus!.toUpperCase(),
                                  style: GoogleFonts.cinzel(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: creamColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        // 🏠 Maison
                        if (character.house != null)
                          _buildSummaryCard(
                            context: context,
                            title: '🏠 Maison',
                            route: '/house',
                            goldColor: goldColor,
                            creamColor: creamColor,
                            child: Row(
                              children: [
                                Text(
                                  houseEmojis[character.house] ?? '?',
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  character.house!,
                                  style: GoogleFonts.cinzel(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        houseColors[character.house] ??
                                        creamColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        // 🪄 Baguette
                        _buildSummaryCard(
                          context: context,
                          title: '🪄 Baguette',
                          route: '/wand',
                          goldColor: goldColor,
                          creamColor: creamColor,
                          child: Text(
                            '${character.wandWood ?? '?'} · ${character.wandCore ?? '?'} · ${character.wandLength ?? '?'}" · ${character.wandFlexibility ?? '?'}',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              color: creamColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🦌 Patronus
                        if (character.patronus != null)
                          _buildSummaryCard(
                            context: context,
                            title: '🦌 Patronus',
                            route: '/patronus',
                            goldColor: goldColor,
                            creamColor: creamColor,
                            child: Text(
                              character.patronus!,
                              style: GoogleFonts.cinzel(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: creamColor,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // ⚡ Spécialités
                        if (character.specialty1 != null &&
                            character.specialty2 != null)
                          _buildSummaryCard(
                            context: context,
                            title: '⚡ Spécialités',
                            route: '/specialty',
                            goldColor: goldColor,
                            creamColor: creamColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${character.specialty1} • ${character.specialty2}',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    color: creamColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  character.specialtyTitle ??
                                      'Sorcier Polyvalent',
                                  style: GoogleFonts.cinzel(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: goldColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        // 🦉 Familier
                        if (character.familiarSpecies != null)
                          _buildSummaryCard(
                            context: context,
                            title: '🦉 Familier',
                            route: '/familiar',
                            goldColor: goldColor,
                            creamColor: creamColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  character.familiarSpecies ?? '?',
                                  style: GoogleFonts.cinzel(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: creamColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Nom: ${character.familiarName ?? 'Sans nom'}',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    color: creamColor.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        // 🎓 Scolarité
                        if (character.arrivalYear != null &&
                            character.currentYear != null)
                          _buildSummaryCard(
                            context: context,
                            title: '🎓 Scolarité',
                            route: '/schooling',
                            goldColor: goldColor,
                            creamColor: creamColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Arrivée en ${character.arrivalYear} → Diplôme en ${(character.arrivalYear ?? 0) + 7}',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    color: creamColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Année actuelle: ${character.currentYear}ère',
                                  style: GoogleFonts.raleway(
                                    fontSize: 12,
                                    color: creamColor.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // Bouton Générer carte
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:
                      ElevatedButton(
                            onPressed: () {
                              context.push('/card');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAE0001),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Générer ma carte ✨',
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: creamColor,
                                letterSpacing: 1,
                              ),
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(
                            duration: const Duration(milliseconds: 2000),
                            color: const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: 0.3),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String route,
    required Color goldColor,
    required Color creamColor,
    required Widget child,
  }) {
    return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2C0000),
            border: Border.all(color: goldColor, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cinzel(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: goldColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go(route),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: goldColor, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '✏️',
                        style: GoogleFonts.raleway(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 400))
        .slideX(
          begin: -0.1,
          end: 0,
          duration: const Duration(milliseconds: 400),
        );
  }
}
