import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/models/user_model.dart';
import 'package:lelia/views/user_view.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(
        user.userName,
        style: tt.titleMedium!.copyWith(color: cs.onBackground),
      ),
      subtitle: Text(
        user.email,
        style: tt.titleSmall!.copyWith(color: cs.onBackground),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        user.role,
        style: tt.titleSmall!.copyWith(color: cs.onBackground),
      ),
      onTap: () {
        // add statistics here (like in dashboard) if possible
        Get.to(UserView(user: user));
      },
    );
  }
}
