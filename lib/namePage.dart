// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:positiveme/home.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool isNameEntered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveNameToStorage(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }

  void _navigateToHome() async {
    if (_nameController.text.isNotEmpty) {
      await _saveNameToStorage(_nameController.text);
  

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(seconds: 10),
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 2.0,
                  colors: [
                    Color(0xff2a2d41),
                    Color(0xff1c1e2e),
                  ],
                  stops: [0.5, 1.0],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon or Decorative Element
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      size: MediaQuery.of(context).size.height * 0.08,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Welcome Text
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "Welcome to PositiveMe",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Input Field
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Name',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isNameEntered = value.isNotEmpty;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        if (isNameEntered)
                          Text(
                            "Great! Let's get started.",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: MediaQuery.of(context).size.height *
                                  0.018,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Continue Button
                  AnimatedScale(
                    scale: isNameEntered ? 1.0 : 0.9,
                    duration: const Duration(milliseconds: 300),
                    child: GestureDetector(
                      onTap: _navigateToHome,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff4784B2), Color(0xffAB72AC)],
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
