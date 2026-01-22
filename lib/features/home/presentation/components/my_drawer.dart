import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_cubit.dart' show AuthCubit;
import 'package:social_media_app_test/features/profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.person, size: 80),
            const SizedBox(height: 16),
            // Drawer tiles
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Navigate to Home or close drawer
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to Profile
                Navigator.of(context).pop();

                final user = context.read<AuthCubit>().currentUser;
                if (user != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: user.uid),
                    ),
                  );
                } else {
                  // Show error message if user is not logged in
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in to view your profile'),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search'),
              onTap: () {
                // Navigate to Search
                Navigator.of(context).pop();
                // Implement navigation to Search page if exists
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to Settings
                Navigator.of(context).pop();
                // Implement navigation to Settings page if exists
              },
            ),
            const Spacer(),
            Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                // Trigger logout from AuthCubit
                context.read<AuthCubit>().logout();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}