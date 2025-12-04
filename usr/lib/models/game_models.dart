class Question {
  final String questionText;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctIndex,
  });
}

class Territory {
  final int id;
  int? ownerId; // null = neutral, 0 = player, 1 = cpu
  int troops; // Strength of the territory (optional for MVP)

  Territory({required this.id, this.ownerId, this.troops = 100});
}

class Player {
  final int id;
  final String name;
  final int colorValue; // 0xFF...

  Player({required this.id, required this.name, required this.colorValue});
}
