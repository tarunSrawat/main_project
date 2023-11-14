import 'package:flutter/material.dart';
import 'package:main_project/auth/user_provider.dart';

class UserDetailsWidget extends StatelessWidget {
  final UserProvider provider;

  UserDetailsWidget(this.provider);

  @override
  Widget build(BuildContext context) {
    final user = provider.user;
    return Text(user?.email ?? '');
  }
}