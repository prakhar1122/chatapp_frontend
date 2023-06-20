import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:personal_chat_app/colors.dart';
import 'package:personal_chat_app/provider/userdata.dart';
import 'package:personal_chat_app/provider/userdata_provider.dart';
import 'package:personal_chat_app/screens/all_users.dart';
import 'package:personal_chat_app/screens/main_chat.dart';
import 'package:personal_chat_app/screens/setavatar.dart';
import 'package:personal_chat_app/screens/signup.dart';
import 'package:personal_chat_app/screens/welcone_screen.dart';
import 'package:personal_chat_app/services/api_services.dart';

import '../services/sharedpref.dart';
import '../services/socket_client.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final PrefsService _prefsService = PrefsService();

  final _socketClient = SocketClient.instance.socket!;
  late TabController tabController;
  // late List<String> cache;
  // Future getdata() async {
  //   await UserData().getdata();
  // }

  @override
  void initState() {
    // UserData().getdata();
    // getdata();
    log(UserData.cache.length.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: primary2,
            onPressed: () {
              // setState(() {});
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SetAvatar();
              }));
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            backgroundColor: primary2,
            leadingWidth: 400,
            leading: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    getAvatar();
                  },
                  child: CircleAvatar(
                      child: SvgPicture.network(
                          "https://api.multiavatar.com/${UserData.cache[1]}?apikey=Zv59BsDJzcoPXx.svg")),
                ),
                Text(
                  UserData.cache[1],
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                ),
              ],
            ),
            actions: [
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: GestureDetector(
                          onTap: () {
                            UserData().cleardata();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const WelcomeScreen();
                            }));
                          },
                          child: Text('signout')),
                    ),
                  ];
                },
              )
            ],
            bottom: TabBar(
              indicatorColor: primary,
              labelColor: Colors.white,
              // controller: tabController,
              tabs: [
                Tab(
                  text: 'all chats',
                  icon: Icon(
                    Icons.chat_bubble_sharp,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  text: 'all users',
                  icon: Icon(
                    Icons.verified_user_sharp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            FutureBuilder(
              future: getallchats(UserData.cache[0]),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
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
            FutureBuilder(
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
          ])),
    );
  }
}
