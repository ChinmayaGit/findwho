import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findwho/Pages/Auth/auth_check.dart';
import 'package:findwho/Pages/Auth/components/user_data_model.dart';
import 'package:get/get.dart';

import '../../Lobby/components/lobby_components.dart';

class UserController extends GetxController {
  Rx<UserDataModel?> userDataDocument = Rx<UserDataModel?>(null); // Rx variable for user data
  RxBool isLoadingUserConroller = RxBool(true); // Loading state

  final DocumentReference<Map<String, dynamic>> userDocument =
  FirebaseFirestore.instance.collection('users').doc(authUid);

  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _subscription;

  @override
  void onInit() {
    super.onInit();
    fetchUserDocument(); // Fetch initial user data when controller is initialized
    subscribeToUpdates(); // Subscribe to real-time updates
  }

  @override
  void onClose() {
    super.onClose();
    _subscription.cancel(); // Cancel subscription when controller is disposed
  }

  Future<void> fetchUserDocument() async {

    isLoadingUserConroller.value = true; // Set loading to true before fetching
    try {
      var snapshot = await userDocument.get();
      if (snapshot.exists) {
        // Convert snapshot data to UserData object
        var userData = UserDataModel.fromFirestore(snapshot);

        // Update userData observable
        this.userDataDocument.value = userData;
        invitationCode=userDataDocument.value!.inviteId;// Update Rx variable
      } else {
        // Document doesn't exist
        print('Document does not exist user_data_controller');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle error as needed
    } finally {
      isLoadingUserConroller.value = false; // Set loading to false after fetching
    }
  }
  Future<void> updateUserDocument(Map<String, dynamic> updates) async {
    isLoadingUserConroller.value = true; // Set loading to true before updating
    try {
      await userDocument.update(updates);
      // Fetch the updated document to update the local state
      await fetchUserDocument();
    } catch (e) {
      print('Error updating user data: $e');
      // Handle error as needed
    } finally {
      isLoadingUserConroller.value = false; // Set loading to false after updating
    }
  }
  void subscribeToUpdates() {
    _subscription = userDocument.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        // Convert snapshot data to UserData object
        var userData = UserDataModel.fromFirestore(snapshot);

        // Update userData observable
        this.userDataDocument.value = userData; // Update Rx variable
      } else {
        // Document doesn't exist
        print('Document does not exist for updating user_data_controller');
      }
    });
  }
}