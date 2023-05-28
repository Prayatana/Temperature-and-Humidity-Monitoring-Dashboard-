import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'home.dart';



class OnboardingScreen extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  OnboardingScreen({super.key});

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RealTimeDataPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "Welcome to the Temperature and Humidity Monitoring Dashboard App! Stay informed about the environmental conditions with real-time data updates.",
          image: Image.asset('assets/uno.png'),
          decoration: pageDecoration(),
        ),
        PageViewModel(
          title: "Real-time Data",
          body: "Monitor the temperature and humidity in real-time with live updates. Get instant insights into the changing conditions and stay updated with accurate readings.",
          image: Image.asset('assets/dos.png'),
          decoration: pageDecoration(),
        ),
        PageViewModel(
          title: "Data Visualization",
          body: "Visualize the temperature and humidity data in interactive charts. Analyze trends, patterns, and variations over time to make informed decisions and optimize your environment.",
          image: Image.asset('assets/tres.png'),
          decoration: pageDecoration(),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      done: Text("Get Started"),
      showSkipButton: true,
      skip: Text("Skip"),
      next: Icon(Icons.arrow_forward),
      dotsDecorator: dotsDecorator(),
    );
  }

  DotsDecorator dotsDecorator() {
    return DotsDecorator(
      activeColor: Colors.blue,
      size: Size(10.0, 10.0),
      activeSize: Size(22.0, 10.0),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
    );
  }

  PageDecoration pageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 16.0),
      // descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.all(24.0),
    );
  }
}