import '../models/fitness_models.dart';

final List<Exercise> allExercises = [
  // --- Гърди (Chest) ---
  const Exercise(
    id: 'pushups',
    name: 'Лицеви опори',
    description: 'Класическо упражнение за гърди и трицепс. Дръжте тялото изправено.',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.bodyweight,
    type: ExerciseType.reps,
    targetValue: 15,
  ),
  const Exercise(
    id: 'dumbbell_press',
    name: 'Преса с дъмбели от пода',
    description: 'Легнете на пода и избутайте дъмбелите нагоре.',
    muscleGroup: MuscleGroup.chest,
    equipment: Equipment.dumbbells,
    type: ExerciseType.reps,
    targetValue: 12,
  ),

  // --- Крака (Legs) ---
  const Exercise(
    id: 'squats',
    name: 'Клекове',
    description: 'Дръжте гърба изправен и клекнете докато бедрата станат успоредни на пода.',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.bodyweight,
    type: ExerciseType.reps,
    targetValue: 20,
  ),
  const Exercise(
    id: 'lunges',
    name: 'Напади',
    description: 'Стъпете напред и спуснете задното коляно към пода.',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.bodyweight,
    type: ExerciseType.reps,
    targetValue: 12, // per leg
  ),
  const Exercise(
    id: 'goblet_squat',
    name: 'Гоблет клек',
    description: 'Клек с дъмбел пред гърдите за допълнително натоварване.',
    muscleGroup: MuscleGroup.legs,
    equipment: Equipment.dumbbells,
    type: ExerciseType.reps,
    targetValue: 12,
  ),

  // --- Корем (Abs) ---
  const Exercise(
    id: 'plank',
    name: 'Планк',
    description: 'Задръжте позиция на лакти, стягайки корема и седалището.',
    muscleGroup: MuscleGroup.abs,
    equipment: Equipment.bodyweight,
    type: ExerciseType.timer,
    targetValue: 45, // seconds
  ),
  const Exercise(
    id: 'crunches',
    name: 'Коремни преси',
    description: 'Повдигнете горната част на тялото, използвайки коремните мускули.',
    muscleGroup: MuscleGroup.abs,
    equipment: Equipment.bodyweight,
    type: ExerciseType.reps,
    targetValue: 20,
  ),

  // --- Ръце (Arms) ---
  const Exercise(
    id: 'bicep_curls',
    name: 'Бицепсово сгъване',
    description: 'Сгънете ръцете в лактите, повдигайки дъмбелите.',
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.dumbbells,
    type: ExerciseType.reps,
    targetValue: 12,
  ),
  const Exercise(
    id: 'tricep_dips',
    name: 'Кофички на стол',
    description: 'Използвайте стол или пейка, за да спуснете тялото надолу.',
    muscleGroup: MuscleGroup.arms,
    equipment: Equipment.bodyweight,
    type: ExerciseType.reps,
    targetValue: 12,
  ),

  // --- Гръб (Back) ---
  const Exercise(
    id: 'superman',
    name: 'Супермен',
    description: 'Легнете по корем и повдигнете едновременно ръцете и краката.',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.bodyweight,
    type: ExerciseType.timer,
    targetValue: 30,
  ),
  const Exercise(
    id: 'dumbbell_row',
    name: 'Гребане с дъмбел',
    description: 'Наведете се напред и издърпайте дъмбела към кръста.',
    muscleGroup: MuscleGroup.back,
    equipment: Equipment.dumbbells,
    type: ExerciseType.reps,
    targetValue: 12,
  ),
];
