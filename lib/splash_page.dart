import 'package:flutter/material.dart';
import 'login_page.dart';

// Use StatelessWidget if you don't need a delay, but keep StatefulWidget for logic
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // It's good practice to ensure the navigation doesn't happen
    // if the widget has been disposed (e.g., if user hits back).
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // 1. Run initialization tasks here (e.g., check shared_preferences)
    await Future.delayed(const Duration(seconds: 2));

    // 2. Check if the widget is still in the tree before navigating
    if (!mounted) return;

    // 3. Navigate
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // The background color should match your native splash background color
      backgroundColor: Colors.white,
      body: Center(
        // Use Center instead of SizedBox.expand for better centering if the image is small
        child: Image(
          image: AssetImage('assets/image/logo.jpeg'),
          fit: BoxFit.cover, // Ensure it covers the entire screen area
        ),
      ),
    );
  }
}
