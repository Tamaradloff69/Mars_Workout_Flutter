import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/repositories/misc/gif_repository.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_state.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/stage_info/stage_info_and_segment_bar.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/timer/linear_timer_display.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/timer/timer_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WorkoutScreen extends StatefulWidget {
  final WorkoutType workoutType;
  final Workout workout;
  final String planDayId;

  const WorkoutScreen({super.key, required this.workout, required this.planDayId, required this.workoutType});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.workout.title),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: BlocBuilder<TimerBloc, TimerState>(
              buildWhen: (previous, current) =>
              previous.currentStageIndex != current.currentStageIndex,
              builder: (context, state) {
                final gifUrl = GifRepository.getGifUrl(
                    widget.workoutType,
                    state.currentStage.name
                );

                return Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Image.network(
                    gifUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator(color: theme.primaryColor));
                    },
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.fitness_center, size: 64, color: Colors.grey)),
                  ),
                );
              },
            ),
          ),

          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const StageInfoAndSegmentBar(),
                  const Spacer(),
                  const LinearTimerDisplay(),
                  const SizedBox(height: 16),
                  TimerControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}