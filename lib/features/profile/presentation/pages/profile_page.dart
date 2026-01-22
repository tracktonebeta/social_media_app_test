import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;
import 'package:social_media_app_test/features/auth/domain/entities/app_user.dart' show AppUser;
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_cubit.dart' show AuthCubit;
import 'package:social_media_app_test/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_media_app_test/features/profile/presentation/cubits/profile_states.dart';
import 'package:social_media_app_test/features/profile/presentation/components/bio_box.dart';
import 'package:social_media_app_test/features/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubits>();

  late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();
    // on startup load the profile data
    // You might use a ProfileCubits (cubit/bloc) to load it,
    // for example:
    // context.read<ProfileCubits>().fetchUserProfile(widget.uid);
    profileCubit.fetchUserProfile(widget.uid);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubits, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {

          // get loaded user
          final user = state.profileUser;

          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          profileUser: user,
                        ),
                      ),
                    );
                  },
                  tooltip: 'Edit Profile',
                ),
              ],
            ),

            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Profile Picture
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      backgroundImage: user.profileImageUrl.isNotEmpty &&
                              user.profileImageUrl != 'null'
                          ? NetworkImage(user.profileImageUrl)
                          : null,
                      child: user.profileImageUrl.isEmpty ||
                              user.profileImageUrl == 'null'
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Name
                  Center(
                    child: Text(
                      user.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // User Email
                  Center(
                    child: Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BioBox(bio: user.bio),
                ],
              ),
            ),
          );
          } else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ProfileError) {
          return Scaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
        } else {
          // Handles ProfileInitial and any other unforeseen states
          return const Scaffold(
            body: Center(
              child: Text('No profile data available'),
            ),
          );
        }
      },
    );
  }
}