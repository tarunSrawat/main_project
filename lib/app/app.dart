import 'package:flutter/material.dart';
import 'package:main_project/auth/user_provider.dart';
import 'package:provider/provider.dart';
import '../route/route_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  Future<bool> isUserSignedInAndPersistedState() async {
    // Get the current user.
    final user = FirebaseAuth.instance.currentUser;

    // Check if the user is signed in and persisted state.
    if (user == null) {
      return false;
    }

    try {
      await user.reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is signed in and persisted state.
    Future<bool> isUserSignedIn = isUserSignedInAndPersistedState();

    // Wait for the result of the `isUserSignedIn` future before proceeding.
    return FutureBuilder<bool>(
      future: isUserSignedIn,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Get the value of the future.
          final isSignedIn = snapshot.data!;

          // Navigate to the appropriate screen based on the sign-in state.
          if (isSignedIn) {
            // The user is signed in, so display the app.
            return Provider<UserProvider>(
              create: (_) => UserProvider(),
              child: const MaterialApp(
                initialRoute: Routes.homePage,
                debugShowCheckedModeBanner: false,
                onGenerateRoute: RouteManager.generateRoute,
                title: "Minor Project",
              ),
            );
          } else {
            // The user is not signed in, so navigate to the login screen.
            return MaterialApp(
              initialRoute: Routes.loginPage,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RouteManager.generateRoute,
              title: "Minor Project",
            );
          }
        } else {
          // The future is still loading, so display a progress indicator.

          // Add screen splash there

          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
