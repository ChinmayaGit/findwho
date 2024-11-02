import 'package:findwho/Pages/Lobby/color_dice_picker.dart';
import 'package:findwho/components/controller/zone_controller.dart';
import 'package:findwho/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/colors.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/components/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/services.dart';

class InviteCode extends StatelessWidget {
  InviteCode({super.key});

  final ZoneController _zoneController = Get.put(ZoneController());
  final TextEditingController _inviteCodeController = TextEditingController();

  final List<ColorItem> colorItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Invite Code"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.white),
            // height: 250,
            // width: Get.width / 1.2,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Enter the invitation code:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: TextFormField(
                      controller: _inviteCodeController,
                      autofocus: false,
                      validator: (value) {
                        if (value!.isEmpty) return 'This field cannot be empty';
                        return null;
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter the invite code",
                        labelText: "Enter Code",
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            String inviteCode =
                                _inviteCodeController.text.trim();
                            print("Chinu");
                            print(inviteCode);
                            if (inviteCode.isEmpty) {
                              customToast(
                                  msg: "Invalid code is empty",
                                  context: context);
                              return;
                            }

                            QuerySnapshot querySnapshot =
                                await FirebaseFirestore.instance
                                    .collection('zone')
                                    .get();

                            bool codeFound = querySnapshot.docs
                                .any((doc) => doc.id == inviteCode);
                            print(codeFound);
                            if (codeFound) {
                              invitationCode = inviteCode;
                              Get.to(const ColorDicePicker(maxPlayer: 0));
                            } else {
                              customToast(
                                  msg: "Invalid code", context: context);
                            }
                          },
                          child: Icon(
                            Icons.arrow_forward, // Arrow icon
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('zone').snapshots(),
                  builder: (context, snapshot) {
                    // Check for connection state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // Handle errors
                    if (snapshot.hasError) {
                      return Center(child: Text("Something went wrong"));
                    }

                    // Check if there's data
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No zones available"));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // Get zone data for each document
                        var zoneData = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                        return Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text((index + 1).toString()),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                      zoneData["InvitationCode"] ?? "Unknown"),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                      zoneData["maxPlayers"].toString() ??
                                          "Unknown"),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // _inviteCodeController.text =
                                    //     zoneData["InvitationCode"];
                                    invitationCode = zoneData["InvitationCode"];

                                    Clipboard.setData(ClipboardData(
                                            text: zoneData["InvitationCode"]))
                                        .then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Copied to your clipboard !'),
                                        ),
                                      );
                                    });
                                    Get.to(const ColorDicePicker(maxPlayer: 0));
                                  },
                                  child: Text("Copy"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
