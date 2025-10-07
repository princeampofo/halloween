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
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const GamePageLevel2()),
              );
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

// Level 2 
class GamePageLevel2 extends StatefulWidget {
  const GamePageLevel2({super.key});

  @override
  State<GamePageLevel2> createState() => _GamePageLevel2State();
}

class _GamePageLevel2State extends State<GamePageLevel2> with TickerProviderStateMixin {
  // Variables to track game state
  bool gameWon = false;
  String message = 'Level 2: Find the Haunted House! 🏚️';

  // Audio players for sound effects
  final AudioPlayer scaryPlayer = AudioPlayer();
  final AudioPlayer successPlayer = AudioPlayer();
  
  // Animation controllers for each object
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;
  late AnimationController controller4;
  late AnimationController controller5;
  late AnimationController controller6;
  
  @override
  void initState() {
    super.initState();
    
    // Create animation controllers for each object
    controller1 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Makes it go back and forth
    
    controller2 = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    controller3 = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    controller4 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    controller5 = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    
    controller6 = AnimationController(
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
    controller5.dispose();
    controller6.dispose();
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
          message = 'Level 2: Find the Haunted House! 🏚️';
        });
      }
    });
  }
  
  // Called when player clicks the CORRECT item
  void onCorrectItemClicked() {
    setState(() {
      gameWon = true;
      message = '🎉 Amazing! You Beat Level 2! 🎉';
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
        backgroundColor: Colors.purple,
        title: const Text(
          'You Won! 🎃',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        content: const Text(
          'Congratulations!\nYou completed all levels!',
          style: TextStyle(fontSize: 18, color: Colors.white),
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
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to welcome page
            },
            child: const Text(
              'Play Again',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0020), // darker purple
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '🎃 Level 2 - Harder! 🎃',
          style: TextStyle(color: Colors.purple),
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
                    fontSize: 22,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          
          // Ghost 1 
          AnimatedBuilder(
            animation: controller1,
            builder: (context, child) {
              return Positioned(
                top: 120 + (controller1.value * 120),
                left: 30,
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha :0.8),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Text('👻', style: TextStyle(fontSize: 45)),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Ghost 2 
          AnimatedBuilder(
            animation: controller2,
            builder: (context, child) {
              return Positioned(
                top: 250,
                left: 100 + (controller2.value * 180),
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha :0.7),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Text('👻', style: TextStyle(fontSize: 45)),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Witch 
          AnimatedBuilder(
            animation: controller3,
            builder: (context, child) {
              return Positioned(
                top: 180 + (controller3.value * 100),
                right: 40,
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha :0.5),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text('🧙', style: TextStyle(fontSize: 50)),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Spider
          AnimatedBuilder(
            animation: controller4,
            builder: (context, child) {
              return Positioned(
                bottom: 250 + (controller4.value * 80),
                left: 50,
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha :0.6),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Text('🕷️', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Zombie 
          AnimatedBuilder(
            animation: controller5,
            builder: (context, child) {
              return Positioned(
                bottom: 150,
                right: 30 + (controller5.value * 100),
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha :0.6),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Text('🧟', style: TextStyle(fontSize: 45)),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Haunted House
          AnimatedBuilder(
            animation: controller6,
            builder: (context, child) {
              return Positioned(
                top: 380 + (controller6.value * 60),
                left: 140,
                child: GestureDetector(
                  onTap: gameWon ? null : onCorrectItemClicked,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha :0.3),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withValues(alpha :0.6),
                          blurRadius: 25,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🏚️', style: TextStyle(fontSize: 65)),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Fake Haunted House
          AnimatedBuilder(
            animation: controller1,
            builder: (context, child) {
              return Positioned(
                bottom: 320,
                right: 100 + (controller1.value * 40),
                child: GestureDetector(
                  onTap: gameWon ? null : onTrapClicked,
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.brown.withValues(alpha :0.4),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Text('🏠', style: TextStyle(fontSize: 50)),
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