import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user.dart';
import '../provider/user_provider.dart';
import 'user_location_page.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(usersProvider).when(
      data: (users) {
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, i) {
            final user = users[i];
            return UserTile(
              user: user,
            );
          },
        );
      },
      error: (e, s) => const Text("Error"),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => UserLocationPage(user: user,)));
        },
        tileColor: Colors.green,
        title: Text(
          user.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.person, color: Colors.white),
      ),
    );
  }
}