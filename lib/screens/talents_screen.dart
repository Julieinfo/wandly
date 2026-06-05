import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TalentsScreen extends ConsumerWidget {
  const TalentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFF5E6C8);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Talents',
          style: GoogleFonts.cinzel(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: goldColor,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TALENTS',
                style: GoogleFonts.cinzel(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: goldColor,
                  letterSpacing: 2.0,
                ),
              ).animate().fadeIn(duration: 800.ms),
              const SizedBox(height: 40),
              Text(
                'Étape 4/8',
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: creamColor,
                  letterSpacing: 1.0,
                ),
              ).animate().fadeIn(duration: 1200.ms, delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
