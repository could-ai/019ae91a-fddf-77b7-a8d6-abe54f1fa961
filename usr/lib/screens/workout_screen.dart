import 'dart:async';
import 'package:flutter/material.dart';
import '../models/fitness_models.dart';

class WorkoutScreen extends StatefulWidget {
  final Exercise exercise;

  const WorkoutScreen({super.key, required this.exercise});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with TickerProviderStateMixin {
  int currentSet = 1;
  bool isResting = false;
  bool isWorking = false;
  
  // Timer logic
  Timer? _timer;
  int _secondsRemaining = 0;
  double _progress = 1.0; // 1.0 = full, 0.0 = empty

  // Animation controller for pulsing effect
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    if (widget.exercise.type == ExerciseType.timer) {
      _secondsRemaining = widget.exercise.targetValue;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      isWorking = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _progress = _secondsRemaining / widget.exercise.targetValue;
        } else {
          _completeSet();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      isWorking = false;
    });
  }

  void _completeSet() {
    _timer?.cancel();
    setState(() {
      isWorking = false;
      if (currentSet < widget.exercise.sets) {
        currentSet++;
        // Reset for next set
        if (widget.exercise.type == ExerciseType.timer) {
          _secondsRemaining = widget.exercise.targetValue;
          _progress = 1.0;
        }
        // Show snackbar or small rest dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Серията завърши! Починете малко.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text('Браво!', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Успешно завършихте всички серии за това упражнение.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to list
            },
            child: const Text('Към списъка', style: TextStyle(color: Colors.tealAccent)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Серия $currentSet / ${widget.exercise.sets}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Exercise Info
            Column(
              children: [
                Text(
                  widget.exercise.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.exercise.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              ],
            ),

            // Main Visual (Timer or Reps)
            Expanded(
              child: Center(
                child: widget.exercise.type == ExerciseType.timer
                    ? _buildTimerView()
                    : _buildRepView(),
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 15,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_secondsRemaining',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'секунди',
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRepView() {
    return ScaleTransition(
      scale: isWorking ? _pulseController : const AlwaysStoppedAnimation(1.0),
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.orangeAccent, width: 8),
          color: Colors.orangeAccent.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.exercise.targetValue}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'повторения',
              style: TextStyle(color: Colors.white54, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    if (widget.exercise.type == ExerciseType.timer) {
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton.icon(
          onPressed: isWorking ? _pauseTimer : _startTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: isWorking ? Colors.redAccent : Colors.tealAccent[700],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          icon: Icon(isWorking ? Icons.pause : Icons.play_arrow, size: 30),
          label: Text(
            isWorking ? 'ПАУЗА' : 'СТАРТ',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      // Reps based controls
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _completeSet,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent[700],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text(
            'ГОТОВО',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
    }
  }
}
