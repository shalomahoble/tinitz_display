import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimationControllerArticle extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void onInit() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _startAnimation();
    super.onInit();
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward().whenComplete(() {
      _startAnimation();
    });
  }

  Animation<double> get animation => _animationController.view;

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}
