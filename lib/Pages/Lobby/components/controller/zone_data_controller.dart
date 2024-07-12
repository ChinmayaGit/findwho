import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/Pages/Lobby/components/model/zone_data_model.dart';
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
        "persons": {},
        "rooms": {},
        "weapons": {},
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

  Future<void> updateZoneDataDocument(Map<String, dynamic> updates) async {
    isLoadingZoneDataController.value = true;
    try {
      await zoneFetchDocData.update(updates);
      // Fetch the updated document to update the local state
      await fetchZoneDataDocument();
    } catch (e) {
      print('Error updating zone data: $e');
    } finally {
      isLoadingZoneDataController.value = false;
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