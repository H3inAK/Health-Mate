import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../features/authentication/cubits/profile/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final fbAuth.User fbUser;
  final VoidCallback onProfileUpdated;
  const EditProfilePage({
    Key? key,
    required this.fbUser,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  Uint8List? _image;

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final image = await pickedImage.readAsBytes();
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (mounted) {
      if (_nameController.text.isNotEmpty) {
        await context.read<ProfileCubit>().updateProfileName(
              uid: widget.fbUser.uid,
              newName: _nameController.text,
            );
      }
    }

    if (mounted) {
      if (_image != null) {
        await context.read<ProfileCubit>().updateProfilePicture(
              uid: widget.fbUser.uid,
              file: _image!,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.fbUser.displayName!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state.profileStatus == ProfileStatus.loading
                      ? null
                      : () async {
                          _saveProfile().then((_) {
                            widget.onProfileUpdated();
                            Navigator.pop(context);
                          });
                        },
                  child: const Text("Save", style: TextStyle(fontSize: 18)),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.profileStatus == ProfileStatus.loading) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(40.0),
                child: LinearProgressIndicator(),
              ));
            } else if (state.profileStatus == ProfileStatus.error) {
              return Center(child: Text(state.error.message));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _selectImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : CachedNetworkImageProvider(widget.fbUser.photoURL!)
                              as ImageProvider,
                      child: _image == null
                          ? const Icon(Icons.photo_camera, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    autofocus: true,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      labelText: 'Edit Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
