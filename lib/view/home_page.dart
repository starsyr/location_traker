import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/user_provider.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/my_drawer.dart';
import 'admin_page.dart';
import 'user_page.dart';

class HomePage extends ConsumerWidget {
  final String id;
  const HomePage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MyAppBar(
        title: "H O M E",
        actions: [],
      ),
      drawer: const MyDrawer(),
      body: ref.watch(userProvider(id)).when(
          data: (user) {
            // print(user.location);
            return user.isAdmin ? const AdminPage() : UserPage(user: user,);
          },
          error: (e, s) {
            print(e);
            print(s);
            return const Text("Error");
          },
          loading: () => const CircularProgressIndicator()),
    );
  }
}