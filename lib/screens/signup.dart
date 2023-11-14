import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _regexEmail = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final _regexPassword = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
  bool _passwordVisibility = false;
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _userSignUp() async {
    if (_formKey.currentState!.validate()){
      try{
        final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        final user = FirebaseAuth.instance.currentUser;
      }
      catch (error){
        if (error is SocketException){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No network connection"),
            ),
          );
        }
        else if (error is FirebaseAuthException){
          switch (error.code){
            case 'email-already-in-use':
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("This email is already in use."),
                ),
              );
              break;
            case 'weak-password':
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("The password is too weak"),
                ),
              );
              break;
            default :
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("An error has occurred."),
                ),
              );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Sign Up"),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _emailController,
                enabled: true,
                obscureText: false,
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if (value!.isEmpty || value == null){
                    return "Please enter an email address";
                  }
                  else if (!_regexEmail.hasMatch(value)){
                    return "Please enter a valid email address";
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _passwordController,
                enabled: true,
                obscureText: !_passwordVisibility,
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if (value == null || value.isEmpty){
                    return "Please enter a password";
                  }
                  else if (!_regexPassword.hasMatch(value)){
                    return "Please enter a Strong Password";
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: (!_passwordVisibility) ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _passwordVisibility = !_passwordVisibility;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: _userSignUp,
                  child: const Text("Sign Up")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
