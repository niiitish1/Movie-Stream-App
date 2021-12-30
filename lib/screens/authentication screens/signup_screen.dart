import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  String? _email, _password, _username;
  final formKey = GlobalKey<FormState>();
  String emailError = '';
  String userNameError = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onTap: () => emailError = '',
              onChanged: (value) => _email = value,
              decoration: const InputDecoration(hintText: 'Email'),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                        .hasMatch(value)) {
                  return 'enter correct email';
                } else if (emailError.length > 2) {
                  return emailError;
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              onChanged: (value) => _username = value,
              decoration: const InputDecoration(hintText: 'Username'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'enter username';
                } else if (userNameError.length > 2) {
                  return userNameError;
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              onChanged: (value) => _password = value,
              decoration: const InputDecoration(hintText: 'Password'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'enter passpword';
                } else {
                  return null;
                }
              },
            ),
            ElevatedButton(
                onPressed: () {
                  emailError = '';
                  userNameError = '';
                  if (formKey.currentState!.validate()) {
                    _registerUser();
                  }
                },
                child: const Text("Register")),
          ],
        ),
      )),
    );
  }

  _registerUser() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('Users/$_username');
    try {
      DatabaseEvent event = await ref.once();
      if (event.snapshot.exists) {
        userNameError = 'username taken';
        formKey.currentState!.validate();
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: _email!, password: _password!);
        Map<String, dynamic> post = {
          "email": _email,
          "username": _username,
          "password": _password,
        };
        await ref.set(post);
      }
    } catch (error) {
      if (error is FirebaseException) {
        if (error.code == 'email-already-in-use') {
          emailError = 'Email is already register';
          formKey.currentState!.validate();
        }
      }
    }
  }
}
