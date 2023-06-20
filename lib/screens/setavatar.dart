import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_chat_app/colors.dart';

import '../provider/userdata.dart';

class SetAvatar extends StatefulWidget {
  const SetAvatar({super.key});

  @override
  State<SetAvatar> createState() => _SetAvatarState();
}

class _SetAvatarState extends State<SetAvatar> {
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "pick an avatar for you",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: primary2,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 150,
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: 6,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              constraints: const BoxConstraints(maxHeight: 100, maxWidth: 100),
              child: CircleAvatar(
                  radius: 50,
                  child: SvgPicture.network(
                    "https://api.multiavatar.com/${random.nextInt(100000)}?apikey=Zv59BsDJzcoPXx.svg",
                    height: 100,
                    width: 100,
                  )),
            );
          },
        ),
      ),
    );
  }
}
