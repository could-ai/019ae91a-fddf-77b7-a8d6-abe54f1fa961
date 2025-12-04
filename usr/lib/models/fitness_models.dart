enum MuscleGroup {
  chest,
  back,
  legs,
  abs,
  arms,
  shoulders,
  fullBody
}

enum Equipment {
  bodyweight,
  dumbbells,
  resistanceBands,
  kettlebell
}

enum ExerciseType {
  reps, // Based on repetitions (e.g., 12 reps)
  timer // Based on time (e.g., 45 seconds)
}

class Exercise {
  final String id;
  final String name;
  final String description;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final ExerciseType type;
  final int targetValue; // Rep count or Seconds
  final int sets;
  final String imageUrl; // Placeholder for asset path or network URL

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.equipment,
    required this.type,
    required this.targetValue,
    this.sets = 3,
    this.imageUrl = '',
  });
}
