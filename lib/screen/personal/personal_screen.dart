import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  static const routeName = '/personal';
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Profile Edit Screen'),
    );
  }
}
