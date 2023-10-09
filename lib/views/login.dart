import 'package:borne_flutter/components/components.dart';
import 'package:borne_flutter/config/app_style.dart';
import 'package:borne_flutter/config/size_config.dart';
import 'package:borne_flutter/controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  Login({super.key});

  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  connectBorne() {
    if (_formKey.currentState!.validate()) {
      Get.find<LoginController>().loginBorne(
        code: codeController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockHorizontal! * 5,
            vertical: SizeConfig.blockHorizontal! * 5,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/tinitz-logo.png',
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockHorizontal! * 50,
                ),
                /*     Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.blockHorizontal! * 50,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/tinitz-logo.png'),
                    ),
                  ),
                ), */
                Text(
                  'Connectez-vous',
                  style: titleWelcome,
                ),
                Text(
                  'Bon retour,  \nVous nous avez manqué!',
                  style: titleWelcome.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 15),
                BornFieldText(controller: codeController),
                BornFieldTextPassword(controller: passwordController),
                Obx(
                  () => BornButton(
                    loading: Get.find<LoginController>().loading.value,
                    onTap: () {
                      connectBorne();
                    },
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Conçu et développé par ',
                        style: titleWelcome.copyWith(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        children: const [
                          TextSpan(
                              text: 'TINITZ', style: TextStyle(color: KOrange)),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
