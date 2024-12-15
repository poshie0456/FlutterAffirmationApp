import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:positiveme/service.dart';
import 'package:audioplayers/audioplayers.dart';  // Import audioplayers package

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  TextEditingController _messageController = TextEditingController();
  late AnimationController _animationController;
  bool isLoading = false;
  String? generatedResponse;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _cameraController.initialize();
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _messageController.dispose();
    _animationController.dispose();
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  Future<void> _fetchAffirmation() async {
    setState(() {
      isLoading = true;
      generatedResponse = null;
    });

    final service = Service();
    try {
      String response = await service.textGeneration(
        aboutText: _messageController.text,
      );

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        generatedResponse = response;
        isLoading = false;
      });

      if (generatedResponse!.isNotEmpty) {
        // Play the generated speech
        String audioFilePath = await service.generateAndPlaySpeech(generatedResponse!);

        // Play the audio using the AudioPlayer
        if (audioFilePath.isNotEmpty) {
          _audioPlayer.play(DeviceFileSource(audioFilePath), ); // Play the audio file
        }
      }
    } catch (e) {
      setState(() {
        generatedResponse = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

  void _resetState() {
    setState(() {
      _messageController.clear();
      generatedResponse = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Image.asset(
                        'assets/applogo.png',
                        height: 40,
                        width: 40,
                      ),
                 
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_cameraController);
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          GestureDetector(
                            onTap: () {
                              if (_messageController.text.isNotEmpty) {
                                _fetchAffirmation();
                              }
                            },
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1 + _animationController.value * 0.2,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff4784B2),
                                          Color(0xffAB72AC),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.send, color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          _messageController.clear();
                          await _fetchAffirmation();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff4784B2), Color(0xffAB72AC)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Affirm Me",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading || generatedResponse != null)
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: isLoading ? 1.0 : 0.9,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Container(
                              height: screenHeight * 0.6,
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        generatedResponse ?? "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: _resetState,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 40),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff4784B2),
                                            Color(0xffAB72AC),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
