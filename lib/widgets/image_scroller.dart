import 'dart:async';

import 'package:flutter/material.dart';

class ImageScroller extends StatefulWidget {
  const ImageScroller({super.key});

  @override
  State<ImageScroller> createState() => _ImageScrollerState();
}

class _ImageScrollerState extends State<ImageScroller> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _locations = [
    'lib/assets/image_set/s5.jpg',
    'lib/assets/image_set/s6.jpg',
    'lib/assets/image_set/s10.jpg',
    'lib/assets/image_set/s12.jpg',
    'lib/assets/image_set/s22.jpg'
    // Add more image URLs here
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _locations.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _locations.length,
      itemBuilder: (context, index) {
        return Image.asset(
          _locations[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}
