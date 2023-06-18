import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_chat_app/colors.dart';
import 'package:personal_chat_app/provider/userdata.dart';
import 'package:personal_chat_app/screens/home_page.dart';
import 'package:personal_chat_app/screens/signup.dart';
import 'package:personal_chat_app/services/api_services.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _obscureText = true;
  TextEditingController _name = TextEditingController();

  TextEditingController _password = TextEditingController();
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
                          "Don't have an account?",
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
                              return const SignUp();
                            }));
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(primary)),
                          child: const Text(
                            "Get Started",
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
                      "Welcome Back",
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
                      decoration: InputDecoration(
                          hintText: "Username",
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
                          border: OutlineInputBorder(
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
                          String response =
                              await login(_name.text, _password.text);
                          if (response == "success") {
                            await UserData().getdata();
                            Timer(Duration(seconds: 1), () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return Home();
                              }));
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("incorrect username or pass")));
                          }
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Forgot your password",
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
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
