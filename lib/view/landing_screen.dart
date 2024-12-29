import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:qr_pres/routes/app_routes.dart';
import 'package:qr_pres/view/login/login.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 60),
          child: IntroductionScreen(
            showBackButton: false,
            showNextButton: false,
            onDone: () => _onIntroEnd(context),
            next: const Icon(Icons.arrow_forward),
            done: const Text(
              'ابدأ الآن',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff54D497),
                fontSize: 18,
              ),
            ),
            pages: [
              PageViewModel(
                title: "أهلاً بك في جمعية شباب الفرقان",
                body:
                    "نرحب بك في جمعية شباب الفرقان. نحن هنا لدعمك في رحلتك القرآنية",
                image: Image.asset("assets/images/logo.png"),
                decoration: const PageDecoration(
                  titleTextStyle:
                      TextStyle(fontFamily: "Alkalami", fontSize: 20),
                  bodyTextStyle: TextStyle(fontFamily: "Kufam", fontSize: 18),
                ),
              ),
              PageViewModel(
                title: "متابعة الحضور",
                body:
                    "يتيح لك هذا التطبيق تسجيل حضورك بسهولة، ومتابعة تقدمك في رحلتك القرآنية. نشكرك على اختيارك أن تكون جزءًا من هذا المجتمع المبارك",
                image: Image.asset("assets/images/bgIntro.png"),
                decoration: const PageDecoration(
                  titleTextStyle:
                      TextStyle(fontFamily: "Alkalami", fontSize: 20),
                  bodyTextStyle: TextStyle(fontFamily: "Kufam", fontSize: 18),
                ),
              ),
            ],
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeColor: Color(0xff54D497),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              
            ),
          ),
        ),
      ),
    );
  }

  void _onIntroEnd(context) {
    Get.offNamed(AppRoutes.login);
  }
}
