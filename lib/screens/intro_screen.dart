import 'package:flutter/material.dart';
import '../providers/intro_provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _startApp() {
    IntroProvider.setIntroCompleted(true);
    Navigator.pushReplacementNamed(context, '/launcher');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildPageContent(
                  "Welcome!",
                  "This is a brief description of the app.",
                  "assets/images/intro_screen.webp"),
              _buildPageContent(
                  "Simple Games",
                  "Try out a variety of simple games!",
                  "assets/images/intro_screen.webp"),
              _buildPageContent("Get Started", "Swipe ahead and get started!",
                  "assets/images/intro_screen.webp"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed:
                            _currentIndex == 2 ? () => _startApp() : null,
                        child: const Text(
                          "Start",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentIndex == index ? 12.0 : 8.0,
                    height: _currentIndex == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index ? Colors.blue : Colors.grey,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(String title, String description, String imagePath) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
