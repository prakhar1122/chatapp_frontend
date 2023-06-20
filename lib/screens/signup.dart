import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_chat_app/screens/setavatar.dart';
import 'package:personal_chat_app/screens/welcone_screen.dart';
import 'package:personal_chat_app/services/api_services.dart';

import '../colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: gradient),
            height: size.height / 3,
            width: size.width,
          ),
          Positioned(
            top: size.height / 3 - 50,
            child: Container(
                height: size.height - (size.height / 3) - 50,
                width: size.width,
                decoration: decoration),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                // physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const WelcomeScreen();
                            }));
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(primary)),
                          child: const Text(
                            "Sign in",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "talky",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Nice to have you",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Enter your details below",
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _email,
                      obscureText: _obscureText,
                      decoration: const InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _password,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          suffix: GestureDetector(
                            onTap: _togglePasswordVisibility,
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          hintText: "Password",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          // color: rgbColor3,
                          gradient: LinearGradient(
                            colors: [primary, rgbColor3],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: MaterialButton(
                        minWidth: 300,
                        onPressed: () async {
                          String response = await register(
                              _name.text, _email.text, _password.text);
                          if (response == "user") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("username already exist")));
                          } else if (response == "email") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("email already in use")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("you have succesfully registered")));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return SetAvatar();
                            }));
                            Timer(Duration(seconds: 3), () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return WelcomeScreen();
                              }));
                            });
                          }
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
