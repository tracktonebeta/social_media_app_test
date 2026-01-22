import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_test/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_media_app_test/features/auth/presentation/pages/auth_page.dart';
import 'package:social_media_app_test/features/home/presentation/pages/home_page.dart';
import 'package:social_media_app_test/features/profile/data/firebase_profile_repos.dart';
import 'package:social_media_app_test/features/profile/presentation/cubits/profile_cubits.dart' show ProfileCubits;
import 'package:social_media_app_test/features/storage/data/firebase_storage_repo.dart';
import 'package:social_media_app_test/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  // auth repo
  final authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();
  final storageRepo = FirebaseStorageRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo),
        ),
        BlocProvider<ProfileCubits>(
          create: (context) => ProfileCubits(profileRepo: profileRepo, storageRepo: storageRepo),
        ),
      ],
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
