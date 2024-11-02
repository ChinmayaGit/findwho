import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Home/home.dart';
import 'package:findwho/components/controller/zone_controller.dart';
import 'package:findwho/Pages/Lobby/select_board.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/components/game_status.dart';
import 'package:findwho/components/allocater.dart';
import 'package:findwho/database/fetch_zone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Exit extends StatelessWidget {
  bool last;

  Exit({required this.last,super.key});

  final TextEditingController _closeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final ZoneController _zoneController = Get.put(ZoneController());
  final UserController _userController = Get.put(UserController());

  // Function to delete all documents in a subcollection
  Future<void> deleteSubCollection(DocumentReference parentDocRef, String subCollectionPath) async {
    CollectionReference subCollection = parentDocRef.collection(subCollectionPath);
    QuerySnapshot querySnapshot = await subCollection.get();

    // Create a WriteBatch for deleting documents in the subcollection
    WriteBatch batch = firestore.batch();

    // Iterate through each document and add to the batch
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit the batch
    await batch.commit();
  }

// Function to delete a zone document and its game subcollection
  Future<void> deleteZoneAndGames(String invitationCode) async {
    DocumentReference zoneDocRef = firestore.collection('zone').doc(invitationCode);

    // Delete the game subcollection first
    await deleteSubCollection(zoneDocRef, 'game');

    // Now delete the zone document
    await zoneDocRef.delete();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Colors.grey.shade200),
          height: 250,
          width: Get.width / 1.2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Do you really want to exit from this round?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      // await fetchDataIfGameClosed();
                      // await fetchSolutionIfGameClosed();
                      // DocumentReference docRef =
                      // firestore.collection('zone').doc(invitationCode);
                      // await _deleteCollection(docRef);
                      invitationCode="";
                      if(last == false){
                      //   DocumentReference docRef =
                      // firestore.collection('zone').doc(invitationCode);
                      //
                      // await docRef.delete();
                        DocumentReference zoneDocRef = firestore.collection('zone').doc(invitationCode);

                        // Delete the game subcollection
                        await deleteSubCollection(zoneDocRef, 'game');

                        // Now delete the zone document
                        await zoneDocRef.delete();
                      _userController.updateUserDocument({
                        "inGame": GameStatusManager.idle,
                        "inviteId": "NA",
                      });

                        // await zoneDocRef // Specify the document ID
                        //     .update({
                        //   "maxPlayers": _zoneController.zoneDoc.value!.maxPlayers - 1,
                        // });

                      }else{
                        _userController.updateUserDocument({
                          "inGame": GameStatusManager.idle,
                          "inviteId": "NA",
                        });
                      }


                      // if (_zoneController.zoneDoc.value!.maxPlayers <= 1) {
                      //   print(
                      //       'All documents and subcollections inside the document have been deleted.');
                      //
                      //   await _deleteCollection(docRef);
                      //
                      //   _userController.updateUserDocument({
                      //     "inGame": GameStatusManager.idle,
                      //     "inviteId": "NA",
                      //   });
                      //
                      // } else {

                        // _userController.updateUserDocument({
                        //   "inGame": GameStatusManager.idle,
                        //   "inviteId": "NA",
                        // });
                      // }
                      Get.offAll(SelectBoard());

                     //todo empty the controller
                      GFToast.showToast(
                        "The game has ended",
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
                      Get.to(() => const Home());
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
                SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: GestureDetector(
                //     onTap: () async {
                //     },
                //     child: Container(
                //       height: 60,
                //       width: 200,
                //       decoration: ShapeDecoration(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(18.0),
                //           ),
                //           color: Colors.red),
                //       child: const Center(
                //         child: Text(
                //           "Reset",
                //           style: TextStyle(color: Colors.white, fontSize: 20),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 5,
                // )
              ],
            ),
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
