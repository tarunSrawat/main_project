import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/route/route_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  void _userLogin() async {
    if (_formKey.currentState!.validate()){
      try{
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        final user = FirebaseAuth.instance.currentUser;
        if (user == null){
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No such user found!',
          );
        }
        Navigator.pushNamed(context, Routes.homePage);
      }
      catch (error){
        if (error is SocketException) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No network connection"),
            ),
          );
        }
        else if (error is FirebaseAuthException && error.code == 'user-not-found'){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("User not found"),
            ),
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error has occurred'),
            ),
          );
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
              Text("Login"),
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
                  onPressed: _userLogin,
                  child: const Text("Sign In")
              ),
            ],
          ),
        ),
      ),
    );
  }
}