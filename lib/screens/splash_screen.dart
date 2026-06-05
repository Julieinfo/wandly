import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _titleController;
  late AnimationController _textController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _titleAnimation;

  String _displayedText = '';
  final String _fullText = 'Le Registre des Élèves de Poudlard s\'ouvre…';
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();

    // Animation FadeIn pour le blason (2 secondes)
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Animation pour le titre WANDLY (apparaît après le blason)
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _titleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _titleController, curve: Curves.easeIn));

    // Animation pour le texte lettre par lettre
    _textController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Démarrer les animations
    _startAnimations();

    // Navigation après 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  void _startAnimations() {
    // Démarrer le fade du blason
    _fadeController.forward();

    // Démarrer le titre après 2 secondes
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _titleController.forward();
      }
    });

    // Démarrer l'animation du texte après 2.5 secondes
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        _textController.forward();
        _animateText();
      }
    });
  }

  void _animateText() {
    for (int i = 0; i < _fullText.length; i++) {
      Future.delayed(Duration(milliseconds: 2500 + (i * 50)), () {
        if (mounted) {
          setState(() {
            _textIndex = i + 1;
            _displayedText = _fullText.substring(0, _textIndex);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0000),
      body: Stack(
        children: [
          // Contenu principal centré
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Blason avec animation FadeIn
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text('🏰', style: TextStyle(fontSize: 120, height: 1)),
                ),
                const SizedBox(height: 40),

                // Titre WANDLY avec animation
                FadeTransition(
                  opacity: _titleAnimation,
                  child: Text(
                    'WANDLY',
                    style: GoogleFonts.cinzel(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD3A625),
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Texte animé lettre par lettre
                SizedBox(
                  width: 300,
                  child: Text(
                    _displayedText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      color: const Color(0xFFF5E6C8),
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // CircularProgressIndicator en bas
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFD3A625),
                ),
                strokeWidth: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
