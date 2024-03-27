import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_request_model.dart';
import '../provider/auth_provider.dart';
import '../widgets/my_button.dart';
import '../widgets/my_textfield.dart';
import 'home_page.dart';


class RegisterPage extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  ConsumerState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  // register method
  Future<void> register() async {
    if(emailController.text.isEmpty) return;
    if(passwordController.text.isEmpty) return;

    if(passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("password and confirm doesn't matches"),
          );
        },
      );
      return;
    }

    ref.read(userLoginRequestProvider.notifier).state = UserRequestModel(emailController.text, passwordController.text);


    print(ref.read(userLoginRequestProvider));
    // authenticate user first
    await ref.read(signupProvider.future).then((credential) {
      if (credential!.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Something went wrong!!!"),
            );
          },
        );
      }
    }).catchError((e){
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Something went wrong!!!"),
          );
        },
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Image.asset(
                  'assets/images/unlock.png',
                  height: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Let\'s create an account for you',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: register,
                  text: "Sign Up",
                ),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}