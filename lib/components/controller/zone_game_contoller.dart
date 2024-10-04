import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/components/model/zone_game_model.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneGameController extends GetxController {
  Rx<ZoneGameModel?> zoneGameDoc = Rx<ZoneGameModel?>(null);
  var zoneGameCollection = <ZoneGameModel>[].obs;
  RxBool isLoadingZoneGameController = RxBool(true);

  final DocumentReference<Map<String, dynamic>> zoneFetchDocGame = FirebaseFirestore.instance.collection('zone').doc(invitationCode).collection('game').doc(authUid);
  final CollectionReference zoneFetchCollectionGame = FirebaseFirestore.instance.collection('zone').doc(invitationCode).collection('game');

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchZoneGameCollection();
    fetchZoneGameDocument();
    subscribeToUpdates();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> createZoneGameDocument() async {
    isLoadingZoneGameController.value = true;
    try {
      await zoneFetchDocGame.set({
        "color": "na",
        "dice": 0,
        "persons": [],
        "playerTurn": 0,
        "ready": false,
        "rooms": [],
        "uid": authUid,
        "weapons": [],
      });
    } catch (e) {
      print('Error : $e');
    } finally {
      isLoadingZoneGameController.value = false;
    }
  }

  void fetchZoneGameCollection() {
    isLoadingZoneGameController.value = true;

    zoneFetchCollectionGame.snapshots().listen((snapshot) {
      final List<ZoneGameModel> fetchedZones = snapshot.docs.map((doc) {
        final data = doc.data();
        if (data != null) {
          return ZoneGameModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
        } else {
          return null;
        }
      }).where((element) => element != null).cast<ZoneGameModel>().toList();

      zoneGameCollection.value = fetchedZones;

      // Debugging information
      print("Fetched zoneGameCollection length: ${zoneGameCollection.length}");
      for (var zone in zoneGameCollection) {
        print("Zone UID: ${zone.uid}");
      }

      isLoadingZoneGameController.value = false;
    }, onError: (error) {
      print("Error fetching zone data: $error");
      isLoadingZoneGameController.value = false;
    });
  }

  Future<void> updateZoneGameCollection(String uid, Map<String, dynamic> updates) async {
    isLoadingZoneGameController.value = true;
    try {
      // Update the specific document by uid
      await zoneFetchCollectionGame.doc(uid).update(updates);
    } catch (e) {
      print('Error updating zone game collection: $e');
    } finally {
      isLoadingZoneGameController.value = false;
    }
  }

  Future<void> fetchZoneGameDocument() async {
    isLoadingZoneGameController.value = true; // Assuming this is an ObservableBool
    try {
      var snapshot = await zoneFetchDocGame.get();
      if (snapshot.exists) {
        zoneGameDoc.value = ZoneGameModel.fromFirestore(snapshot);
        print('Document fetched successfully');
      } else {
        print('Document does not exist in zone_game_controller');
      }
    } catch (e) {
      print('Error fetching zone game data: $e');
    } finally {
      isLoadingZoneGameController.value = false;
    }
  }

  Future<void> updateZoneGameDocument(Map<String, dynamic> updates) async {
    isLoadingZoneGameController.value = true;
    try {
      await zoneFetchDocGame.update(updates);
      await fetchZoneGameDocument();
    } catch (e) {
      print('Error updating zone game data: $e');
    } finally {
      isLoadingZoneGameController.value = false;
    }
  }

  void subscribeToUpdates() {
    zoneFetchDocGame.snapshots().listen(
          (snapshot) {
        if (snapshot.exists) {
          zoneGameDoc.value = ZoneGameModel.fromFirestore(snapshot);
          print('Document updated in zone_game_controller');
        } else {
          print('Document does not exist for updating zone_game_controller');
          zoneGameDoc.value = null; // Clearing the value or handle as per your app logic
        }
      },
      onError: (error) {
        print('Error listening to zone game updates: $error');
      },
      cancelOnError: true, // Cancel the stream on error
    );
  }
}
