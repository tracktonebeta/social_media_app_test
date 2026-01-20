import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_test/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_app_test/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_app_test/features/post/presentation/pages/home_page.dart';
import 'package:social_media_app_test/themes/light_mode.dart';

class MyApp extends StatelessWidget {

  // auth repo

  final authRepo = FirebaseAuthRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            // No-op for navigation for now. Handle navigation here if needed.
          },
          builder: (context, state) {
            if (state is Unauthenticated) {
              return const AuthPage();
            } else {
              // TODO: Replace this Placeholder with HomePage when implemented.
              return const HomePage();
            }
          },
        ),
      ),
    );
  }
}
