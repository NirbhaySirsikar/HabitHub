import 'package:flutter/material.dart';
import 'package:habithubtest/services/auth.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignUpPage({super.key, required this.showLoginPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Please  Enter your information and create your account",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    hintText: 'Enter your Username',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.cyan,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.cyan,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    )),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.cyan,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => AuthService().emailSignUp(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),context,_usernameController.text.trim()),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue)),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('I am a member! '),
                  GestureDetector(
                    onTap: () => widget.showLoginPage(),
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //     width: double.infinity,
              //     height: 40,
              //     child: Text('Signup with',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //             fontSize: 17, fontWeight: FontWeight.w300))),
              // SizedBox(
              //   height: 40,
              //   child: Center(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         // IconButton(onPressed: (){}, icon:Image.asset('assets/apple-logo.png-')),
              //         IconButton(
              //             onPressed: () {},
              //             icon: const FaIcon(FontAwesomeIcons.google)),
              //         IconButton(
              //             onPressed: () {},
              //             icon: const FaIcon(FontAwesomeIcons.apple))
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    ));
  }
}
