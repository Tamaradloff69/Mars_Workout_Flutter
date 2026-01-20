import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';

class StageInfoAndSegmentBar extends StatelessWidget {
  const StageInfoAndSegmentBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (previous, current) => previous.currentStageIndex != current.currentStageIndex || previous.currentStage.name != current.currentStage.name,
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 4,
                child: Row(
                  children: List.generate(state.stages.length, (index) {
                    Color color;
                    if (index < state.currentStageIndex) {
                      color = theme.colorScheme.primaryContainer;
                    } else if (index == state.currentStageIndex) {
                      color = theme.primaryColor;
                    } else {
                      color = Colors.grey.shade200;
                    }
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Stage Name & Instructions
              Text(
                state.currentStage.name.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const SizedBox(height: 8),
              Text(
                state.currentStage.description.isNotEmpty ? state.currentStage.description : "Keep pushing!",
                textAlign: TextAlign.center,
                maxLines: 99,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          );
        },
      ),
    );
  }
}
