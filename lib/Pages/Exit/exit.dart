import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Home/home.dart';
import 'package:findwho/Pages/Lobby/components/controller/zone_controller.dart';
import 'package:findwho/Pages/Lobby/select_board.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/components/game_status.dart';
import 'package:findwho/database/fetch_data.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Exit extends StatelessWidget {
  Exit({super.key});

  final TextEditingController _closeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ZoneController _zoneController = Get.put(ZoneController());
  final UserController _userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Do you want to continue your previous game",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await fetchDataIfGameClosed();
                    await fetchSolutionIfGameClosed();
                    Get.to(() => const Home());
                    GFToast.showToast(
                      "OK",
                      context,
                      toastPosition: GFToastPosition.TOP,
                      textStyle:
                          const TextStyle(fontSize: 16, color: GFColors.ALT),
                      backgroundColor: GFColors.WARNING,
                      trailing: const Icon(
                        Icons.close,
                        color: GFColors.SUCCESS,
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 200,
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.green),
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    DocumentReference docRef =
                        firestore.collection('zone').doc(invitationCode);
                    await _deleteCollection(docRef);

                    if (_zoneController.zoneDoc.value!.maxPlayers <= 1) {
                      print(
                          'All documents and subcollections inside the document have been deleted.');

                      // Reference to the document
                      DocumentReference docRef =
                          firestore.collection('zone').doc(invitationCode);

// Delete all subcollections inside the document
                      await _deleteCollection(docRef);

                      _userController.updateUserDocument({
                        "inGame": GameStatusManager.idle,
                        "inviteId": "NA",
                      });

                    } else {
                      _zoneController.updateZoneDocument({
                        "PlayerCount": _zoneController.zoneDoc.value!.maxPlayers - 1,
                      });
                      _userController.updateUserDocument({
                        "inGame": GameStatusManager.idle,
                        "inviteId": "NA",
                      });
                    }
                    Get.to(() => SelectBoard());

                    GFToast.showToast(
                      "Game Exited",
                      context,
                      toastPosition: GFToastPosition.TOP,
                      textStyle:
                          const TextStyle(fontSize: 16, color: GFColors.ALT),
                      backgroundColor: GFColors.WARNING,
                      trailing: const Icon(
                        Icons.close,
                        color: GFColors.SUCCESS,
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 200,
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.red),
                    child: const Center(
                      child: Text(
                        "NO",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteCollection(DocumentReference docRef) async {
    // Get a reference to the collection
    CollectionReference collectionRef = docRef.collection('game');

    // Get all documents in the collection
    QuerySnapshot snapshot = await collectionRef.get();

    // Delete documents in a batch
    WriteBatch batch = firestore.batch();
    snapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    // Commit the batch
    await batch.commit();

    // Recursively delete subcollections
    snapshot.docs.forEach((doc) async {
      await _deleteCollection(doc.reference);
    });
  }
}
