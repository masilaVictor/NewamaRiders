import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newamariders/auth/login.dart';
import 'package:newamariders/general/dashboard.dart';

class FlushScreen extends StatefulWidget {
  const FlushScreen({super.key});

  @override
  State<FlushScreen> createState() => _FlushScreenState();
}

class _FlushScreenState extends State<FlushScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
   
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then((value) {

       FirebaseAuth.instance
                                      .authStateChanges()
                                      .listen((User? user) {
                                    if (user == null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DashboardPage()));
                                    }
                                  });
     
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/rider.png',
              width: 500,
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -100.0, 0.0),
              child: const Text(
                'NEWAMA DELIVERY',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SpinKitCubeGrid(
              color: Colors.red,
              size: 50,
            )
          ],
        ),
      ),
    );
  }
}