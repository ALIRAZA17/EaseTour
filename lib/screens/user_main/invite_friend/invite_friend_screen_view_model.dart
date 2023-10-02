import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
}
