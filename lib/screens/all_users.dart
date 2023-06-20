import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:personal_chat_app/colors.dart';
import 'package:personal_chat_app/provider/userdata.dart';
import 'package:personal_chat_app/provider/userdata_provider.dart';
import 'package:personal_chat_app/screens/main_chat.dart';
import 'package:personal_chat_app/screens/signup.dart';
import 'package:personal_chat_app/screens/welcone_screen.dart';
import 'package:personal_chat_app/services/api_services.dart';

import '../services/sharedpref.dart';
import '../services/socket_client.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers>
    with SingleTickerProviderStateMixin {
  final PrefsService _prefsService = PrefsService();

  final _socketClient =
      SocketClient.instance.socket!; // late List<String> cache;
  // Future getdata() async {
  //   await UserData().getdata();
  // }

  @override
  void initState() {
    // UserData().getdata();
    log(UserData.cache.length.toString());
    log("alll users");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary2,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 20),
          child: Text(
            UserData.cache[1],
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
        // actions: [
        //   PopupMenuButton(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     itemBuilder: (BuildContext context) {
        //       return [
        //         PopupMenuItem(
        //           child: GestureDetector(
        //               onTap: () {
        //                 Navigator.pushReplacement(context,
        //                     MaterialPageRoute(builder: (BuildContext context) {
        //                   return const WelcomeScreen();
        //                 }));
        //               },
        //               child: Text('signout')),
        //         ),
        //       ];
        //     },
        //   )
        // ],
      ),
      body: Column(
        children: [
          Material(
            color: primary2,
            child: const Row(
              children: [
                SizedBox(
                  width: 12,
                ),
                Text(
                  "all users",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                )
              ],
            ),
          ),
          SizedBox(
            height: 400,
            child: FutureBuilder(
              future: getall(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data[index]["name"].toString() ==
                        UserData.cache[1]) {
                      return Container();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          addChat(
                              UserData.cache[0], snapshot.data[index]["_id"]);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Mainchat(
                              receiver: snapshot.data[index]["name"].toString(),
                              image: "image",
                            );
                          }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data[index]["name"].toString(),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
