import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditation/models/session_controller.dart';
import 'package:meditation/widgets/animated_gradient_scaffold.dart';
import 'package:provider/provider.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late final AudioPlayer _player;
  int _selectedMinutes = 10;
  bool _isPlaying = false;

  final List<_Track> _tracks = const [
    _Track(
      'Calming Rain Sound Effect',
      'assets/audio/Calming Rain Sound Effect.mp3',
    ),
    _Track('Thunder Sound Effect', 'assets/audio/Thunder Sound Effect.mp3'),
    _Track(
      'Walking Meditation Sound Effects',
      'assets/audio/Walking Meditation Sound Effects.mp3',
    ),
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    await _player.setAsset(_tracks[_currentIndex].assetPath);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    setState(() => _isPlaying = true);
    final session = context.read<SessionController>();
    if (session.totalSeconds == 0) {
      session.startMinutes(_selectedMinutes);
    }
    _player.setLoopMode(LoopMode.one);
    await _player.play();
  }

  Future<void> _pause() async {
    setState(() => _isPlaying = false);
    await _player.pause();
  }

  Future<void> _selectTrack(int index) async {
    setState(() => _currentIndex = index);
    await _loadCurrent();
    if (_isPlaying) {
      await _play();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Stop audio when global session ends
    context.select((SessionController s) => s.remainingSeconds);
    if (context.read<SessionController>().remainingSeconds == 0 && _isPlaying) {
      _pause();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Music Meditation')),
      body: AnimatedGradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text('Tracks', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tracks.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final track = _tracks[index];
                    final selected = index == _currentIndex;
                    return GestureDetector(
                      onTap: () => _selectTrack(index),
                      child: Container(
                        width: 160,
                        decoration: BoxDecoration(
                          color: selected
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.12)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.black12,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.landscape,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              track.title,
                              maxLines: 2,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              selected ? 'Selected' : 'Tap to select',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Timer'),
                  DropdownButton<int>(
                    value: _selectedMinutes,
                    items: const [5, 10, 15, 20, 30]
                        .map(
                          (m) =>
                              DropdownMenuItem(value: m, child: Text('$m min')),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _selectedMinutes = v ?? 10),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isPlaying ? _pause : _play,
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(_isPlaying ? 'Pause' : 'Play'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Track {
  final String title;
  final String assetPath;
  const _Track(this.title, this.assetPath);
}
