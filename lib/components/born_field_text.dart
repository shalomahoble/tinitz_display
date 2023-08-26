// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/config/app_style.dart';
import 'package:flutter/material.dart';

class BornFieldText extends StatelessWidget {
  final TextEditingController controller;
  const BornFieldText({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Code', style: labelStyle),
          const SizedBox(height: 5),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Le code ne doit pas etre vide";
              }
              return null;
            },
            controller: controller,
            cursorColor: Colors.red,
            decoration: InputDecoration(
              labelStyle: labelStyle,
              hintStyle: hintStyle,
              errorStyle: errorLabelStyle,
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey.shade300,
              hintText: 'Code',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
