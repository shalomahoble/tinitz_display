// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:borne_flutter/config/app_style.dart';
import 'package:flutter/material.dart';

class BornFieldTextPassword extends StatefulWidget {
  final TextEditingController controller;
  const BornFieldTextPassword({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<BornFieldTextPassword> createState() => _BornFieldTextPasswordState();
}

class _BornFieldTextPasswordState extends State<BornFieldTextPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mot de passe', style: labelStyle),
          const SizedBox(height: 5),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Le mot de passe ne doit pas etre vide";
              }
              return null;
            },
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            controller: widget.controller,
            cursorColor: KOrange,
            obscureText: _obscureText,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () => setState(() {
                  _obscureText = !_obscureText;
                }),
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                color: KOrange,
              ),
              labelStyle: labelStyle,
              hintStyle: hintStyle,
              errorStyle: errorLabelStyle,
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey.shade300,
              hintText: 'Mot de passe',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
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
