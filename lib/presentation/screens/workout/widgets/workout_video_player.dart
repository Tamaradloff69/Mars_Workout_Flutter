import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/core/constants/enums/workout_type.dart';
import 'package:mars_workout_app/data/models/workout_model.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';
import 'package:mars_workout_app/logic/cubit/workout_video_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  String? _currentVideoId; // Track current ID to prevent needless reloads

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

  /// Robustly extracts a Video ID from any YouTube link (including playlists)
  String? _extractVideoId(String? url) {
    if (url == null || url.trim().isEmpty) return null;

    // 1. Try official helper first
    String? id = YoutubePlayer.convertUrlToId(url);

    // 2. If null, it might be a playlist URL or specialized link.
    // We look specifically for the 'v=' parameter which denotes the video.
    if (id == null) {
      final regExp = RegExp(r'[?&]v=([^&#]+)');
      final match = regExp.firstMatch(url);
      if (match != null) {
        id = match.group(1);
      }
    }
    return id;
  }

  void _ensureYoutubeController(String? rawInput) {
    // 1. Extract the actual Video ID (Ignores playlist ID parts to prevent errors)
    final videoId = _extractVideoId(rawInput);

    if (videoId == null) {
      // If we have a controller but no valid video, dispose it
      if (_youtubeController != null) {
        _youtubeController!.dispose();
        _youtubeController = null;
        _currentVideoId = null;
      }
      return;
    }

    // 2. IMMEDIATE UPDATE: If ID changed, load it instantly
    if (_youtubeController != null && _currentVideoId != videoId) {
      _youtubeController!.load(videoId);
      _currentVideoId = videoId;
      return;
    }

    // 3. Initialize if it doesn't exist
    if (_youtubeController == null) {
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
  }

  Future<void> _promptForVideo({String? initialValue}) async {
    final controller = TextEditingController(text: initialValue ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose YouTube content'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Paste Video Link',
                  hintText: 'https://youtu.be/xxxx',
                  helperText: 'For playlists, link a specific video to start.',
                  helperMaxLines: 2,
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

    if (!mounted || result == null) return;

    if (result == 'CLEAR') {
      context.read<WorkoutVideoCubit>().clearVideoForSession(_sessionKey);
      setState(() {
        _currentVideoId = null;
        _youtubeController?.dispose();
        _youtubeController = null;
      });
      return;
    }

    if (result.isNotEmpty) {
      // Check if it's a playlist-only link (no video ID)
      if (_extractVideoId(result) == null && result.contains('list=')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please choose a specific video from the playlist to start.')),
          );
        }
        return;
      }

      context.read<WorkoutVideoCubit>().setVideoForSession(_sessionKey, result);

      // Force UI rebuild to trigger _ensureYoutubeController immediately
      setState(() {});
    }
  }

  Future<void> _openYoutubeSearch(String query) async {
    final search = Uri.parse('https://www.youtube.com/results?search_query=${Uri.encodeQueryComponent(query)}');
    await launchUrl(search, mode: LaunchMode.externalApplication);
  }

  void _openFullscreenPlayer() {
    if (_currentVideoId == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => BlocProvider.value(
          value: context.read<TimerBloc>(),
          child: WorkoutVideoFullscreenScreen(
            videoId: _currentVideoId,
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

    // Watch cubit for user-saved input
    final videoCubit = context.watch<WorkoutVideoCubit>();
    final savedVideoInput = videoCubit.getVideoForSession(_sessionKey);

    // CHANGE: Set inputToUse to ONLY the saved input, with no fallback
    // This ensures the player starts blank as requested.
    final inputToUse = (savedVideoInput?.isNotEmpty == true) ? savedVideoInput : null;

    // Initialize/Update Controller with the blank or user-provided input
    _ensureYoutubeController(inputToUse);

    final bool hasPlayer = _youtubeController != null;

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
                child: hasPlayer
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Add a YouTube URL to play here',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
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
                  onPressed: () => _promptForVideo(initialValue: savedVideoInput),
                  icon: const Icon(Icons.add_link_rounded), // Updated icon for "blank" state
                  label: Text(hasPlayer ? 'Change content' : 'Set content'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => _openYoutubeSearch(widget.workout.title),
                  child: const Text('Search'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Fullscreen player remains largely the same, just ensure it accepts single videoId
class WorkoutVideoFullscreenScreen extends StatefulWidget {
  final String? videoId;
  final String workoutTitle;
  final String workoutDescription;

  const WorkoutVideoFullscreenScreen({
    super.key,
    this.videoId,
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
      initialVideoId: widget.videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              top: 8, left: 8,
              child: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
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
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
                    child: Text('$minutes:$seconds', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
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