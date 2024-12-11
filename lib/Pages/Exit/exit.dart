import 'package:findwho/Pages/Auth/components/user_data_controller.dart';
import 'package:findwho/Pages/Home/home.dart';
import 'package:findwho/Pages/Lobby/select_board.dart';
import 'package:findwho/components/controller/zone_controller.dart';
import 'package:findwho/components/controller/zone_data_controller.dart';
import 'package:findwho/components/controller/zone_game_contoller.dart';
import 'package:findwho/components/controller/zone_solution_controller.dart';
import 'package:findwho/components/game_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Exit extends StatelessWidget {
  final bool last;

  Exit({required this.last, super.key});

  final TextEditingController _closeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final UserController _userController = Get.find<UserController>();
  /// Function to delete all documents in a subcollection
  Future<void> deleteSubCollection(DocumentReference parentDocRef, String subCollectionPath) async {
    CollectionReference subCollection = parentDocRef.collection(subCollectionPath);
    QuerySnapshot querySnapshot = await subCollection.get();

    WriteBatch batch = firestore.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Function to delete a zone document and its game subcollection
  Future<void> deleteZoneAndGames(String invitationCode) async {
    if (invitationCode.isEmpty) return; // Prevent empty path errors
    DocumentReference zoneDocRef = firestore.collection('zone').doc(invitationCode);

    // Delete the game subcollection
    await deleteSubCollection(zoneDocRef, 'game');
    // Delete the zone document
    await zoneDocRef.delete();
  }

  /// Function to reset all controllers and cleanup the state
  void resetControllers() {
    // Update user status without resetting UserController
    _userController.updateUserDocument({
      "inGame": GameStatusManager.idle,
      "inviteId": "NA",
    });

    // Delete specific controllers except UserController
    Get.delete<ZoneController>(force: true);
    Get.delete<ZoneGameController>(force: true); // Add other controllers as needed
    Get.delete<ZoneDataController>(force: true);
    Get.delete<ZoneSolutionController>(force: true);
    // Optionally, clear other dependencies registered with Get if required
    // while keeping UserController intact.
  }


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
            color: Colors.grey.shade200,
          ),
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
                    "Do you really want to exit and reset the game?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    try {
                      // Fetch the invitation code
                      String invitationCode = ""; // Replace with your logic

                      // Reset Firestore Data
                      if (last == false) {
                        await deleteZoneAndGames(invitationCode);
                      }

                      // Reset controllers and clear app state
                      resetControllers();

                      // Navigate to SelectBoard screen
                      Get.offAll(() => SelectBoard());

                      // Display success toast
                      GFToast.showToast(
                        "The game has been reset.",
                        context,
                        toastPosition: GFToastPosition.TOP,
                        textStyle: const TextStyle(fontSize: 16, color: GFColors.ALT),
                        backgroundColor: GFColors.SUCCESS,
                        trailing: const Icon(Icons.check, color: GFColors.DARK),
                      );
                    } catch (e) {
                      // Handle any errors
                      GFToast.showToast(
                        "Failed to reset the game: $e",
                        context,
                        toastPosition: GFToastPosition.TOP,
                        textStyle: const TextStyle(fontSize: 16, color: GFColors.ALT),
                        backgroundColor: GFColors.LIGHT,
                        trailing: const Icon(Icons.error, color: GFColors.LIGHT),
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
                      color: Colors.green,
                    ),
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const Home());
                  },
                  child: Container(
                    height: 60,
                    width: 200,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.red,
                    ),
                    child: const Center(
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
