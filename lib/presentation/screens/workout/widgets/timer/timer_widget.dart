import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mars_workout_app/logic/bloc/timer/timer_bloc.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: RepaintBoundary(
        child: BlocBuilder<TimerBloc, TimerState>(
          buildWhen: (previous, current) => previous.isRunning != current.isRunning,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (state.isRunning) {
                          context.read<TimerBloc>().add(PauseTimer());
                        } else {
                          context.read<TimerBloc>().add(StartTimer());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isRunning ? Colors.amber.shade100 : theme.primaryColor,
                        foregroundColor: state.isRunning ? Colors.amber.shade900 : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(state.isRunning ? Icons.pause : Icons.play_arrow), const SizedBox(width: 8), Text(state.isRunning ? "PAUSE" : "START WORKOUT")]),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => context.read<TimerBloc>().add(NextStage()),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.skip_next, color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
