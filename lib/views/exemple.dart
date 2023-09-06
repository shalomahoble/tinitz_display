import 'package:flutter/material.dart';

class Exemple extends StatefulWidget {
  const Exemple({super.key});

  @override
  State<Exemple> createState() => _ExempleState();
}

late AnimationController _controller;

class _ExempleState extends State<Exemple> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Vous pouvez ajuster la durée
    )
      ..repeat(reverse: true) // Répéter l'animation en sens inverse
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 1), () {
            _controller.reverse(); // Réinitialise l'animation
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(seconds: 15), () {
            _controller.forward();
          });
        }
      });
    _controller.forward();
  }

  final Tween<Offset> _offsetTween = Tween<Offset>(
    begin: const Offset(0.0, -2.0), // Position initiale (milieu)
    end: const Offset(0.0, -5.0), // Position finale (barre d'applications)
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _offsetTween.animate(_controller),
                child: Container(
                  width: double.infinity, // Largeur du conteneur
                  height: 100, // Hauteur du conteneur
                  color: Colors.blue,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
