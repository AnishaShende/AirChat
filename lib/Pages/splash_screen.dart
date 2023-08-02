import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:chat_app/services/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.darkBackground, //const Color.fromRGBO(45, 47, 47, 1),
      body: Center(
        child: FlutterSplashScreen.gif(
          backgroundColor: NeumorphicColors.darkBackground,
          gifPath: 'assets/splash_animation.gif',
          gifWidth: 150,
          gifHeight: 150,
          defaultNextScreen: AuthGate(),
          duration: const Duration(milliseconds: 4000),
          // onInit: () async {
          //   debugPrint("onInit 1");
          //   await Future.delayed(const Duration(milliseconds: 3000));
          //   debugPrint("onInit 2");
          // },
          // onEnd: () async {
          //   debugPrint("onEnd 1");
          //   debugPrint("onEnd 2");
          // },
        ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Lottie.network(
        //         "https://assets10.lottiefiles.com/packages/lf20_nhmiuj9f.json",
        //         controller: _controller, onLoaded: (compos) {
        //       _controller
        //         ..duration = compos.duration
        //         ..forward().then((value) => Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => AuthGate())));
        //     },
        //     width: MediaQuery.of(context).size.height*0.30,
        //     height: MediaQuery.of(context).size.height*0.30,
        //     ),
        //     Text("AirChat", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF333333),),),
        //   ],
        // ),
      ),
    );
  }
}
