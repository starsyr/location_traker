import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_traker/helpers/location_helper.dart';

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
    final inCircle = user.location.where((e) {
      final date = (e['date'] as Timestamp).toDate();
      return DateTime.now().isAfter(date) && LocationHelper.isWithinCircle(e['lat'], e['lng']);
    });
    final outCircle = user.location.where((e) {
      final date = (e['date'] as Timestamp).toDate();
      return DateTime.now().isAfter(date) && !LocationHelper.isWithinCircle(e['lat'], e['lng']);
    });
    final inCircleDates = inCircle.map((e) => (e['date'] as Timestamp).toDate()).toList();
    inCircleDates.sort((a, b) => a.compareTo(b));
    final outCircleDates = outCircle.map((e) => (e['date'] as Timestamp).toDate()).toList();
    outCircleDates.sort((a, b) => a.compareTo(b));

    final totalInCircle = inCircleDates.isEmpty
        ? 0
        : ((inCircleDates.last.hour * 60) + inCircleDates.last.minute) -
            ((inCircleDates.first.hour * 60) + inCircleDates.first.minute);
    final totalOutCircle = outCircleDates.isEmpty
        ? 0
        : ((outCircleDates.last.hour * 60) + outCircleDates.last.minute) -
            ((outCircleDates.first.hour * 60) + outCircleDates.first.minute);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => UserLocationPage(
                        user: user,
                      )));
        },
        tileColor: Colors.green,
        title: Text(
          user.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: const Icon(Icons.person, color: Colors.white),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateTime.now().toIso8601String().split('T').first,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Alan içi: ${totalInCircle > 60 ? '${totalInCircle / 60} saat' : '$totalInCircle daka'}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Alan dışı: ${totalOutCircle > 60 ? '${totalOutCircle / 60} saat' : '$totalOutCircle daka'}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
