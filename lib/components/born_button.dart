// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BornButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool loading;
  const BornButton({
    Key? key,
    required this.onTap,
    required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Visibility(
        visible: loading,
        replacement: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: KOrange, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Text(
            'Connexion',
            style: btnStyle,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: KOrange,
            size: 60,
          ),
        ),
      ),
    );
  }
}
