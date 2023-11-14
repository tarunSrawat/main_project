import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_project/screens/home.dart';
import 'package:main_project/screens/login.dart';
import 'package:main_project/screens/signup.dart';

class Routes {
  static const String loginPage = "/login";
  static const String signUpPage = "/signUp";
  static const String forgotPassword = "/forgot-password";
  static const String verifyEmail = "/verify-email";
  static const String homePage = "/homePage";
}

class RouteManager {
  void changePage(BuildContext context, String pageName) {
    try {
      Navigator.of(context).pushReplacementNamed(pageName);
    } catch (e) {
      // Handle the error.
    }
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.signUpPage:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case Routes.loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      default:
        return MaterialPageRoute(builder: (_) => SignUpPage());
    }
  }
}
