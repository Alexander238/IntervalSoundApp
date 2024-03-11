import 'package:flutter/material.dart';
import '../Design/ThemeData.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passVis = false;

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final FocusNode textFocusNodeEmail = FocusNode();
  bool _isEditingEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // to avoid bottom overflow when text field is being used.
      resizeToAvoidBottomInset: false,
      body: SafeArea(bottom: false, child: SigninWidget()),
    );
  }

  String? _validateEmail(String value) {
    value = value.trim();

    if (_emailTextController.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a valid email address';
      }
    }

    return null;
  }

  Widget SigninWidget() {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 7,
        ),
        Center(
            child: Container(
          margin: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            children: [
              Text("Welcome Back!",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),

              //Email
              TextField(
                focusNode: textFocusNodeEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: _emailTextController,
                onChanged: (value) {
                  setState(() {
                    _isEditingEmail = true;
                  });
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Email or Username",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.mail_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  errorText: _isEditingEmail
                      ? _validateEmail(_emailTextController.text)
                      : null,
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),

              // Password
              TextField(
                key: const ValueKey('passwordSignInField'),
                controller: _passwordTextController,
                style: const TextStyle(color: Colors.black),
                obscureText: !_passVis,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Password",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passVis
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _passVis = !_passVis;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              // Login
              ElevatedButton(
                onPressed: () {
                  //signIn();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: mainTheme.colorScheme.primary,
                    minimumSize: Size.fromHeight(
                        MediaQuery.of(context).size.height * 0.075),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular((25)))),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              // Forgot Password
              TextButton(
                key: const ValueKey('forgotPassword'),
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  //Navigate to forgot password screen
                },
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: Text('Forgot password?'),
                ),
              ),

              // Google
              ElevatedButton(
                onPressed: () {
                  //signInWithGoogle(context: context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: mainTheme.colorScheme.secondary,
                    minimumSize: Size.fromHeight(
                        MediaQuery.of(context).size.height * 0.075),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular((25)))),
                child: const Text(
                  "Google",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),

              // Sign Up
              Row(
                children: [
                  const Text(
                    "You have no account yet?",
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      //Navigator push to signup screen
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Sign Up!',
                        style: TextStyle(color: mainTheme.colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }
}
