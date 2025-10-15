import 'package:flutter/material.dart';
import 'package:meditation/models/session_controller.dart';
import 'package:meditation/utils/format.dart';
import 'package:provider/provider.dart';

class SessionTimerBar extends StatelessWidget {
  const SessionTimerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionController>(
      builder: (context, session, _) {
        if (session.totalSeconds == 0) return const SizedBox.shrink();
        final remaining = formatMmSs(session.remainingSeconds);
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.all(12),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Session',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    remaining,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: session.progress,
                  minHeight: 8,
                  backgroundColor: Colors.black12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: session.isPaused
                        ? session.resume
                        : session.pause,
                    child: Text(session.isPaused ? 'Resume' : 'Pause'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: session.reset,
                    child: const Text('End'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
