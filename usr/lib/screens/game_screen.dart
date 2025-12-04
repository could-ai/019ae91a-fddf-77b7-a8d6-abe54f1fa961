import 'package:flutter/material.dart';
import 'dart:math';
import '../models/game_models.dart';
import '../data/questions.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game State
  late List<Territory> territories;
  late List<Player> players;
  int currentPlayerIndex = 0; // 0 = Human, 1 = CPU
  String gameStatus = "Избери територия за атака!";
  bool isProcessingTurn = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // 3x3 Grid = 9 Territories
    territories = List.generate(9, (index) => Territory(id: index));
    
    // Players
    players = [
      Player(id: 0, name: "Играч", colorValue: 0xFF2196F3), // Blue
      Player(id: 1, name: "CPU", colorValue: 0xFFF44336),   // Red
    ];

    // Initial Setup: Player gets top-left (0), CPU gets bottom-right (8)
    territories[0].ownerId = 0;
    territories[8].ownerId = 1;
    
    currentPlayerIndex = 0;
    gameStatus = "Твой ред! Избери територия.";
  }

  // Check if a move is valid (adjacency)
  bool _isNeighbor(int id1, int id2) {
    // Grid logic for 3x3
    // 0 1 2
    // 3 4 5
    // 6 7 8
    int row1 = id1 ~/ 3;
    int col1 = id1 % 3;
    int row2 = id2 ~/ 3;
    int col2 = id2 % 3;

    return (row1 == row2 && (col1 - col2).abs() == 1) || 
           (col1 == col2 && (row1 - row2).abs() == 1);
  }

  bool _canAttack(int targetId) {
    // Can attack if target is adjacent to ANY territory owned by current player
    // AND target is NOT owned by current player
    if (territories[targetId].ownerId == currentPlayerIndex) return false;

    for (var t in territories) {
      if (t.ownerId == currentPlayerIndex) {
        if (_isNeighbor(t.id, targetId)) return true;
      }
    }
    return false;
  }

  void _handleTerritoryTap(int index) {
    if (isProcessingTurn || currentPlayerIndex != 0) return;

    if (_canAttack(index)) {
      _startBattle(index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Не можеш да атакуваш тази територия! Трябва да е съседна.")),
      );
    }
  }

  void _startBattle(int targetIndex) {
    setState(() {
      isProcessingTurn = true;
    });

    // Pick a random question
    final random = Random();
    final question = gameQuestions[random.nextInt(gameQuestions.length)];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QuestionDialog(
        question: question,
        onAnswer: (int selectedIndex) {
          Navigator.of(context).pop();
          _resolveBattle(targetIndex, question, selectedIndex);
        },
      ),
    );
  }

  void _resolveBattle(int targetIndex, Question question, int playerAnswerIndex) async {
    bool playerCorrect = playerAnswerIndex == question.correctIndex;
    
    // CPU Logic: 70% chance to be correct
    bool cpuCorrect = Random().nextDouble() < 0.7; 
    
    String resultMessage = "";
    bool conquestSuccessful = false;

    Territory target = territories[targetIndex];

    if (target.ownerId == null) {
      // Neutral Territory
      if (playerCorrect) {
        conquestSuccessful = true;
        resultMessage = "Верен отговор! Завладя територията.";
      } else {
        resultMessage = "Грешен отговор! Територията остава неутрална.";
      }
    } else {
      // Enemy Territory
      if (playerCorrect && !cpuCorrect) {
        conquestSuccessful = true;
        resultMessage = "Победа! Ти отговори вярно, а противникът сгреши.";
      } else if (playerCorrect && cpuCorrect) {
        resultMessage = "Равенство! И двамата знаехте отговора. Атаката е отблъсната.";
      } else if (!playerCorrect && cpuCorrect) {
        resultMessage = "Загуба! Противникът защити територията си.";
      } else {
        resultMessage = "И двамата сгрешихте. Нищо не се променя.";
      }
    }

    setState(() {
      if (conquestSuccessful) {
        territories[targetIndex].ownerId = 0;
      }
      gameStatus = resultMessage;
    });

    await Future.delayed(const Duration(seconds: 2));
    
    _checkWinCondition();
    _cpuTurn();
  }

  void _cpuTurn() async {
    setState(() {
      currentPlayerIndex = 1;
      gameStatus = "Ред на противника (CPU)...";
    });

    await Future.delayed(const Duration(seconds: 2));

    // Simple AI: Find a valid target (Neutral preferred, then Player)
    List<int> validTargets = [];
    for (int i = 0; i < territories.length; i++) {
      if (territories[i].ownerId != 1) { // Not owned by CPU
         // Check adjacency
         bool isAdj = false;
         for (var t in territories) {
           if (t.ownerId == 1 && _isNeighbor(t.id, i)) {
             isAdj = true;
             break;
           }
         }
         if (isAdj) validTargets.add(i);
      }
    }

    if (validTargets.isEmpty) {
      // CPU has no moves (trapped or map full of own)
      setState(() {
        currentPlayerIndex = 0;
        gameStatus = "CPU пропуска ред. Твой ред!";
        isProcessingTurn = false;
      });
      return;
    }

    // Pick random target
    int targetId = validTargets[Random().nextInt(validTargets.length)];
    Territory target = territories[targetId];

    // Simulate Battle
    bool cpuWins = false;
    String cpuMsg = "";

    // CPU has 60% chance to answer correctly for simulation
    bool cpuCorrect = Random().nextDouble() < 0.6;
    
    if (target.ownerId == null) {
      if (cpuCorrect) {
        cpuWins = true;
        cpuMsg = "CPU завладя неутрална зона!";
      } else {
        cpuMsg = "CPU сгреши на неутрална зона.";
      }
    } else {
      // Attacking Player
      // Player defends (simulated 50% chance for simplicity or we could ask player to defend)
      // For faster gameplay, let's simulate player defense automatically or make it async?
      // Let's simulate player defense to keep flow fast.
      bool playerDefendsCorrectly = Random().nextDouble() < 0.6;

      if (cpuCorrect && !playerDefendsCorrectly) {
        cpuWins = true;
        cpuMsg = "CPU ти отне територия!";
      } else {
        cpuMsg = "CPU атакува, но не успя!";
      }
    }

    setState(() {
      if (cpuWins) {
        territories[targetId].ownerId = 1;
      }
      gameStatus = cpuMsg;
      currentPlayerIndex = 0;
      isProcessingTurn = false;
    });
    
    _checkWinCondition();
  }

  void _checkWinCondition() {
    int playerTiles = territories.where((t) => t.ownerId == 0).length;
    int cpuTiles = territories.where((t) => t.ownerId == 1).length;
    int neutralTiles = territories.where((t) => t.ownerId == null).length;

    if (neutralTiles == 0 && (playerTiles == 0 || cpuTiles == 0)) {
       // Game Over
       String winner = playerTiles > cpuTiles ? "ПОБЕДА!" : "ЗАГУБА!";
       showDialog(
         context: context,
         barrierDismissible: false,
         builder: (ctx) => AlertDialog(
           title: Text(winner),
           content: Text("Ти: $playerTiles, CPU: $cpuTiles"),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.pop(ctx);
                 setState(() {
                   _initializeGame();
                 });
               },
               child: const Text("Нова игра"),
             )
           ],
         ),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trivia Conquest"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            width: double.infinity,
            child: Text(
              gameStatus,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Game Board
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final territory = territories[index];
                  Color tileColor = Colors.grey[300]!;
                  if (territory.ownerId == 0) tileColor = Colors.blue[300]!;
                  if (territory.ownerId == 1) tileColor = Colors.red[300]!;

                  bool isSelectable = !isProcessingTurn && 
                                      currentPlayerIndex == 0 && 
                                      _canAttack(index);

                  return GestureDetector(
                    onTap: () => _handleTerritoryTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelectable 
                            ? Border.all(color: Colors.green, width: 4) 
                            : Border.all(color: Colors.black12),
                        boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.1),
                             blurRadius: 4,
                             offset: const Offset(2, 2),
                           )
                        ]
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              territory.ownerId == 0 ? Icons.person : 
                              territory.ownerId == 1 ? Icons.computer : Icons.terrain,
                              color: Colors.white,
                              size: 40,
                            ),
                            if (territory.ownerId == null)
                              const Text("Неутрална", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Legend
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem("Ти", Colors.blue[300]!),
                _buildLegendItem("Неутрална", Colors.grey[300]!),
                _buildLegendItem("CPU", Colors.red[300]!),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 20, height: 20, color: color),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class QuestionDialog extends StatelessWidget {
  final Question question;
  final Function(int) onAnswer;

  const QuestionDialog({super.key, required this.question, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Въпрос"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(question.questionText, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ...List.generate(question.options.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => onAnswer(index),
                  child: Text(question.options[index]),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
