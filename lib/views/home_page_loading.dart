import 'package:borne_flutter/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomePageLoading extends StatelessWidget {
  const HomePageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: SizeConfig.blockHorizontal! * 40,
                      height: SizeConfig.blockHorizontal! * 25,
                      child: Shimmer(
                        enabled: true,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.blockHorizontal! * 40,
                      height: SizeConfig.blockHorizontal! * 8,
                      child: Shimmer(
                        enabled: true,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: SizedBox(
                    child: Shimmer(
                      enabled: true,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: SizedBox(
                    width: SizeConfig.blockHorizontal! * 50,
                    height: SizeConfig.blockHorizontal! * 50,
                    child: Shimmer(
                      enabled: true,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: SizeConfig.blockHorizontal! * 40,
                    height: SizeConfig.blockHorizontal! * 25,
                    child: Shimmer(
                      enabled: true,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.blockHorizontal! * 60,
                    height: SizeConfig.blockHorizontal! * 10,
                    child: Shimmer(
                      enabled: true,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockHorizontal! * 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
