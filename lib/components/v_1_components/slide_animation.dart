import 'package:borne_flutter/controllers/AnimationControllerArticle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlideAnimation extends StatelessWidget {
  SlideAnimation({super.key});

  final animationController = Get.put(AnimationControllerArticle());
  @override
  Widget build(BuildContext context) {
    final animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController.animation,
      curve: Curves.easeInOut,
    ));
    return SlideTransition(
      position: animation,
      child: const Text("ANIMATION"),
    );
  }
}
