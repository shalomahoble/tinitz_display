// ignore_for_file: unused_field

import 'dart:async';
import 'package:flutter/material.dart';

class TextMarqueeDisplay extends StatefulWidget {
  const TextMarqueeDisplay({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TextMarqueeDisplayState createState() => _TextMarqueeDisplayState();
}

class _TextMarqueeDisplayState extends State<TextMarqueeDisplay> {
  List<Information> infoList = [
    Information("Information 1",
        "https://images.pexels.com/photos/20376317/pexels-photo-20376317/free-photo-of-ville-monument-building-batiment.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    Information("Information 2",
        "https://images.pexels.com/photos/20376317/pexels-photo-20376317/free-photo-of-ville-monument-building-batiment.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
    Information("Information 3",
        "https://images.pexels.com/photos/18330672/pexels-photo-18330672/free-photo-of-mer-aube-paysage-soleil-couchant.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load"),
    // Ajoutez autant d'informations que nécessaire
  ];

  int currentIndex = 0;
  Timer? _timer;
  bool isVisible = true;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        isVisible = false;
      });

      // Supprimer l'élément de la liste
      infoList.removeAt(currentIndex);

      _delayTimer = Timer(const Duration(seconds: 10), () {
        setState(() {
          // Vérifier si la liste n'est pas vide avant de définir currentIndex
          if (infoList.isNotEmpty) {
            currentIndex = (currentIndex) % infoList.length;
            isVisible = true;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Demo'),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: const Duration(seconds: 1),
          child: Card(
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  infoList[currentIndex].imagePath,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 8.0),
                Text(infoList[currentIndex].text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Information {
  final String text;
  final String imagePath;

  Information(this.text, this.imagePath);
}
