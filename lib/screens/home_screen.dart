import 'package:flutter/material.dart';
import 'package:meditation/widgets/animated_gradient_scaffold.dart';
import 'package:meditation/widgets/press_scale.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meditation')),
      body: AnimatedGradientBackground(
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            _OptionCard(
              icon: Icons.timer,
              title: 'Timer Session',
              subtitle: 'Focus with a simple countdown',
              onTap: () => Navigator.pushNamed(context, '/timer'),
            ),
            const SizedBox(height: 16),
            _OptionCard(
              icon: Icons.self_improvement,
              title: 'Breathing Session',
              subtitle: 'Inhale · Hold · Exhale guidance',
              onTap: () => Navigator.pushNamed(context, '/breathing'),
            ),
            const SizedBox(height: 16),
            _OptionCard(
              icon: Icons.music_note,
              title: 'Music Meditation',
              subtitle: 'Calming background tracks',
              onTap: () => Navigator.pushNamed(context, '/music'),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}


