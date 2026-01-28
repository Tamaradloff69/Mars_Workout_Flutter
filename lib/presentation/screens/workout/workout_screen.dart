import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/workout_helper.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/models/workout_session.dart';
import 'package:mars_workout_app/data/repositories/misc/gif_repository.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/bloc/workout_session/workout_session_bloc.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/stage_info/stage_info_and_segment_bar.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/timer/linear_timer_display.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/timer/timer_widget.dart';
import 'package:mars_workout_app/presentation/screens/workout/widgets/workout_video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WorkoutScreen extends StatefulWidget {
  final WorkoutType workoutType;
  final Workout workout;
  final String planDayId;

  const WorkoutScreen({super.key, required this.workout, required this.planDayId, required this.workoutType});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with WidgetsBindingObserver {
  static const Duration _youtubeThreshold = Duration(minutes: 10);
  static const platform = MethodChannel('com.example.mars_workout_app/pip');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Attempt to enter PiP when app is backgrounded
    if (state == AppLifecycleState.paused) {
      _enterPictureInPicture();
    }
  }

  Future<void> _enterPictureInPicture() async {
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod('enterPiP');
      } on PlatformException catch (_) {
        // PiP not supported on this device/version
      }
    }
  }

  void _preloadNextGif(BuildContext context, int currentIndex) {
    if (!mounted) return;
    if (currentIndex < widget.workout.stages.length - 1) {
      final nextStage = widget.workout.stages[currentIndex + 1];
      final nextGifUrl = GifRepository.getGifUrl(widget.workoutType, nextStage.name);
      precacheImage(NetworkImage(nextGifUrl), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- (b) PiP / Background Widget Detection ---
    // If the window height is very small, we are likely in PiP mode.
    final size = MediaQuery.of(context).size;
    if (size.height < 300) {
      return _buildPipLayout(context);
    }

    return _buildStandardLayout(context);
  }

  // --- (b) The simplified widget for background/PiP view ---
  Widget _buildPipLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            final isCountdown = WorkoutHelper.isCountdownStage(state.currentStage);
            final maxDuration = state.currentStage.duration;
            final remaining = maxDuration - state.elapsed;
            final secondsDisplay = remaining.inSeconds < 0 ? 0 : remaining.inSeconds;

            final textColor = isCountdown ? Colors.orange : Colors.white;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.currentStage.name,
                  style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${(secondsDisplay / 60).floor().toString().padLeft(2, '0')}:${(secondsDisplay % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStandardLayout(BuildContext context) {
    final theme = Theme.of(context);
    final totalDuration = widget.workout.stages.fold(Duration.zero, (prev, element) => prev + element.duration);
    final useYoutube = totalDuration > _youtubeThreshold;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final timerState = context.read<TimerBloc>().state;
        if (!timerState.isFinished) {
          final shouldExit = await _showExitConfirmation(context);
          if (shouldExit == true) {
            final session = WorkoutSession(
              workout: widget.workout,
              planDayId: widget.planDayId,
              workoutType: widget.workoutType,
              currentStageIndex: timerState.currentStageIndex,
              elapsed: timerState.elapsed,
              isRunning: timerState.isRunning,
              savedAt: DateTime.now(),
            );
            context.read<WorkoutSessionBloc>().add(SaveWorkoutSession(session));
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(widget.workout.title), elevation: 0, foregroundColor: Colors.black),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.4,
                        child: RepaintBoundary(
                          child: useYoutube
                              ? WorkoutVideoSection(
                            workout: widget.workout,
                            planDayId: widget.planDayId,
                            workoutType: widget.workoutType,
                          )
                              : BlocBuilder<TimerBloc, TimerState>(
                            buildWhen: (previous, current) => previous.currentStageIndex != current.currentStageIndex,
                            builder: (context, state) {
                              final isCountdown = WorkoutHelper.isCountdownStage(state.currentStage);
                              if (isCountdown) {
                                return _buildCountdownOverlay(context, state);
                              }
                              final gifUrl = GifRepository.getGifUrl(widget.workoutType, state.currentStage.name);
                              WidgetsBinding.instance.addPostFrameCallback((_) => _preloadNextGif(context, state.currentStageIndex));

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
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
                          ),
                          child: const Column(
                            children: [
                              StageInfoAndSegmentBar(),
                              Spacer(),
                              LinearTimerDisplay(),
                              SizedBox(height: 16),
                              TimerControls(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCountdownOverlay(BuildContext context, TimerState state) {
    // ... Keep your existing countdown overlay code exactly as it was ...
    // Assuming standard implementation from previous Repomix context
    final theme = Theme.of(context);
    final timeLeft = state.currentStage.duration - state.elapsed;
    final secondsDisplay = timeLeft.inSeconds < 0 ? 0 : timeLeft.inSeconds;
    final progress = state.currentStage.duration.inMilliseconds > 0
        ? state.elapsed.inMilliseconds / state.currentStage.duration.inMilliseconds
        : 0.0;

    return Container(
      color: Colors.black.withValues(alpha: 0.9),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("GET READY", style: theme.textTheme.headlineMedium?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold, letterSpacing: 3.0)),
          const SizedBox(height: 40),
          SizedBox(
            width: 200, height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(child: CircularProgressIndicator(value: 1.0, strokeWidth: 15, color: Colors.white.withValues(alpha: 0.1))),
                SizedBox.expand(child: TweenAnimationBuilder<double>(key: ValueKey(state.currentStageIndex), tween: Tween<double>(begin: 0.0, end: progress), duration: const Duration(milliseconds: 1000), builder: (context, value, _) => CircularProgressIndicator(value: value, strokeWidth: 15, color: Colors.orange, strokeCap: StrokeCap.round))),
                Text("$secondsDisplay", style: const TextStyle(fontSize: 90, fontWeight: FontWeight.bold, color: Colors.white, fontFeatures: [FontFeature.tabularFigures()])),
              ],
            ),
          ),
          const SizedBox(height: 50),
          if (state.currentStage.description.isNotEmpty) ...[
            Text("NEXT UP:", style: theme.textTheme.labelLarge?.copyWith(color: Colors.white54, letterSpacing: 1.2)),
            const SizedBox(height: 12),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 32.0), child: Text(state.currentStage.description.replaceFirst('Next: ', ''), textAlign: TextAlign.center, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600))),
          ],
        ],
      ),
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit Workout?'),
        content: const Text('Your progress will be saved and you can resume this workout later.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Exit & Save'),
          ),
        ],
      ),
    );
  }
}