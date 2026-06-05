import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/models/character_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wandly/widgets/parchment_background.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

class CardScreen extends ConsumerStatefulWidget {
  const CardScreen({super.key});

  @override
  ConsumerState<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends ConsumerState<CardScreen>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  late AnimationController _flipController;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  Future<void> _shareCard() async {
    final character = ref.read(characterProvider);
    try {
      final shareText =
          '''
🏰 MA CARTE DE POUDLARD 🏰

👤 ${character.firstName} ${character.lastName}
📅 Né(e) le ${character.birthDate?.day}/${character.birthDate?.month}/${character.birthDate?.year}
🌍 ${character.country}

🏠 Maison: ${character.house}
🧬 Statut: ${character.bloodStatus}
🪄 Baguette: ${character.wandWood} · ${character.wandCore}
🦌 Patronus: ${character.patronus}
🦉 Familier: ${character.familiarSpecies}
⚡ Spécialités: ${character.specialty1}, ${character.specialty2}

🎓 Contrat: ${character.arrivalYear} - ${(character.arrivalYear ?? 0) + 7}

✨ Généré par Wandly ✨
      ''';

      await Share.share(shareText, subject: 'Ta Carte de Poudlard - Wandly ✨');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur: impossible de partager')),
        );
      }
    }
  }

  Future<void> _downloadCard() async {
    try {
      // Capturer la carte
      final RenderRepaintBoundary? boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return;
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Sauvegarder via MediaStore (Android natif)
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'wandly_card_${DateTime.now().millisecondsSinceEpoch}.png';
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(pngBytes);

      // Copier dans Pictures/Wandly
      final picturesDir = Directory('/storage/emulated/0/Pictures/Wandly');
      if (!await picturesDir.exists()) {
        await picturesDir.create(recursive: true);
      }
      final savedFile = await tempFile.copy('${picturesDir.path}/$fileName');

      // Notifier la galerie Android
      await Process.run('am', [
        'broadcast',
        '-a',
        'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
        '-d',
        'file://${savedFile.path}',
      ]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Carte sauvegardée dans Pictures/Wandly !'),
            backgroundColor: Color(0xFF2E7D32),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _generateRegistryNumber(String firstName, int? arrivalYear) {
    final prefix = 'GRY'; // Gryffondor
    final year = arrivalYear ?? 1991;
    final number = firstName.hashCode.abs() % 10000;
    return '$prefix-$year-${number.toString().padLeft(4, '0')}';
  }

  Widget _buildProfilePhoto(
    String? photoPath,
    String? firstName,
    String? lastName,
    Color goldColor,
  ) {
    // Essayer d'utiliser le fichier si le chemin existe
    if (photoPath != null && photoPath.isNotEmpty) {
      final file = File(photoPath);
      if (file.existsSync()) {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: goldColor, width: 2),
          ),
          child: ClipOval(
            child: Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Si le fichier ne peut pas être chargé, afficher les initiales
                return _buildInitialsCircle(firstName, lastName, goldColor);
              },
            ),
          ),
        );
      }
    }

    // Par défaut, afficher un cercle avec les initiales
    return _buildInitialsCircle(firstName, lastName, goldColor);
  }

  Widget _buildInitialsCircle(
    String? firstName,
    String? lastName,
    Color goldColor,
  ) {
    final initial1 = firstName?.isNotEmpty ?? false
        ? firstName![0].toUpperCase()
        : '';
    final initial2 = lastName?.isNotEmpty ?? false
        ? lastName![0].toUpperCase()
        : '';
    final initials = '$initial1$initial2'.isNotEmpty
        ? '$initial1$initial2'
        : '?';

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2C0000),
        border: Border.all(color: goldColor, width: 2),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.cinzel(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: goldColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFFAF0E6);
    final character = ref.watch(characterProvider);

    // DEBUG
    print(
      'DEBUG familier: ${character.familiarSpecies} / ${character.familiarName}',
    );
    print('DEBUG patronus: ${character.patronus}');
    print('DEBUG specialty: ${character.specialty1} / ${character.specialty2}');

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
                        'TA CARTE',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzel(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),

              // Carte avec retournement 3D
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Card
                        AnimatedBuilder(
                          animation: _flipController,
                          builder: (context, child) {
                            final angle = _flipController.value * 3.14159265359;
                            final isBack = _flipController.value > 0.5;

                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              child: isBack
                                  ? Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(3.14159265359),
                                      child: _buildCardBack(
                                        character,
                                        goldColor,
                                        creamColor,
                                      ),
                                    )
                                  : RepaintBoundary(
                                      key: _cardKey,
                                      child: _buildCardFront(
                                        character,
                                        goldColor,
                                        creamColor,
                                        houseColors,
                                        houseEmojis,
                                      ),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Bouton Toggle
                        ElevatedButton.icon(
                          onPressed: _toggleFlip,
                          icon: const Icon(Icons.flip),
                          label: Text(_isFlipped ? 'Recto' : 'Verso'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: goldColor,
                            foregroundColor: const Color(0xFF1A0000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Boutons d'action
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _shareCard,
                        icon: const Icon(Icons.share),
                        label: const Text(
                          'Partager',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: const Color(0xFF1A0000),
                          minimumSize: const Size(0, 50),
                          textStyle: GoogleFonts.cinzel(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _downloadCard,
                        icon: const Icon(Icons.favorite),
                        label: const Text(
                          'Sauvegarder',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: const Color(0xFF1A0000),
                          minimumSize: const Size(0, 50),
                          textStyle: GoogleFonts.cinzel(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront(
    CharacterModel character,
    Color goldColor,
    Color creamColor,
    Map<String, Color> houseColors,
    Map<String, String> houseEmojis,
  ) {
    return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF2C0000),
            border: Border.all(color: goldColor, width: 3),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: goldColor.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Text(
                  '🏰 ÉCOLE DE POUDLARD CARTE D\'ÉLÈVE OFFICIELLE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                    height: 1.3,
                  ),
                ),
                Divider(color: goldColor.withValues(alpha: 0.5), thickness: 1),
                const SizedBox(height: 4),

                // Photo + Infos identité
                Row(
                  children: [
                    // Photo en cercle
                    _buildProfilePhoto(
                      character.photoPath,
                      character.firstName,
                      character.lastName,
                      goldColor,
                    ),
                    const SizedBox(width: 12),

                    // Infos texte
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${character.firstName ?? '?'} ${character.lastName ?? ''}',
                          style: GoogleFonts.cinzel(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          character.birthDate != null
                              ? '${character.birthDate!.day}/${character.birthDate!.month}/${character.birthDate!.year}'
                              : 'Date inconnue',
                          style: GoogleFonts.raleway(
                            fontSize: 10,
                            color: creamColor.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          character.country ?? 'Pays inconnu',
                          style: GoogleFonts.raleway(
                            fontSize: 10,
                            color: creamColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Divider(color: goldColor.withValues(alpha: 0.5), thickness: 1),
                const SizedBox(height: 4),

                // Grille d'infos 2 colonnes
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '🏠 ${character.house ?? '?'}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.raleway(
                              fontSize: 9,
                              color: houseColors[character.house] ?? goldColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '🧬 ${character.bloodStatus ?? '?'}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.raleway(
                              fontSize: 9,
                              color: creamColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '🪄 ${character.wandWood ?? '?'} · ${character.wandCore ?? '?'}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.raleway(
                              fontSize: 9,
                              color: creamColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '🦌 ${character.patronus ?? '?'}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.raleway(
                              fontSize: 9,
                              color: creamColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '🦉 ${character.familiarSpecies ?? '?'} · ${character.familiarName ?? '?'}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.raleway(
                              fontSize: 9,
                              color: creamColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '⚡ ${character.specialty1 ?? '?'} · ${character.specialty2 ?? '?'}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.raleway(
                              fontSize: 9,
                              color: creamColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                Divider(color: goldColor.withValues(alpha: 0.5), thickness: 1),

                // Bas de carte
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Dates et numéro
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Arrivée: ${character.arrivalYear ?? '?'} → Diplôme: ${(character.arrivalYear ?? 0) + 7}',
                          style: GoogleFonts.raleway(
                            fontSize: 8,
                            color: creamColor.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '#${_generateRegistryNumber(character.firstName ?? 'WIZARD', character.arrivalYear)}',
                          style: GoogleFonts.cinzel(
                            fontSize: 8,
                            color: goldColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // QR Code
                    QrImageView(
                      data:
                          'WANDLY|${character.firstName}|${character.lastName}|${character.house}|${character.arrivalYear}|${_generateRegistryNumber(character.firstName ?? 'WIZARD', character.arrivalYear)}',
                      version: QrVersions.auto,
                      size: 55,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF1A0000),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF1A0000),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 400))
        .slideX(
          begin: -0.2,
          end: 0,
          duration: const Duration(milliseconds: 400),
        );
  }

  Widget _buildCardBack(
    CharacterModel character,
    Color goldColor,
    Color creamColor,
  ) {
    return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF2C0000),
            border: Border.all(color: goldColor, width: 3),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: goldColor.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VERSO',
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(color: goldColor.withValues(alpha: 0.5), height: 1),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Titre Spécial
                      Text(
                        '📜 Titre Spécial',
                        style: GoogleFonts.cinzel(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        character.specialtyTitle ?? 'Sorcier Polyvalent',
                        style: GoogleFonts.raleway(
                          fontSize: 10,
                          color: creamColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Section Baguette Complète
                      Text(
                        '🪄 Baguette Complète',
                        style: GoogleFonts.cinzel(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${character.wandWood ?? '?'} / ${character.wandCore ?? '?'}',
                        style: GoogleFonts.raleway(
                          fontSize: 9,
                          color: creamColor.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${character.wandLength ?? '?'}" · ${character.wandFlexibility ?? '?'}',
                        style: GoogleFonts.raleway(
                          fontSize: 9,
                          color: creamColor.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Section Scolarité
                      Text(
                        '🎓 Scolarité',
                        style: GoogleFonts.cinzel(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Arrivée: ${character.arrivalYear ?? '?'}',
                        style: GoogleFonts.raleway(
                          fontSize: 9,
                          color: creamColor.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Diplôme: ${(character.arrivalYear ?? 1991) + 7}',
                        style: GoogleFonts.raleway(
                          fontSize: 9,
                          color: creamColor.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Année actuelle: ${character.currentYear ?? '?'}ère année',
                        style: GoogleFonts.raleway(
                          fontSize: 9,
                          color: creamColor.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Section Pieds de page
                      Center(
                        child: Text(
                          '✨ Généré par Wandly ✨',
                          style: GoogleFonts.raleway(
                            fontSize: 8,
                            color: goldColor.withValues(alpha: 0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 400))
        .slideX(
          begin: 0.2,
          end: 0,
          duration: const Duration(milliseconds: 400),
        );
  }
}
