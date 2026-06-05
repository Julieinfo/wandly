import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wandly/services/storage_service.dart';
import 'package:wandly/widgets/parchment_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'Français';
  String _theme = 'Nuit sombre';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);
    const creamColor = Color(0xFFFAF0E6);
    const darkRed = Color(0xFFAE0001);

    return Scaffold(
      body: ParchmentBackground(
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      'Paramètres',
                      style: GoogleFonts.cinzel(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: goldColor,
                      ),
                    ),
                    SizedBox(width: 48), // Placeholder pour équilibrer
                  ],
                ),
              ),

              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1 — Langue
                        _buildSectionTitle('Langue', goldColor),
                        const SizedBox(height: 16),
                        _buildLanguageToggle(goldColor, darkRed),
                        const SizedBox(height: 32),

                        // Séparateur
                        _buildSeparator(goldColor),
                        const SizedBox(height: 32),

                        // Section 2 — Thème
                        _buildSectionTitle('Thème visuel', goldColor),
                        const SizedBox(height: 16),
                        _buildThemeToggle(goldColor, darkRed),
                        const SizedBox(height: 32),

                        // Séparateur
                        _buildSeparator(goldColor),
                        const SizedBox(height: 32),

                        // Section 3 — Mon Profil
                        _buildSectionTitle('Mon Profil', goldColor),
                        const SizedBox(height: 16),
                        _buildProfileSection(
                          context,
                          goldColor,
                          darkRed,
                          creamColor,
                        ),
                        const SizedBox(height: 32),

                        // Séparateur
                        _buildSeparator(goldColor),
                        const SizedBox(height: 32),

                        // Section 4 — À propos
                        _buildSectionTitle('À propos', goldColor),
                        const SizedBox(height: 16),
                        _buildAboutSection(creamColor),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),

              // Bouton Enregistrer les modifications
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _savePreferences(context, darkRed),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkRed,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Enregistrer les modifications ✓',
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.cinzel(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildSeparator(Color color) {
    return Center(
      child: Text('◆', style: TextStyle(color: color, fontSize: 16)),
    );
  }

  Widget _buildLanguageToggle(Color goldColor, Color darkRed) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _language = 'Français'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _language == 'Français'
                  ? darkRed
                  : Colors.transparent,
              side: _language == 'Français'
                  ? BorderSide.none
                  : BorderSide(color: goldColor, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              '🇫🇷 Français',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _language == 'Français' ? Colors.white : goldColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _language = 'English'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _language == 'English'
                  ? darkRed
                  : Colors.transparent,
              side: _language == 'English'
                  ? BorderSide.none
                  : BorderSide(color: goldColor, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              '🇬🇧 English',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _language == 'English' ? Colors.white : goldColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(Color goldColor, Color darkRed) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _theme = 'Nuit sombre'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _theme == 'Nuit sombre'
                  ? darkRed
                  : Colors.transparent,
              side: _theme == 'Nuit sombre'
                  ? BorderSide.none
                  : BorderSide(color: goldColor, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              '🌙 Nuit sombre',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _theme == 'Nuit sombre' ? Colors.white : goldColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _theme = 'Parchemin clair'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _theme == 'Parchemin clair'
                  ? darkRed
                  : Colors.transparent,
              side: _theme == 'Parchemin clair'
                  ? BorderSide.none
                  : BorderSide(color: goldColor, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              '📜 Parchemin clair',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _theme == 'Parchemin clair' ? Colors.white : goldColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    Color goldColor,
    Color darkRed,
    Color creamColor,
  ) {
    return Column(
      children: [
        // Bouton Modifier
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.go('/identity'),
            style: ElevatedButton.styleFrom(
              backgroundColor: goldColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Modifier mon personnage',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C0000),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Bouton Réinitialiser
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showResetDialog(context, darkRed, creamColor),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkRed,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Réinitialiser mon profil',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(Color creamColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wandly v1.0.0',
          style: GoogleFonts.raleway(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: creamColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Application non officielle créée par des fans de Harry Potter',
          style: GoogleFonts.raleway(
            fontSize: 12,
            color: creamColor.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Harry Potter © J.K. Rowling',
          style: GoogleFonts.raleway(
            fontSize: 12,
            color: creamColor.withValues(alpha: 0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _showResetDialog(BuildContext context, Color darkRed, Color creamColor) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C0000),
          title: Text(
            'Réinitialiser le profil ?',
            style: GoogleFonts.cinzel(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkRed,
            ),
          ),
          content: Text(
            'Tous vos paramètres et données de personnage seront supprimés. Cette action ne peut pas être annulée.',
            style: GoogleFonts.raleway(fontSize: 14, color: creamColor),
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                'Annuler',
                style: GoogleFonts.raleway(
                  color: const Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await StorageService().deleteCharacter();
                if (context.mounted) {
                  dialogContext.pop();
                  context.go('/home');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Profil réinitialisé'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                }
              },
              child: Text(
                'Supprimer',
                style: GoogleFonts.raleway(
                  color: darkRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language') ?? 'Français';
      _theme = prefs.getString('theme') ?? 'Nuit sombre';
    });
  }

  Future<void> _savePreferences(BuildContext context, Color darkRed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _language);
    await prefs.setString('theme', _theme);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Paramètres sauvegardés'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      context.go('/home');
    }
  }
}
