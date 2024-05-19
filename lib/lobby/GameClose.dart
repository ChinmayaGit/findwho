import 'package:findwho/database/GameMap.dart';
import 'package:findwho/database/Global.dart';
import 'package:findwho/lobby/SelectBoard.dart';
import 'package:findwho/lobby/WaitingLobby.dart';
import 'package:findwho/room/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameCloser extends StatelessWidget {
  final String text;

  GameCloser({super.key, required this.text});

  final TextEditingController _closeController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                    if (text == "true") {
                      await getZone();
                      noOfPlayer = zone['PlayerCount'];
                      await getZoneData();
                      await getZoneUserData();
                      await fetchDataIfGameClosed();
                      await fetchSolutionIfGameClosed();
                      Get.to(() => const Home());
                    } else if (text == "waiting") {
                      await getZone();
                      noOfPlayer = zone['PlayerCount'];
                      await getZoneData();
                      await getZoneUserData();
                      Get.to(() => const WaitingLobby());
                    }
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
                    getZone();

                    print('All documents and subcollections inside the document have been deleted.');

                    // Reference to the document
                    DocumentReference docRef = firestore.collection('zone').doc(invitationCode);

// Delete all subcollections inside the document
                    await _deleteCollection(docRef);

                    if (text == "true") {
                      if (noOfPlayer <= 1) {

                        print('All documents and subcollections inside the document have been deleted.');

                        // Reference to the document
                        DocumentReference docRef = firestore.collection('zone').doc(invitationCode);

// Delete all subcollections inside the document
                        await _deleteCollection(docRef);

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(authId)
                            .update({
                          "inGame": "NO",
                          "inviteId": "NA",
                        });
                      } else {
                        FirebaseFirestore.instance
                            .collection('zone')
                            .doc(invitationCode)
                            .update({
                          "PlayerCount": noOfPlayer - 1,
                        });
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(authId)
                            .update({
                          "inGame": "NO",
                          "inviteId": "NA",
                        });
                      }
                      noOfPlayer = 0;
                      Get.to(() => SelectBoard());
                    } else if (text == "waiting") {
                      if (noOfPlayer <= 1) {
                        // Reference to the document

                        print('All documents and subcollections inside the document have been deleted.');

                        // Reference to the document
                        DocumentReference docRef = firestore.collection('zone').doc(invitationCode);

// Delete all subcollections inside the document
                        await _deleteCollection(docRef);
                        await _deleteCollection(docRef);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(authId)
                            .update({
                          "inGame": "NO",
                          "inviteId": "NA",
                        });
                      } else {
                        FirebaseFirestore.instance
                            .collection('zone')
                            .doc(invitationCode)
                            .update({
                          "PlayerCount": noOfPlayer - 1,
                        });
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(authId)
                            .update({
                          "inGame": "NO",
                          "inviteId": "NA",
                        });
                      }

                      noOfPlayer = 0;
                      Get.to(() => SelectBoard());
                    }
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
