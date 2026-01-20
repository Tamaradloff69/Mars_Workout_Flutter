import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/data/repositories/misc/video_repository.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/cubit/workout_video_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Top-of-screen video section for long workouts:
/// - Lets the user paste/search a YouTube URL/ID
/// - Plays inline where the GIF normally sits
/// - Provides a custom fullscreen experience in portrait.
class WorkoutVideoSection extends StatefulWidget {
  final Workout workout;
  final String planDayId;
  final WorkoutType workoutType;

  const WorkoutVideoSection({
    super.key,
    required this.workout,
    required this.planDayId,
    required this.workoutType,
  });

  @override
  State<WorkoutVideoSection> createState() => _WorkoutVideoSectionState();
}

class _WorkoutVideoSectionState extends State<WorkoutVideoSection> {
  late final String _sessionKey;
  YoutubePlayerController? _youtubeController;
  String? _currentVideoId;

  @override
  void initState() {
    super.initState();
    _sessionKey = widget.planDayId.isNotEmpty ? widget.planDayId : widget.workout.title;
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _ensureYoutubeController(String? videoId) {
    if (videoId == null) {
      _youtubeController?.dispose();
      _youtubeController = null;
      _currentVideoId = null;
      return;
    }
    if (_currentVideoId == videoId && _youtubeController != null) return;

    _youtubeController?.dispose();
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
        controlsVisibleAtStart: false,
      ),
    );
    _currentVideoId = videoId;
  }

  Future<void> _openYoutubeSearch(String query) async {
    final search = Uri.parse('https://www.youtube.com/results?search_query=${Uri.encodeQueryComponent(query)}');
    await launchUrl(search, mode: LaunchMode.externalApplication);
  }

  String? _extractVideoId(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;

    // Direct 11-char ID
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(trimmed)) return trimmed;

    // youtu.be/<id>
    final shortMatch = RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})').firstMatch(trimmed);
    if (shortMatch != null) return shortMatch.group(1);

    // youtube.com/watch?v=<id>
    final watchMatch = RegExp(r'[?&]v=([a-zA-Z0-9_-]{11})').firstMatch(trimmed);
    if (watchMatch != null) return watchMatch.group(1);

    // youtube.com/embed/<id>
    final embedMatch = RegExp(r'/embed/([a-zA-Z0-9_-]{11})').firstMatch(trimmed);
    if (embedMatch != null) return embedMatch.group(1);

    return null;
  }

  Future<void> _promptForVideo({String? initialValue}) async {
    final controller = TextEditingController(text: initialValue ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose YouTube video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Paste YouTube URL or video ID',
                  hintText: 'https://youtu.be/xxxx or 11-char ID',
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _openYoutubeSearch(
                    controller.text.isNotEmpty ? controller.text : widget.workout.title,
                  ),
                  icon: const Icon(Icons.search),
                  label: const Text('Search on YouTube'),
                ),
              ),
            ],
          ),
          actions: [
            if ((initialValue ?? '').isNotEmpty)
              TextButton(
                onPressed: () => Navigator.of(context).pop('CLEAR'),
                child: const Text('Clear'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (result == null) return;
    if (result == 'CLEAR') {
      context.read<WorkoutVideoCubit>().clearVideoForSession(_sessionKey);
      return;
    }
    if (result.isEmpty) return;
    context.read<WorkoutVideoCubit>().setVideoForSession(_sessionKey, result);
  }

  void _openFullscreenPlayer() {
    if (_currentVideoId == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => BlocProvider.value(
          value: context.read<TimerBloc>(),
          child: WorkoutVideoFullscreenScreen(
            videoId: _currentVideoId!,
            workoutTitle: widget.workout.title,
            workoutDescription: widget.workout.description,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final videoCubit = context.watch<WorkoutVideoCubit>();
    final savedVideoInput = videoCubit.getVideoForSession(_sessionKey);
    final fallbackVideoId = VideoRepository.getYoutubeVideoId(widget.workoutType);
    final chosenInput = savedVideoInput?.isNotEmpty == true ? savedVideoInput : fallbackVideoId;
    final youtubeVideoId = _extractVideoId(chosenInput);

    _ensureYoutubeController(youtubeVideoId);

    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: youtubeVideoId != null && _youtubeController != null
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: YoutubePlayer(
                              controller: _youtubeController!,
                              progressIndicatorColor: theme.primaryColor,
                              bottomActions: const [
                                CurrentPosition(),
                                ProgressBar(isExpanded: true),
                                RemainingDuration(),
                                PlaybackSpeedButton(),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: IconButton(
                              icon: const Icon(Icons.fullscreen, color: Colors.white),
                              onPressed: _openFullscreenPlayer,
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            'Add a YouTube URL or ID to play here',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _promptForVideo(initialValue: chosenInput),
                  icon: const Icon(Icons.edit),
                  label: Text(youtubeVideoId != null ? 'Change video' : 'Set video'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => _openYoutubeSearch(widget.workout.title),
                  child: const Text('Search YouTube'),
                ),
              ],
            ),
            if (youtubeVideoId == null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Paste a YouTube URL or ID to start playback here.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Fullscreen portrait video screen with workout name, info and remaining time.
class WorkoutVideoFullscreenScreen extends StatefulWidget {
  final String videoId;
  final String workoutTitle;
  final String workoutDescription;

  const WorkoutVideoFullscreenScreen({
    super.key,
    required this.videoId,
    required this.workoutTitle,
    required this.workoutDescription,
  });

  @override
  State<WorkoutVideoFullscreenScreen> createState() => _WorkoutVideoFullscreenScreenState();
}

class _WorkoutVideoFullscreenScreenState extends State<WorkoutVideoFullscreenScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(widget.workoutTitle),
        content: Text(
          widget.workoutDescription.isNotEmpty ? widget.workoutDescription : 'No description available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(
                  controller: _controller,
                  progressIndicatorColor: theme.primaryColor,
                  bottomActions: const [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                    PlaybackSpeedButton(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 24,
              child: BlocBuilder<TimerBloc, TimerState>(
                builder: (context, state) {
                  final remaining = state.currentStage.duration - state.elapsed;
                  final totalSeconds = remaining.inSeconds < 0 ? 0 : remaining.inSeconds;
                  final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
                  final seconds = (totalSeconds % 60).toString().padLeft(2, '0');

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                widget.workoutTitle,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.info_outline, size: 18, color: Colors.white),
                              onPressed: () => _showInfo(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$minutes:$seconds',
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

