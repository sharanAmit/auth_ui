import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:password_strength/password_strength.dart';

import 'home_page.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authBox = Hive.box('AuthBox');
  bool isObscured = true;
  bool isError = false;

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
            child: ListView(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Log in",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade400)),
                ),
                const SizedBox(
                  height: 50,
                ),
                isError
                    ? const Text(
                        "Username and Password doesn't match",
                        style: TextStyle(color: Colors.red),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: userNameController,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
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
                    obscureText: isObscured,
                    validator: (text) {
                      if (text != null) {
                        return "Enter your password";
                      }
                      return null;
                    },
                    controller: passwordController,
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
                        labelText: "Password",
                        hintText: "Enter your password",
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 93, 121, 134)))),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (userNameController.text ==
                                authBox.get("UserName") &&
                            (passwordController.text ==
                                authBox.get("Password"))) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          setState(() {
                            isError = true;
                          });
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "New User? ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )),
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
