import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:positiveme/camera_page.dart';

class TipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for mental health focus
      appBar: AppBar(
 
        backgroundColor: Colors.transparent,
        actions: [Padding(padding: EdgeInsets.only(right:20),child: SizedBox(height: 20,child: Image.asset("assets/applogo.png")))],foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Introduction
            Text(
              "Empowered by AI to Help You with Your Mental Health",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Here are some tips to get started.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),

            // Tips (Checklist)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildChecklistItem(
                      context,
                      "Get Personalized Affirmations",
                      "Let PositiveMe AI give you the affirmations you need to lift your mood.",
                    ),
                    _buildChecklistItem(
                      context,
                      "Talk to PositiveMe AI About Your Problems",
                      "Share your thoughts with PositiveMe AI, and get advice or a listening ear.",
                    ),
             _buildChecklistItem(
  context,
  "Tailored Generative Experience",
  "Engage in a personalized conversation with PositiveMe AI. Share your thoughts and get advice, affirmations, or simply a listening ear.",
),

               
                    SizedBox(height: 20),
                    // Motivation text
                    Text(
                      "You're not alone. AI is here to guide you through your mental wellness journey.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Continue Button
            GestureDetector(onTap: (){  Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) =>  CameraPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );},
                    child: Container(
                      alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff4784B2), Color(0xffAB72AC)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.6),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
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
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper function to create a checklist item with rounded corners and subtle shadow
  Widget _buildChecklistItem(BuildContext context, String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withOpacity(0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.check,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
