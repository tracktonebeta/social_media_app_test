import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app_test/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app_test/features/auth/presentation/cubits/auth_cubit.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {

  // For mobile image picking
  String? imagePath;

  // For web image picking
  Uint8List? imageBytes;

  // Text controller for caption
  final TextEditingController captionController = TextEditingController();

  // current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // get current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // build ui
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}