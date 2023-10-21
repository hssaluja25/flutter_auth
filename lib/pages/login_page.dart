import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_once_again/components/my_button.dart';
import 'package:learning_once_again/components/my_textfield.dart';
import 'package:learning_once_again/components/square_tile.dart';
import 'package:learning_once_again/services/auth.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.auth, required this.toggleAuthPage});

  final Function() toggleAuthPage;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: [
              // Space at the very top
              SizedBox(height: ht * 0.055),

              // logo
              SizedBox(
                height: ht * 0.1118568,
                child: const Icon(
                  Icons.lock,
                  size: 100,
                ),
              ),

              SizedBox(height: ht * 0.055928),

              // welcome back, you've been missed!
              SizedBox(
                height: ht * 0.032,
                child: Center(
                  child: Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: ht * 0.02796),

              // username textfield
              SizedBox(
                height: ht * 0.071588,
                child: MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
              ),

              SizedBox(height: ht * 0.0111857),

              // password textfield
              SizedBox(
                height: ht * 0.071588,
                child: MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
              ),

              SizedBox(height: ht * 0.0111857),

              // forgot password?
              SizedBox(
                height: ht * 0.027,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          try {
                            await Auth(auth: auth)
                                .forgotPassword(email: usernameController.text);
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content:
                                      const Text('Password reset email sent'),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                      label: 'Okay',
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .removeCurrentSnackBar();
                                      }),
                                ),
                              );
                          } on Exception catch (error) {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: error.toString() ==
                                              '[firebase_auth/invalid-email] The email address is badly formatted.' ||
                                          error.toString() ==
                                              '[firebase_auth/channel-error] Unable to establish connection on channel.'
                                      ? const Text('Invalid email')
                                      : const Text('Something went wrong...'),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                      label: 'Okay',
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .removeCurrentSnackBar();
                                      }),
                                ),
                              );
                          }
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ht * 0.02796),

              // sign in button
              SizedBox(
                height: ht > 820 ? ht * 0.081655 : ht * 0.097,
                child: MyButton(
                  textOnBtn: 'Login',
                  onTap: () async {
                    if (_loginFormKey.currentState!.validate()) {
                      // form is valid
                      try {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        await Auth(auth: auth).signIn(
                            email: usernameController.text,
                            password: passwordController.text);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        // Automatically the 'user' stream would detect a change in the auth state and push the home page.
                        // so we don't need to push the home page ourselves.
                      } on Exception catch (error) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                error.toString() ==
                                        '[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.'
                                    ? 'Check your internet connection'
                                    : "Invalid login credentials. Did you sign up using your google or facebook account?",
                                style: const TextStyle(fontSize: 18),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Okay"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),

              SizedBox(height: ht * 0.055928),

              // or continue with
              SizedBox(
                height: ht * 0.02237,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ht * 0.055928),

              // google + apple sign in buttons
              SizedBox(
                height: ht * 0.09172,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    GestureDetector(
                      child:
                          const SquareTile(imagePath: 'lib/images/google.png'),
                      onTap: () async {
                        try {
                          await GoogleAuth().signInWithGoogle();
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content: Text(e.toString().startsWith(
                                        'PlatformException(network_error')
                                    ? 'Check your internet connection'
                                    : 'Google sign in cancelled')));
                        }
                      },
                    ),

                    const SizedBox(width: 25),

                    // facebook button
                    GestureDetector(
                      onTap: () async {
                        try {
                          await FbAuth().signInWithFacebook();
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                duration: const Duration(seconds: 6),
                                content: Text(e.toString().startsWith(
                                        '[firebase_auth/account-exists-with-different-credential] An account already exists')
                                    ? 'You have previously logged in with either Google or email. Please finish logging in using that method to continue to the app.'
                                    : 'Something went wrong')));
                        }
                      },
                      child: const SquareTile(
                          imagePath: 'lib/images/facebook.png'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ht * 0.055928),

              // not a member? register now
              SizedBox(
                height: ht * 0.032,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: toggleAuthPage,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: ht * 0.120805,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
