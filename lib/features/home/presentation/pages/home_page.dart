import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app_test/features/home/presentation/components/my_drawer.dart';
import 'package:social_media_app_test/features/post/presentation/pages/upload_post_page.dart' show UploadPostPage;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          // upload new post button
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Post',
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => UploadPostPage(),
              )
            ),
          ),
          
        ],
      ),

    // DRAWER
    drawer: MyDrawer(),
      
    );
  }
}