import 'package:flutter/material.dart';
import '../models/fitness_models.dart';
import '../data/exercise_data.dart';
import 'workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Selected Filters
  Set<MuscleGroup> selectedMuscles = {};
  Set<Equipment> selectedEquipment = {Equipment.bodyweight}; // Default to bodyweight

  // Helper to translate enums to Bulgarian
  String _getMuscleName(MuscleGroup mg) {
    switch (mg) {
      case MuscleGroup.chest: return 'Гърди';
      case MuscleGroup.back: return 'Гръб';
      case MuscleGroup.legs: return 'Крака';
      case MuscleGroup.abs: return 'Корем';
      case MuscleGroup.arms: return 'Ръце';
      case MuscleGroup.shoulders: return 'Рамене';
      case MuscleGroup.fullBody: return 'Цяло тяло';
    }
  }

  String _getEquipmentName(Equipment eq) {
    switch (eq) {
      case Equipment.bodyweight: return 'Собствено тегло';
      case Equipment.dumbbells: return 'Дъмбели';
      case Equipment.resistanceBands: return 'Ластици';
      case Equipment.kettlebell: return 'Пудовка';
    }
  }

  List<Exercise> get _filteredExercises {
    return allExercises.where((exercise) {
      bool muscleMatch = selectedMuscles.isEmpty || selectedMuscles.contains(exercise.muscleGroup);
      bool equipmentMatch = selectedEquipment.contains(exercise.equipment);
      return muscleMatch && equipmentMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      appBar: AppBar(
        title: const Text('Домашен Фитнес'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Filter Section ---
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Мускулни групи:',
                  style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: MuscleGroup.values.map((mg) {
                      final isSelected = selectedMuscles.contains(mg);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(_getMuscleName(mg)),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedMuscles.add(mg);
                              } else {
                                selectedMuscles.remove(mg);
                              }
                            });
                          },
                          backgroundColor: Colors.grey[800],
                          selectedColor: Colors.tealAccent[700],
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey[300]),
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Налично оборудване:',
                  style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: Equipment.values.map((eq) {
                      final isSelected = selectedEquipment.contains(eq);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(_getEquipmentName(eq)),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedEquipment.add(eq);
                              } else {
                                selectedEquipment.remove(eq);
                              }
                            });
                          },
                          backgroundColor: Colors.grey[800],
                          selectedColor: Colors.orangeAccent[700],
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey[300]),
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // --- Results Section ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Намерени упражнения (${_filteredExercises.length})',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          
          Expanded(
            child: _filteredExercises.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[700]),
                        const SizedBox(height: 16),
                        const Text(
                          'Няма намерени упражнения.\nПроменете филтрите.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = _filteredExercises[index];
                      return Card(
                        color: const Color(0xFF2C2C2C),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutScreen(exercise: exercise),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    exercise.type == ExerciseType.timer ? Icons.timer : Icons.fitness_center,
                                    color: Colors.tealAccent,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_getMuscleName(exercise.muscleGroup)} • ${_getEquipmentName(exercise.equipment)}',
                                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
