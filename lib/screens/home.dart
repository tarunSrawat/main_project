import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_project/route/route_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Home Page of "),
            Text(user!.email!.trim()),
            ElevatedButton(onPressed: (){
              setState(() {
                FirebaseAuth.instance.signOut();
                Navigator.popAndPushNamed(context, Routes.loginPage);
              });
            }, child: Text("Sign out"))
          ],
        ),
      ),
    );
  }
}
