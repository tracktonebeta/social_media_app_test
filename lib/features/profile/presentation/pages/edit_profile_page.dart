import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:social_media_app_test/features/profile/domain/entities/profile_user.dart';
import 'package:social_media_app_test/features/profile/presentation/cubits/profile_cubits.dart';
import 'package:social_media_app_test/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser profileUser;
  
  const EditProfilePage({
    super.key,
    required this.profileUser,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _bioController;
  late final ProfileCubits _profileCubit;
  
  File? _selectedImageFile; // For mobile
  Uint8List? _selectedImageBytes; // For web
  String? _previewImageUrl; // For displaying selected image
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.profileUser.bio);
    _profileCubit = context.read<ProfileCubits>();
    _previewImageUrl = widget.profileUser.profileImageUrl;
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() {
      _isPickingImage = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result != null && result.files.single.path != null) {
        if (kIsWeb) {
          // For web, use bytes
          final bytes = result.files.single.bytes;
          if (bytes != null) {
            setState(() {
              _selectedImageBytes = bytes;
              _selectedImageFile = null;
              // Create a data URL for preview on web
              _previewImageUrl = null; // Will show placeholder until uploaded
            });
          }
        } else {
          // For mobile, use file path
          final filePath = result.files.single.path!;
          setState(() {
            _selectedImageFile = File(filePath);
            _selectedImageBytes = null;
            _previewImageUrl = filePath; // Show local file for preview
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  void _saveProfile() {
    _profileCubit.updateProfile(
      widget.profileUser.uid,
      _bioController.text.trim(),
      _selectedImageBytes, // For web
      _selectedImageFile?.path, // For mobile
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubits, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ProfileError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            BlocBuilder<ProfileCubits, ProfileState>(
              builder: (context, state) {
                final isLoading = state is ProfileLoading;
                return TextButton(
                  onPressed: (isLoading || _isPickingImage) ? null : _saveProfile,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          backgroundImage: _previewImageUrl != null && 
                                  _previewImageUrl!.isNotEmpty &&
                                  _previewImageUrl != 'null'
                              ? (_selectedImageFile != null
                                  ? FileImage(_selectedImageFile!) as ImageProvider
                                  : NetworkImage(_previewImageUrl!))
                              : null,
                          child: _previewImageUrl == null ||
                                  _previewImageUrl!.isEmpty ||
                                  _previewImageUrl == 'null'
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        if (_isPickingImage)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: BlocBuilder<ProfileCubits, ProfileState>(
                              builder: (context, state) {
                                final isLoading = state is ProfileLoading;
                                return IconButton(
                                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                  onPressed: (_isPickingImage || isLoading) ? null : _pickImage,
                                  tooltip: 'Change profile picture',
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Profile Picture',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap the camera icon to upload',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    if (_selectedImageFile != null || _selectedImageBytes != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'New image selected',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Bio Section
              Text(
                'Bio',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _bioController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Tell us about yourself...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 24),
              const Text(
                'You can write about your interests, hobbies, or anything you\'d like to share!',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
