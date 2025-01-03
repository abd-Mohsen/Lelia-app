import 'package:flutter/material.dart';

class ScreenService {
  double screenHeightCm = 0;

  ScreenService(BuildContext context) {
    // Use MediaQuery to get screen metrics
    final screenHeightPixels = MediaQuery.of(context).size.height; // Logical pixels
    final pixelRatio = MediaQuery.of(context).devicePixelRatio; // Pixel density
    final dpi = pixelRatio * 160; // Dots per inch
    final inches = screenHeightPixels / dpi; // Height in inches
    screenHeightCm = inches * 2.54; // Convert inches to cm
  }
}
