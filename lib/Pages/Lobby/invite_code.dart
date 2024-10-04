import 'package:findwho/Pages/Lobby/color_dice_picker.dart';
import 'package:findwho/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/colors.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/components/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';

class InviteCode extends StatelessWidget {
  InviteCode({super.key});

  final TextEditingController _inviteCodeController = TextEditingController();

  final List<ColorItem> colorItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(centerTitle: true,title: Text("Invite Code"),),

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
                    String inviteCode = _inviteCodeController.text.trim();
                    if (inviteCode.isEmpty) {
                      // Handle empty invite code scenario
                      customToast(msg: "Invalid code", context: context);
                      return;
                    }

                    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('zone').get();
                    bool codeFound = false;

                    for (var doc in querySnapshot.docs) {
                      if (doc.id == inviteCode) {
                        codeFound = true;
                        break;
                      }
                    }

                    if (codeFound) {
                      invitationCode = inviteCode;
                      Get.to(const ColorDicePicker(maxPlayer: 0,));
                    } else {
                      customToast(msg: "Invalid code", context: context);
                    }





                  },
                  child: Container(
                    height: 60,
                    width: 200,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Text(
                        "Enter",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
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
