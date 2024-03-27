import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/my_app_bar.dart';
import '../theme/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MyAppBar(
        title: "S E T T I N G S",
        actions: [],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // dark mode
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),

                    // switch toggle
                    CupertinoSwitch(
                      onChanged: (value) {
                        final isDark = ref.read(isDarkProvider);
                        if(isDark) {
                          ref.read(isDarkProvider.notifier).state = false;
                        } else {
                          ref.read(isDarkProvider.notifier).state = true;
                        }
                      },
                      value: ref.watch(isDarkProvider),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
