import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halloween Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

// Welcome Page
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AudioPlayer backgroundPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Play background music when app opens
    playBackgroundMusic();
  }

  // Function to play background music on loop
  void playBackgroundMusic() async {
    await backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundPlayer.play(AssetSource('sounds/creepy.mp3'));
  }

  @override
  void dispose() {
    backgroundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎃 Halloween Game 🎃',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Find the Mystery Object!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}