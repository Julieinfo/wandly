import 'package:flutter/material.dart';

class ParchmentBackground extends StatelessWidget {
  final Widget child;

  const ParchmentBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fond dégradé Gryffondor
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A0000), Color(0xFF2C0000)],
            ),
          ),
        ),
        // Texture parchemin par dessus avec opacité
        Opacity(
          opacity: 0.07,
          child: Image.asset(
            'assets/images/parchment.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Contenu de l'écran
        child,
      ],
    );
  }
}
