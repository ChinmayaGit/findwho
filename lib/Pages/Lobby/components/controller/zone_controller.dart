import 'dart:async';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/Pages/Lobby/components/model/zone_model.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneController extends GetxController {
  Rx<ZoneModel?> zoneDoc = Rx<ZoneModel?>(null);
  var zoneDataCollection = <ZoneModel>[].obs;
  RxBool isLoadingZoneController = false.obs;

  // final CollectionReference zoneCollection = FirebaseFirestore.instance.collection('zone');
  final DocumentReference<Map<String, dynamic>> zoneFetchDoc= FirebaseFirestore.instance.collection('zone').doc(invitationCode);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Initialize zoneDocument with the current invitationCode
    fetchZoneDocument();
    subscribeToUpdates();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> createZoneDocument({required int maxPlayer}) async {
    isLoadingZoneController.value = true;
    print(maxPlayer);
    try {
      await zoneFetchDoc
          .set({
        "maxPlayers": maxPlayer,
        "InvitationCode": invitationCode,
        "Date": DateTime.now(),
        "RoomCreated": false,
        "Turn": 1,
        "solutionFound": {
          "rooms": 0,
          "weapons": 0,
          "persons": 0,
        },
        "Colors": {
          "Red": false,
          "Green": false,
          "Blue": false,
          "Yellow": false,
          "Orange": false,
          "Purple": false,
        },
      });
    } catch (e) {
      print('Error : $e');
    } finally {
      isLoadingZoneController.value = false;
    }
  }

  // void fetchZoneCollection() {
  //   zoneCollection.snapshots().listen((snapshot) {
  //     zoneDataCollection.value =
  //         snapshot.docs.map((doc) =>
  //             ZoneModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
  //   });
  // }

  Future<void> fetchZoneDocument() async {
    isLoadingZoneController.value = true;
    try {
      var snapshot = await zoneFetchDoc.get();

      if (snapshot.exists) {
        zoneDoc.value = ZoneModel.fromFirestore(snapshot);
        // print('Document exist in zone_controller');
      } else {
        print('Document does not exist in zone_controller');
      }
    } catch (e) {
      print('Error fetching zone data: $e');
    } finally {
      isLoadingZoneController.value = false;
    }
  }

  Future<void> updateZoneDocument(Map<String, dynamic> updates) async {
    isLoadingZoneController.value = true;
    try {
      await zoneFetchDoc.update(updates);
      // Fetch the updated document to update the local state
      await fetchZoneDocument();
    } catch (e) {
      print('Error updating zone data: $e');
    } finally {
      isLoadingZoneController.value = false;
    }
  }
  void subscribeToUpdates() {
    zoneFetchDoc.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        zoneDoc.value = ZoneModel.fromFirestore(snapshot);
      } else {
        print('Document does not exist for updating zone_controller');
      }
    });
  }
}