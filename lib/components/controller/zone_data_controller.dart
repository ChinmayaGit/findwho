import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/components/model/zone_data_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneDataController extends GetxController {
  Rx<ZoneDataModel?> zoneDataDoc = Rx<ZoneDataModel?>(null);
  var ZoneDataDataCollection = <ZoneDataModel>[].obs;
  RxBool isLoadingZoneDataController = RxBool(true);

  final DocumentReference<Map<String, dynamic>> zoneFetchDocData=FirebaseFirestore.instance.collection('zone').doc(invitationCode).collection('data').doc('combinedData');

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Initialize zoneDocument with the current invitationCode
    fetchZoneDataDocument();
    subscribeToUpdates();
  }

  @override
  void onClose() {
    super.onClose();
  }
  Future<void> createZoneDataDocument() async {
    isLoadingZoneDataController.value = true;
    try {
      await zoneFetchDocData
          .set({
        "persons": [],
        "rooms": [],
        "weapons": [],
      });
    } catch (e) {
      print('Error : $e');
    } finally {
      isLoadingZoneDataController.value = false;
    }
  }

  Future<void> fetchZoneDataDocument() async {
    isLoadingZoneDataController.value = true;
    try {
      var snapshot = await zoneFetchDocData.get();
      if (snapshot.exists) {
        zoneDataDoc.value = ZoneDataModel.fromFirestore(snapshot);
      } else {
        print('Document does not exist in zone_data_controller');
      }
    } catch (e) {
      print('Error fetching zone data: $e');
    } finally {
      isLoadingZoneDataController.value = false;
    }
  }

  // Future<void> updateZoneDataDocument(Map<String, dynamic> updates) async {
  //   isLoadingZoneDataController.value = true;
  //   try {
  //     await zoneFetchDocData.update(updates);
  //     // Fetch the updated document to update the local state
  //     await fetchZoneDataDocument();
  //   } catch (e) {
  //     print('Error updating zone Data data: $e');
  //   } finally {
  //     isLoadingZoneDataController.value = false;
  //   }
  // }
  Future<void> updateZoneDataDocument(int index, bool newState, String name) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await zoneFetchDocData.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        List<dynamic> weapons = data[name];

        // Check if the index is within the bounds of the array
        if (index >= 0 && index < weapons.length) {
          // Update the specific element
          weapons[index]['state'] = true;

          // Write the updated array back to Firestore
          await zoneFetchDocData.update({name: weapons});
          print('Updated weapons: $weapons');
          print('New state: $newState');
        } else {
          print('Index out of bounds');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating weapon state: $e');
    }
  }
  void subscribeToUpdates() {
    zoneFetchDocData.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        zoneDataDoc.value = ZoneDataModel.fromFirestore(snapshot);
      } else {
        print('Document does not exist for updating zone_data_controller');
      }
    });
  }
}