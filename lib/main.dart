// main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_speed_code/firebase_options.dart';
import 'package:habit_speed_code/pages/login.dart'
    as Login; // Import your login page with an alias
import 'package:habit_speed_code/pages/homePage.dart';
import 'package:habit_speed_code/pages/navigation.dart'; // Import your home page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login', // Set the initial route to '/login'
      routes: {
        '/login': (context) => Login
            .LoginPage(), // Use LoginPage from the 'login.dart' file with its alias
        '/home': (context) => NavigationScreen(
              currentIndex: 1,
            ), // Define the route for HomePage
      },
    );
  }
}
