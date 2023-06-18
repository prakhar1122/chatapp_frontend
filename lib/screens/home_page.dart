import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:personal_chat_app/colors.dart';
import 'package:personal_chat_app/provider/userdata.dart';
import 'package:personal_chat_app/provider/userdata_provider.dart';
import 'package:personal_chat_app/screens/main_chat.dart';
import 'package:personal_chat_app/services/api_services.dart';

import '../services/sharedpref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PrefsService _prefsService = PrefsService();

  // late List<String> cache;
  // Future getdata() async {
  //   await UserData().getdata();
  // }

  @override
  void initState() {
    // UserData().getdata();
    _tabController = TabController(length: 2, vsync: this);
    log(UserData.cache.length.toString());
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.chat)),
            Tab(icon: Icon(Icons.contacts)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
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
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
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
                              "harsh",
                              // snapshot.data[index]["name"].toString(),
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
        ],
      ),
    );
  }
}
