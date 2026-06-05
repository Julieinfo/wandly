import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wandly/services/character_provider.dart';
import 'package:wandly/services/storage_service.dart';

class HouseScreen extends ConsumerStatefulWidget {
  const HouseScreen({super.key});

  @override
  ConsumerState<HouseScreen> createState() => _HouseScreenState();
}

class _HouseScreenState extends ConsumerState<HouseScreen> {
  String _selectedMode = 'selection'; // 'selection' ou 'quiz'
  String? _selectedHouse; // Nom de la maison sélectionnée

  // Quiz state
  int _currentQuestionIndex = 0;
  bool _quizFinished = false;
  String? _resultHouse;
  final Map<String, int> _houseScores = {
    'gryffondor': 0,
    'poufsouffle': 0,
    'serdaigle': 0,
    'serpentard': 0,
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      'question': 'Face au danger, tu...',
      'answers': [
        {'text': 'Fonces sans réfléchir', 'house': 'gryffondor', 'points': 2},
        {'text': 'Cherches une stratégie', 'house': 'serdaigle', 'points': 2},
        {'text': 'Protèges tes proches', 'house': 'poufsouffle', 'points': 2},
        {
          'text': 'Utilises la situation à ton avantage',
          'house': 'serpentard',
          'points': 2,
        },
      ],
    },
    {
      'question': 'Ta plus grande qualité est...',
      'answers': [
        {'text': 'Le courage', 'house': 'gryffondor', 'points': 2},
        {'text': 'La loyauté', 'house': 'poufsouffle', 'points': 2},
        {'text': 'L\'intelligence', 'house': 'serdaigle', 'points': 2},
        {'text': 'L\'ambition', 'house': 'serpentard', 'points': 2},
      ],
    },
    {
      'question': 'Tu préfères passer ton temps libre...',
      'answers': [
        {
          'text': 'À explorer des endroits interdits',
          'house': 'gryffondor',
          'points': 2,
        },
        {'text': 'Avec tes amis fidèles', 'house': 'poufsouffle', 'points': 2},
        {'text': 'Dans la bibliothèque', 'house': 'serdaigle', 'points': 2},
        {'text': 'À planifier ton avenir', 'house': 'serpentard', 'points': 2},
      ],
    },
    {
      'question': 'Si tu trouvais une bourse pleine d\'or...',
      'answers': [
        {
          'text': 'Tu la rendrais immédiatement',
          'house': 'poufsouffle',
          'points': 2,
        },
        {
          'text': 'Tu enquêterais pour trouver le propriétaire',
          'house': 'serdaigle',
          'points': 2,
        },
        {
          'text': 'Tu la garderais, tu l\'as bien méritée',
          'house': 'serpentard',
          'points': 2,
        },
        {
          'text': 'Tu la donnerais à ceux qui en ont besoin',
          'house': 'gryffondor',
          'points': 2,
        },
      ],
    },
    {
      'question': 'Ton professeur préféré serait...',
      'answers': [
        {
          'text': 'Défense contre les forces du Mal',
          'house': 'gryffondor',
          'points': 2,
        },
        {
          'text': 'Soins aux créatures magiques',
          'house': 'poufsouffle',
          'points': 2,
        },
        {'text': 'Métamorphose', 'house': 'serdaigle', 'points': 2},
        {'text': 'Potions', 'house': 'serpentard', 'points': 2},
      ],
    },
    {
      'question': 'En cas de conflit dans ton groupe...',
      'answers': [
        {
          'text': 'Tu prends la tête et tranches',
          'house': 'gryffondor',
          'points': 2,
        },
        {'text': 'Tu joues le médiateur', 'house': 'poufsouffle', 'points': 2},
        {
          'text': 'Tu analyses objectivement',
          'house': 'serdaigle',
          'points': 2,
        },
        {
          'text': 'Tu en tires profit discrètement',
          'house': 'serpentard',
          'points': 2,
        },
      ],
    },
    {
      'question': 'Ton plus grand défaut est...',
      'answers': [
        {'text': 'L\'impulsivité', 'house': 'gryffondor', 'points': 2},
        {'text': 'La naïveté', 'house': 'poufsouffle', 'points': 2},
        {'text': 'L\'orgueil intellectuel', 'house': 'serdaigle', 'points': 2},
        {'text': 'La froideur', 'house': 'serpentard', 'points': 2},
      ],
    },
    {
      'question': 'Tu voudrais être connu pour...',
      'answers': [
        {'text': 'Tes actes héroïques', 'house': 'gryffondor', 'points': 2},
        {'text': 'Ta générosité', 'house': 'poufsouffle', 'points': 2},
        {'text': 'Tes découvertes', 'house': 'serdaigle', 'points': 2},
        {'text': 'Ton pouvoir', 'house': 'serpentard', 'points': 2},
      ],
    },
    {
      'question': 'Ton animal préféré parmi ces 4...',
      'answers': [
        {'text': 'Le lion', 'house': 'gryffondor', 'points': 2},
        {'text': 'Le blaireau', 'house': 'poufsouffle', 'points': 2},
        {'text': 'L\'aigle', 'house': 'serdaigle', 'points': 2},
        {'text': 'Le serpent', 'house': 'serpentard', 'points': 2},
      ],
    },
    {
      'question': 'Ce qui compte le plus pour toi...',
      'answers': [
        {'text': 'La bravoure', 'house': 'gryffondor', 'points': 2},
        {'text': 'L\'amitié', 'house': 'poufsouffle', 'points': 2},
        {'text': 'La sagesse', 'house': 'serdaigle', 'points': 2},
        {'text': 'La réussite', 'house': 'serpentard', 'points': 2},
      ],
    },
  ];

  final List<Map<String, dynamic>> houses = [
    {
      'name': 'Gryffondor',
      'emoji': '🦁',
      'color': const Color(0xFF8B0000),
      'accent': const Color(0xFFFFD700),
      'traits': 'Courage • Fierté',
    },
    {
      'name': 'Poufsouffle',
      'emoji': '🦡',
      'color': const Color(0xFFCC9900),
      'accent': const Color(0xFFFFF0A0),
      'traits': 'Loyauté • Travail',
    },
    {
      'name': 'Serdaigle',
      'emoji': '🦅',
      'color': const Color(0xFF0044AA),
      'accent': const Color(0xFFC0D8FF),
      'traits': 'Sagesse • Créativité',
    },
    {
      'name': 'Serpentard',
      'emoji': '🐍',
      'color': const Color(0xFF006400),
      'accent': const Color(0xFF90EE90),
      'traits': 'Ambition • Ruse',
    },
  ];

  void _answerQuestion(String houseKey, int points) {
    setState(() {
      _houseScores[houseKey] = (_houseScores[houseKey] ?? 0) + points;

      if (_currentQuestionIndex < quizQuestions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Quiz terminé
        _quizFinished = true;
        _resultHouse = _calculateWinningHouse();
        _selectedHouse = _resultHouse;
      }
    });
  }

  String _calculateWinningHouse() {
    int maxScore = 0;
    String? winner;

    _houseScores.forEach((house, score) {
      if (score > maxScore) {
        maxScore = score;
        winner = house;
      }
    });

    // Convertir le clé en nom de maison complet
    switch (winner) {
      case 'gryffondor':
        return 'Gryffondor';
      case 'poufsouffle':
        return 'Poufsouffle';
      case 'serdaigle':
        return 'Serdaigle';
      case 'serpentard':
        return 'Serpentard';
      default:
        return 'Gryffondor';
    }
  }

  Future<void> _continuePressed() async {
    if (_selectedHouse == null) return;

    // Sauvegarder la maison sélectionnée
    ref.read(characterProvider.notifier).updateHouse(_selectedHouse!);

    // Persister dans Hive
    await StorageService().saveCharacter(ref.read(characterProvider));

    // Naviguer vers /wand
    if (mounted) {
      context.push('/wand');
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
                  'Ta Maison',
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
                  'Étape 3 / 8',
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
                          'Où le Choixpeau te placera-t-il ?',
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

              const SizedBox(height: 24),

              // Toggle buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedMode = 'selection'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedMode == 'selection'
                                ? const Color(0xFFAE0001)
                                : Colors.transparent,
                            border: Border.all(
                              color: goldColor,
                              width: _selectedMode == 'selection' ? 0 : 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '🖐️ Je choisis',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: creamColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedMode = 'quiz'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedMode == 'quiz'
                                ? const Color(0xFFAE0001)
                                : Colors.transparent,
                            border: Border.all(
                              color: goldColor,
                              width: _selectedMode == 'quiz' ? 0 : 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '🎲 Choixpeau',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: creamColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: const Duration(milliseconds: 700)),
              ),

              const SizedBox(height: 24),

              // Mode Libre - Grille de maisons
              if (_selectedMode == 'selection')
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1 / 1.2,
                      children: List.generate(
                        houses.length,
                        (index) => _buildHouseCard(
                          house: houses[index],
                          isSelected: _selectedHouse == houses[index]['name'],
                          cardIndex: index,
                          onTap: () => setState(
                            () => _selectedHouse = houses[index]['name'],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                // Mode Quiz
                Expanded(
                  child: _quizFinished
                      ? _buildResultScreen()
                      : _buildQuizQuestion(),
                ),

              const SizedBox(height: 24),

              // Bouton Continuer (uniquement en mode selection ou quiz terminé)
              if (_selectedMode == 'selection' ||
                  (_selectedMode == 'quiz' && _quizFinished))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        ElevatedButton(
                          onPressed: _selectedHouse != null
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

  Widget _buildQuizQuestion() {
    const goldColor = Color(0xFFD3A625);
    const creamColor = Color(0xFFF5E6C8);

    final question = quizQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / quizQuestions.length;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Barre de progression
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1}',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: creamColor.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '/ ${quizQuestions.length}',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: creamColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: const Color(0xFF2C0000),
                    valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Question
            Text(
                  question['question'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: creamColor,
                    letterSpacing: 0.3,
                  ),
                )
                .animate()
                .slideX(
                  begin: 0.2,
                  end: 0,
                  duration: const Duration(milliseconds: 400),
                )
                .fadeIn(duration: const Duration(milliseconds: 400)),

            const SizedBox(height: 32),

            // Réponses
            ...(question['answers'] as List<dynamic>).asMap().entries.map<
              Widget
            >((entry) {
              final answerIndex = entry.key;
              final answer = entry.value as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _answerQuestion(
                    answer['house'] as String,
                    answer['points'] as int,
                  ),
                  child:
                      Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C0000),
                              border: Border.all(
                                color: goldColor.withValues(alpha: 0.6),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              answer['text'] as String,
                              style: GoogleFonts.raleway(
                                fontSize: 13,
                                color: creamColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                          .animate()
                          .slideX(
                            begin: -0.1,
                            end: 0,
                            delay: Duration(milliseconds: answerIndex * 100),
                            duration: const Duration(milliseconds: 400),
                          )
                          .fadeIn(
                            delay: Duration(milliseconds: answerIndex * 100),
                            duration: const Duration(milliseconds: 400),
                          ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    const creamColor = Color(0xFFF5E6C8);

    final selectedHouseData = houses.firstWhere(
      (h) => h['name'] == _resultHouse,
      orElse: () => houses[0],
    );
    final houseColor = selectedHouseData['color'] as Color;
    final emoji = selectedHouseData['emoji'] as String;
    final name = selectedHouseData['name'] as String;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // Texte révélation
            Text(
              'Le Choixpeau a décidé...',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: creamColor.withValues(alpha: 0.8),
              ),
            ).animate().fadeIn(duration: const Duration(milliseconds: 600)),

            const SizedBox(height: 32),

            // Emoji maison
            Text(emoji, style: const TextStyle(fontSize: 64))
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  duration: const Duration(milliseconds: 700),
                )
                .fadeIn(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 600),
                ),

            const SizedBox(height: 24),

            // Nom de la maison
            Text(
                  name.toUpperCase(),
                  style: GoogleFonts.cinzel(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: houseColor,
                    letterSpacing: 1.5,
                  ),
                )
                .animate()
                .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 600),
                )
                .fadeIn(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 600),
                ),

            const SizedBox(height: 24),

            // Traits de la maison
            Text(
              selectedHouseData['traits'] as String,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 13,
                color: creamColor.withValues(alpha: 0.8),
                letterSpacing: 0.5,
              ),
            ).animate().fadeIn(
              delay: const Duration(milliseconds: 600),
              duration: const Duration(milliseconds: 600),
            ),

            const SizedBox(height: 48),

            // Bouton Accepter destinée
            SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _continuePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAE0001),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Accepter ma destinée',
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: creamColor,
                      ),
                    ),
                  ),
                )
                .animate()
                .slideY(
                  begin: 0.2,
                  end: 0,
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 600),
                )
                .fadeIn(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 600),
                ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseCard({
    required Map<String, dynamic> house,
    required bool isSelected,
    required int cardIndex,
    required VoidCallback onTap,
  }) {
    final houseColor = house['color'] as Color;
    final emoji = house['emoji'] as String;
    final name = house['name'] as String;
    final traits = house['traits'] as String;

    return GestureDetector(
      onTap: onTap,
      child:
          Stack(
                children: [
                  // Fond coloré avec dégradé
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [houseColor, houseColor.withOpacity(0.7)],
                      ),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFFD700)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 48)),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            traits,
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Coche sélection
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD700),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 16,
                        ),
                      ).animate().fadeIn().scale(),
                    ),
                ],
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: (cardIndex * 150).ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                duration: 400.ms,
                delay: (cardIndex * 150).ms,
              ),
    );
  }
}
