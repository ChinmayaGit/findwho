import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/Pages/Lobby/components/lobby_components.dart';
import 'package:findwho/components/model/zone_solution_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ZoneSolutionController extends GetxController {
  Rx<ZoneSolutionModel?> zoneSolutionDoc = Rx<ZoneSolutionModel?>(null);
  RxBool isLoadingZoneSolutionController = RxBool(true);

  final DocumentReference<Map<String, dynamic>> zoneFetchDocSolution=FirebaseFirestore.instance.collection('zone').doc(invitationCode).collection('solution').doc('combinedSolution');

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Initialize zoneDocument with the current invitationCode
    fetchZoneSolutionDocument();
    subscribeToUpdates();
  }

  @override
  void onClose() {
    super.onClose();
  }
  Future<void> createZoneSolutionDocument() async {
    isLoadingZoneSolutionController.value = true;
    try {
      await zoneFetchDocSolution
          .set({
        "persons": [],
        "rooms": [],
        "weapons": [],
      });
    } catch (e) {
      print('Error : $e');
    } finally {
      isLoadingZoneSolutionController.value = false;
    }
  }

  Future<void> fetchZoneSolutionDocument() async {
    print("Checking Chinu 1");
    isLoadingZoneSolutionController.value = true;
    try {
      var snapshot = await zoneFetchDocSolution.get();
      if (snapshot.exists) {
        print("Checking Chinu 2");
        print(snapshot.exists);
        zoneSolutionDoc.value = ZoneSolutionModel.fromFirestore(snapshot);
        print(zoneSolutionDoc.value!.rooms?['name']);
        print("Checking Chinu 3");
      } else {
        print('Document does not exist in zone_solution_controller');
      }
    } catch (e) {
      print('Error fetching zone solution data: $e');
    } finally {
      isLoadingZoneSolutionController.value = false;
    }
  }

  Future<void> updateZoneSolutionDocument(Map<String, dynamic> updates) async {
    isLoadingZoneSolutionController.value = true;
    try {
      await zoneFetchDocSolution.update(updates);
      // Fetch the updated document to update the local state
      await fetchZoneSolutionDocument();
    } catch (e) {
      print('Error updating zone solution data: $e');
    } finally {
      isLoadingZoneSolutionController.value = false;
    }
  }

  void subscribeToUpdates() {
    zoneFetchDocSolution.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        zoneSolutionDoc.value = ZoneSolutionModel.fromFirestore(snapshot);
      } else {
        print('Document does not exist for updating zone_solution_controller');
      }
    });
  }
}