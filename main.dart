import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(DigitalPictureFrame());
}

class DigitalPictureFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Picture Frame',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: PictureFrameScreen(),
    );
  }
}

class PictureFrameScreen extends StatefulWidget {
  @override
  _PictureFrameScreenState createState() => _PictureFrameScreenState();
}

class _PictureFrameScreenState extends State<PictureFrameScreen> {
  final List<String> imageUrls = [
    "assets/image1.jpg",
    "assets/image2.jpg",
    "assets/image3.jpg",
    "assets/image4.jpg",
  ];

  final List<String> imageDescriptions = [
    "A beautiful sunrise over the mountains.",
    "A peaceful beach with golden sand.",
    "A scenic forest pathway covered in autumn leaves.",
    "A breathtaking night sky filled with stars."
  ];

  int _currentImageIndex = 0;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startSlideshow();
  }

  void _startSlideshow() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (!_isPaused) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % imageUrls.length;
        });
      }
    });
  }

  void _togglePauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Text(
          "Digital Picture Frame",
          style: TextStyle(
            color: Colors.pink[800],
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink[100]!, Colors.pink[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 10),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: imageUrls[_currentImageIndex],
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, size: 50, color: Colors.red),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              imageDescriptions[_currentImageIndex],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.pink[900],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePauseResume,
        backgroundColor: Colors.white,
        tooltip: _isPaused ? "Resume Slideshow" : "Pause Slideshow",
        child: Icon(
          _isPaused ? Icons.play_arrow : Icons.pause,
          color: Colors.pink[600],
        ),
      ),
    );
  }
}
