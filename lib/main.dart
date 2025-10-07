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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
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

// Game Page  - Level 1
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  bool gameWon = false;
  String message = 'Find the Golden Pumpkin! 🎃';

  // Audio players for sound effects
  final AudioPlayer scaryPlayer = AudioPlayer();
  final AudioPlayer successPlayer = AudioPlayer();
  
  // Animation controllers for each object
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;
  late AnimationController controller4;
  
  @override
  void initState() {
    super.initState();
    
    controller1 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true); // Makes it go back and forth
    
    controller2 = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    controller3 = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    
    controller4 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    // Clean up controllers when done
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    scaryPlayer.dispose();
    successPlayer.dispose();
    super.dispose();
  }
  
  // Called when player clicks the WRONG item 
  void onTrapClicked() {
    setState(() {
      message = 'Wrong one! Try again! 👻';
    });
    
    scaryPlayer.play(AssetSource('sounds/scary.mp3'));
    
    // Reset message after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !gameWon) {
        setState(() {
          message = 'Find the Golden Pumpkin! 🎃';
        });
      }
    });
  }
  
  // Called when player clicks the CORRECT item
  void onCorrectItemClicked() {
    setState(() {
      gameWon = true;
      message = '🎉 You Found It! You Win! 🎉';
    });
    
    successPlayer.play(AssetSource('sounds/spooky.mp3'));
    
    // Show win dialog
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        showWinDialog();
      }
    });
  }
  
  // Popup when player wins
  void showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orange,
        title: const Text(
          '🎃 Level 1 Complete! 🎃',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'You found the Golden Pumpkin!\nReady for Level 2?',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to welcome page
            },
            child: const Text(
              'Quit',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
            },
            child: const Text(
              'Next Level',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a0033), // Dark purple background
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '🎃 Halloween Game 🎃',
          style: TextStyle(color: Colors.orange),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          
          // Animated Ghost
          AnimatedBuilder(
            animation: controller1,
            builder: (context, child) {
              return Positioned(
                top: 150 + (controller1.value * 100), // Moves up and down
                left: 50,
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha :0.8),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text(
                        '👻',
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Animated Bat
          AnimatedBuilder(
            animation: controller2,
            builder: (context, child) {
              return Positioned(
                top: 300,
                left: 50 + (controller2.value * 250), // Moves left and right
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha :0.7),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text(
                        '🦇',
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Animated Skull
          AnimatedBuilder(
            animation: controller3,
            builder: (context, child) {
              return Positioned(
                top: 200 + (controller3.value * 150),
                right: 50,
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha :0.6),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text(
                        '💀',
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Golden Pumpkin 
          AnimatedBuilder(
            animation: controller4,
            builder: (context, child) {
              return Positioned(
                bottom: 100 + (controller4.value * 80),
                left: 150,
                child: GestureDetector(
                  onTap: gameWon ? null : onCorrectItemClicked,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha :0.3),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha :0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '🎃',
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Regular Pumpkin
          AnimatedBuilder(
            animation: controller1,
            builder: (context, child) {
              return Positioned(
                bottom: 200,
                right: 70 + (controller1.value * 50),
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha :0.3),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text(
                        '🎃',
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}