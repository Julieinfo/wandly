import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wandly/widgets/parchment_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFF5E6C8);

    return Scaffold(
      body: ParchmentBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top bar avec settings button
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.settings, size: 28),
                  color: goldColor,
                  onPressed: () => context.go('/settings'),
                ),
              ),
            ),

            // Header avec logo et titre en haut
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'W',
                      style: GoogleFonts.cinzel(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'WANDLY',
                      style: GoogleFonts.cinzel(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 1000),
                    ),
                    const SizedBox(height: 16),
                    // Séparateur doré avec losange
                    _GoldenSeparator().animate().fadeIn(
                      duration: const Duration(milliseconds: 1200),
                    ),
                  ],
                ),
              ),
            ),

            // Zone centrale avec éléments décoratifs
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Citation
                    SizedBox(
                      width: 280,
                      child: Text(
                        'Le registre s\'ouvre… Ta destinée magique t\'attend.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: creamColor.withValues(alpha: 0.7),
                          height: 1.6,
                        ),
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 1400),
                    ),
                    const SizedBox(height: 40),

                    // Icône baguette magique
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: goldColor.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_fix_high,
                        size: 64,
                        color: goldColor,
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 1600),
                    ),
                    const SizedBox(height: 24),

                    // Trois étoiles décoratives
                    Text(
                      '✦ ✦ ✦',
                      style: TextStyle(
                        fontSize: 16,
                        color: goldColor.withValues(alpha: 0.6),
                        letterSpacing: 8,
                      ),
                    ).animate().fadeIn(
                      duration: const Duration(milliseconds: 1800),
                    ),
                  ],
                ),
              ),
            ),

            // Séparateur doré avant boutons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: _GoldenSeparator().animate().fadeIn(
                duration: const Duration(milliseconds: 2000),
              ),
            ),

            // Boutons en bas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child:
                        ElevatedButton(
                          onPressed: () {
                            context.go('/identity');
                          },
                          child: Text(
                            'Créer mon identité',
                            style: GoogleFonts.cinzel(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ).animate().fadeIn(
                          duration: const Duration(milliseconds: 2200),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget séparateur doré stylisé
class _GoldenSeparator extends StatelessWidget {
  const _GoldenSeparator();

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD3A625);

    return SizedBox(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ligne à gauche
          Expanded(
            child: Container(
              height: 1,
              color: goldColor.withValues(alpha: 0.5),
            ),
          ),
          // Losange au centre
          SizedBox(
            width: 30,
            child: Center(
              child: Text(
                '◆',
                style: TextStyle(
                  fontSize: 12,
                  color: goldColor,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
          // Ligne à droite
          Expanded(
            child: Container(
              height: 1,
              color: goldColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
