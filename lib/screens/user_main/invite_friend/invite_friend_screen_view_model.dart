import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class InviteFriendsViewModel extends BaseViewModel {
  TextEditingController textEditingController = TextEditingController();

  onBackPressed() {
    debugPrint('Back Pressed');
  }

  Future<List<DocumentSnapshot>> fetchDocuments() async {
    final user = FirebaseAuth.instance.currentUser;
    final collection = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await collection.get();

    return querySnapshot.docs.where((doc) => doc.id != user?.uid).toList();
  }

  void friendData(dynamic id) {
    updateCheckForInvite(id, FirebaseAuth.instance.currentUser!.uid);
    Get.back();
  }

  updateCheckForInvite(dynamic friendId, dynamic userId) async {
    final userLocationRef =
        FirebaseDatabase.instance.ref().child('/users/$friendId/invites');
    await userLocationRef.update({
      'requested_by': userId,
      'request_awaiting': true,
    });
  }
}
