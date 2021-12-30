import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_stream_app/home.dart';
import 'package:movie_stream_app/screens/authentication%20screens/google_signin_provider.dart';
import 'package:movie_stream_app/screens/authentication%20screens/signup_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String? email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            onChanged: (value) => email = value,
            decoration: const InputDecoration(
              hintText: 'email',
            ),
          ),
          TextFormField(
            onChanged: (value) => password = value,
            decoration: const InputDecoration(
              hintText: 'password',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _signIn(email!, password!);
              },
              child: const Text('login')),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SignUpScreen()));
              },
              child: const Text('Register')),
          ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
            child: const Text('Signin via Google'),
          ),
        ],
      ),
    );
  }

  _signIn(String email, String password) async {
    final resp = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (resp.credential == null) {
      print(resp.toString());
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Login Successful')));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  }
}
