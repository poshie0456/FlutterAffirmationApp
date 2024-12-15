// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, avoid_print, unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:math';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:positiveme/camera_page.dart';
import 'package:positiveme/diary.dart';
import 'package:positiveme/welcomeAI.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _controller;
  late PageController _pageController;

  int currIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video Background
          _controller.value.isInitialized
              ? Opacity(
                  opacity: 0.3,
                  child: VideoPlayer(_controller),
                )
              : const SizedBox.shrink(),

          // Main Content
          Column(
            children: [
              // Logo
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.08,
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.height * 0.02,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05, constraints: BoxConstraints(maxHeight: 25),
                    child: Image.asset("assets/applogo.png"),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currIndex = index;
                      });
                    },
                    children:  [
                      AffirmationWidget(),
                       mirror(),
                      DiaryApp(),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Bar
              BottomNavBar(
                pageController: _pageController,
                currIndex: currIndex,
                onTabSelected: (index) {
                  setState(() {
                    currIndex = index;
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class mirror extends StatelessWidget {
  const mirror({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return 

Scaffold(backgroundColor: Colors.transparent,
  body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie Animation
                  Lottie.asset(
                    "assets/loader.json",
                    width: MediaQuery.of(context).size.width * 0.4, // Responsive width
                    height: MediaQuery.of(context).size.width * 0.4, // Responsive height
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03), // Responsive spacing

                  // Title
                  Text(
                    "PositiveMe AI",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0, // Spacing for a more elegant look
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                  // Description Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Get affirmed and talk to AI about your mental health needs in real time. Powered by OpenAI’s advanced technology, PositiveMe AI offers a conversational experience designed to support and uplift you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5, // Increased line height for readability
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  // Continue Button with Gradient and Animation
                  GestureDetector(onTap: (){  Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) =>  TipsScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );},
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff4784B2), Color(0xffAB72AC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      height: 60, // Standard height for button
                      width: double.infinity, // Full width for the button
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText(
                            "Continue",
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                            speed: const Duration(milliseconds: 300),
                          ),
                        ],
                        pause: const Duration(seconds: 3),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      
    
  
);

  }
}



class BottomNavBar extends StatelessWidget {
  final PageController pageController;
  final int currIndex;
  final ValueChanged<int> onTabSelected;

  const BottomNavBar({
    required this.pageController,
    required this.currIndex,
    required this.onTabSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(
                icon: Icons.home_outlined,
                isSelected: currIndex == 0,
                onPressed: () => onTabSelected(0),
              ),
              _buildNavBarItem(
                icon: Icons.chat_bubble_outline,
                isSelected: currIndex == 1,
                isSpecial: true,
                onPressed: () => onTabSelected(1),
              ),
              _buildNavBarItem(
                icon: Icons.book_outlined,
                isSelected: currIndex == 2,
                onPressed: () => onTabSelected(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required IconData icon,
    required bool isSelected,
    bool isSpecial = false,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
  onTap: onPressed,
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 1),
    width: isSpecial ? 70 : 60,
    height: isSpecial ? 70 : 60,
    decoration: BoxDecoration(
      gradient: isSelected
          ? LinearGradient(
              colors: [Color(0xff4784B2), Color(0xffAB72AC)],
            )
          : null, // Apply gradient when selected
      color: isSelected
          ? null // Gradient takes priority when selected
          : Colors.white.withOpacity(0.1), // Default color when not selected
      shape: BoxShape.circle,
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: Colors.white.withOpacity(0.6),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ]
          : null,
      border: isSpecial
          ? Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 2,
            )
          : null,
    ),
    child: Icon(
      icon,
      color: isSelected || isSpecial
          ? Colors.white
          : Colors.white.withOpacity(0.7),
      size: isSpecial ? 32 : 28,
    ),
  ),
);

  }
}



class AffirmationWidget extends StatefulWidget {
  const AffirmationWidget({
    Key? key,
  }) : super(key: key);

  @override
  _AffirmationWidgetState createState() => _AffirmationWidgetState();
}

class _AffirmationWidgetState extends State<AffirmationWidget> {
  // ignore: prefer_final_fields
  TextEditingController _editNameController = TextEditingController();
  List<String> affirmations = [
    // Positive Energy
    "I am worthy of all the good things life has to offer.",
    "I radiate confidence and inner peace.",
    "I am grateful for all the lessons life teaches me.",
    "I am a source of inspiration and positivity for others.",
    "I am open to receiving all the blessings the universe has in store for me.",

    // Self-Love & Acceptance
    "I am deserving of success and happiness.",
    "I am worthy of love and respect.",
    "I forgive myself and others, releasing any resentment or negativity.",
    "I am enough, just as I am.",
    "I am worthy of my dreams and desires.",

    // Overcoming Challenges
    "I am capable of overcoming any obstacle that comes my way.",
    "I trust the journey, even when I do not understand it.",
    "I am resilient, strong, and capable of achieving my goals.",
    "I am free to create the life of my dreams.",
    "I am capable of achieving anything I set my mind to.",

    // Gratitude & Positivity
    "I am grateful for the journey of self-discovery and personal growth.",
    "I choose joy and optimism every day.",
    "I am grateful for the gift of life and all its possibilities.",
    "I trust that everything is unfolding for my highest good.",
    "I am grateful for the abundance that flows into my life.",

    // Success & Prosperity
    "I am a magnet for success, prosperity, and abundance.",
    "I am aligned with my purpose and passion.",
    "I am worthy of success, happiness, and fulfillment.",
    "I am confident in my ability to achieve my goals.",
    "I am a powerful creator, shaping my reality with my thoughts and beliefs.",

    // Inner Peace & Resilience
    "I am at peace with who I am and where I am going.",
    "I am resilient and capable of overcoming any challenge.",
    "I am at peace with my past, present, and future.",
    "I am aligned with the energy of abundance and prosperity.",
    "I am a unique and valuable individual, worthy of respect and admiration."
  ];

  String? randomAffirmation;

  int currindex = 0;
  static String s_name = "";
  Future<void> _loadNameFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedName = prefs.getString('name') ?? '';
    s_name = storedName;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadNameFromStorage();
    randomAffirmation = getRandomAffirmation();
  }

  String getRandomAffirmation() {
    final Random random = Random();
    return affirmations[random.nextInt(affirmations.length)];
  }

  void changeAffirmation() {
    setState(() {
      randomAffirmation = getRandomAffirmation();
    });
  }

@override
Widget build(BuildContext context) {
  return 
    
       
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "Hi $s_name",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    child: const Icon(Icons.edit, color: Colors.white),
                    onTap: () {
                   showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: screenHeight * 0.02,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF121212), // Darker background
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              const Center(
                child: Text(
                  'Edit Name',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Text Field
              TextField(
                controller: _editNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E), // Slightly lighter dark
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.8)),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.1,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_editNameController.text.isNotEmpty) {
                        await _saveNameToStorage(_editNameController.text);
                        await _loadNameFromStorage();
                        Navigator.pop(context);

                        // SnackBar for Success
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Name saved successfully!',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blueAccent.withOpacity(0.8),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: screenWidth * 0.1,
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  },
);


                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => changeAffirmation(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              
                      Text(
                        randomAffirmation!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.sizeOf(context).height * 0.025,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                     
                    ],
                  ),
                ),
              ),
            ),
         
          
        
      ],
    
  );
}


  Future<void> _saveNameToStorage(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    setState(() {});
  }
}
