import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/sample.mp4')
      ..initialize().then((_) {
        setState(() {}); // Update the UI when the video is initialized
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: double.infinity,
          height: 300,
          child: Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(),
          ),
        ),
        // Only show the icon if the video is not playing
        _controller.value.isPlaying
            ? const SizedBox.shrink() // Hide the icon
            : IconButton(
                onPressed: () {
                  setState(() {
                    _controller.play(); // Play the video
                  });
                },
                icon: const Icon(
                  Icons.play_arrow,
                  size: 30,
                  color: Colors.white,
                ),
              ),
        // Show a pause icon when the video is playing
        _controller.value.isPlaying
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _controller.pause(); // Pause the video
                  });
                },
                icon: const Icon(
                  Icons.pause,
                  size: 30,
                  color: Colors.white,
                ),
              )
            : const SizedBox.shrink(), // Hide the pause icon
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
