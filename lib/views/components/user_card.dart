import 'package:flutter/material.dart';
import 'package:lelia/models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(user.userName),
      subtitle: Text(user.email),
      onTap: () {
        //open a user's report view for this user
      },
    );
  }
}
