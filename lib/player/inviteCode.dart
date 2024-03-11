import 'package:findwho/database/Global.dart';
import 'package:findwho/database/AuthGlobal.dart';
import 'package:findwho/player/onlinePlayers.dart';
import 'package:findwho/room/components/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';

class InviteCode extends StatelessWidget {
  InviteCode({super.key});

  final TextEditingController _inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Colors.white),
          height: 250,
          width: Get.width / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Enter the invitation code:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: TextFormField(
                    autofocus: false,
                    controller: _inviteCodeController,
                    validator: (value) {
                      if (value!.isEmpty) return 'This field cannot be empty';
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      icon: Icon(Icons.send_rounded),
                      hintText: "Enter the invite code",
                      labelText: "Enter Code",
                    ),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                    onTap: () async {
                      print(_inviteCodeController.text);
                      invitationCode = _inviteCodeController.text;
                      await getZone();

                      if (zone != null) {
                        Map<String, dynamic>? data =
                            zone as Map<String, dynamic>?;

                        if (data != null && data.containsKey("Colors")) {
                          Map<String, dynamic> colorsMap =
                              data["Colors"] as Map<String, dynamic>;
                          List<String> trueColors = [];

                          // Iterate over colorsMap and add true colors to trueColors list
                          colorsMap.forEach((color, value) {
                            if (value == true) {
                              trueColors.add(color);
                            }
                          });

                          // Update show property based on trueColors list
                          colorItems.forEach((item) {
                            if (trueColors.contains(item.col)) {
                              item.show = false;
                            }
                          });
                          print("chinu");
                          print(_inviteCodeController.text);
                          await FirebaseFirestore.instance
                              .collection("zone")
                              .doc(_inviteCodeController.text)
                              .collection("game")
                              .doc(authQuerySnapshot.data()!["uid"])
                              .set({
                            "player": "na",
                            "color": "na",
                            "dice": "na",
                            "room": "na",
                            "weapon": "na",
                            "person": "na",
                            "uid": authQuerySnapshot.data()!["uid"],
                            "ready": "Not Ready",
                            "turn": "",
                            "times":{
                              "room": 1,
                              "weapon": 1,
                              "person": 1,},
                            "solutionFound": {
                              "room": {},
                              "weapon": {},
                              "person": {},
                            },
                          });
                          Get.to(OnlinePlayers());
                        }
                      } else {
                        GFToast.showToast(
                          "Invilid! code",
                          context,
                          toastPosition: GFToastPosition.TOP,
                          textStyle:
                              TextStyle(fontSize: 16, color: GFColors.ALT),
                          backgroundColor: GFColors.WARNING,
                          trailing: Icon(
                            Icons.close,
                            color: GFColors.SUCCESS,
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 200,
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.green),
                      child: Center(
                          child: Text(
                        "Enter",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    )),
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
