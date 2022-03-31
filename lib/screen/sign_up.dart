import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:password_strength/password_strength.dart';

import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authBox = Hive.box('AuthBox');
  bool isObscured = true;
  bool isObscured1 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width >
                    MediaQuery.of(context).size.height
                ? 0.9 * MediaQuery.of(context).size.height
                : 0.9 * MediaQuery.of(context).size.width,
            child: ListView(children: [
              const SizedBox(
                height: 100,
              ),
              Text("Sign up",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade400)),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Username can't be empty.";
                    } else if (text.length < 4) {
                      return "Username is too short.";
                    }
                    return null;
                  },
                  controller: userNameController,
                  decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "Enter your username",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 93, 121, 134)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Email id is required";
                    } else if (text.length < 4) {
                      return "Too short";
                    } else if (!EmailValidator.validate(text)) {
                      return "Please provide a valid email";
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your mail",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 93, 121, 134)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (text) {
                    if (text != null) {
                      final strength = estimatePasswordStrength(text);
                      if (strength < 0.3) return 'This password is weak!';
                    } else {
                      return "Password is required.";
                    }

                    return null;
                  },
                  controller: passwordController,
                  obscureText: isObscured,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          },
                          icon: Icon(isObscured
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      labelText: 'Password',
                      hintText: "Enter a password",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 93, 121, 134)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: isObscured1,
                  controller: confirmPasswordController,
                  validator: (text) {
                    if (text != null) {
                      if (text != passwordController.text) {
                        return 'This password is not matched';
                      }
                    } else {
                      return "Confirm password is required";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscured1 = !isObscured1;
                            });
                          },
                          icon: Icon(isObscured1
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      labelText: "Confirm Password",
                      hintText: "Enter your password again",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 93, 121, 134)))),
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        authBox.put("UserName", userNameController.text);
                        authBox.put("Email", emailController.text);
                        authBox.put("Password", passwordController.text);
                        authBox.put(
                            "Confirm_password", confirmPasswordController.text);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      }
                    },
                    child: const Text("Register")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have account? ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
