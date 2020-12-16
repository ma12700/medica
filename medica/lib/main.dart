import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import './screens/splash_screen.dart';
import 'models/auth.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<bool> delay() async {
    return await Future.delayed(Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Medica',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blue[200],
          fontFamily: 'Lato',
        ),
        home: FutureBuilder(
            future: delay(),
            builder: (ctx, fetchResultSnapshot) =>
                fetchResultSnapshot.connectionState == ConnectionState.waiting
                    ? SplashScreen()
                    : Auth.userCredential != null
                        ? HomeScreen()
                        : AuthScreen()));
  }
}
