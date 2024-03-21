import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_speed_code/pages/navigation.dart';
import 'registration.dart'; // Import your registration page file
import 'homePage.dart'; // Import your home page file

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key); // Use 'Key?' instead of 'super.key'

  void _login(BuildContext context) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Navigate to the home page after successful login
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // HomePage(user: FirebaseAuth.instance.currentUser!)),
                  NavigationScreen(
                    currentIndex: 0,
                  )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/MainBackground.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    // Your existing widgets for the background image
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    // Your existing widgets for the login form
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ),
                        );
                      },
                      child: Text("Register Now"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
