import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/screens/login/login_screen.dart';
import 'package:big_qazaq_app/app/screens/navigator/main_navigator.dart';
import 'package:big_qazaq_app/app/screens/splash/components/update_modal.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogged = false;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    setState(() {
      isLogged = userId.isNotEmpty; // Update isLogged based on userId presence
    });
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.buildNumber;
    String currentVersion = await ApiClient().getBundleVersion();
    if (version != currentVersion) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return UpdateModal(); // Replace with your dialog widget
        },
      );
    } else {
      // Delay for 3 seconds before navigating to the next screen
      Future.delayed(Duration(seconds: 2), () {
        if (isLogged) {
          // Navigate to HomeScreen or any other screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CustomNavigationBar()), // Replace HomeScreen with your desired screen
          );
        } else {
          // Navigate to LoginScreen or any other screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginScreen()), // Replace LoginScreen with your desired screen
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 4,
                child: Image.asset('assets/images/bq_logo.png')),
            SizedBox(height: 15),
            CircularProgressIndicator(
              color: Colors.black,
            ), // Optionally add a loading indicator
          ],
        ),
      ),
    );
  }
}
