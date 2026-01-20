import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/repositories/misc/gif_repository.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/stage_info/stage_info_and_segment_bar.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/timer/linear_timer_display.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/timer/prep_overlay.dart'; // Import this
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

  void _preloadNextGif(BuildContext context, int currentIndex) {
    if (!mounted) return;
    if (currentIndex < widget.workout.stages.length - 1) {
      final nextStage = widget.workout.stages[currentIndex + 1];
      final nextGifUrl = GifRepository.getGifUrl(widget.workoutType, nextStage.name);
      // Preload the next GIF
      precacheImage(NetworkImage(nextGifUrl), context);
    }
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
      appBar: AppBar(title: Text(widget.workout.title), elevation: 0, foregroundColor: Colors.black),
      // WRAP BODY IN STACK
      body: Stack(
        children: [
          // 1. ORIGINAL WORKOUT UI (Bottom Layer)
          Column(
            children: [
              Expanded(
                flex: 4,
                child: RepaintBoundary(
                  child: BlocBuilder<TimerBloc, TimerState>(
                    buildWhen: (previous, current) => previous.currentStageIndex != current.currentStageIndex,
                    builder: (context, state) {
                      final gifUrl = GifRepository.getGifUrl(widget.workoutType, state.currentStage.name);

                      // Preload next stage GIF when stage changes
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _preloadNextGif(context, state.currentStageIndex);
                      });

                      return Container(
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: CachedNetworkImage(
                          imageUrl: gifUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator(color: theme.primaryColor)),
                          errorWidget: (context, url, error) => Center(child: Icon(Icons.fitness_center, size: 64, color: Colors.grey.shade100)),
                          memCacheWidth: 800,
                          memCacheHeight: 800,
                        ),
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
                  ),
                  child: const Column(children: [StageInfoAndSegmentBar(), Spacer(), LinearTimerDisplay(), SizedBox(height: 16), TimerControls()]),
                ),
              ),
            ],
          ),

          // 2. PREP OVERLAY (Top Layer)
          const PrepOverlay(),
        ],
      ),
    );
  }
}
