import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  Future<List<DocumentSnapshot>> fetchDocuments() async {
    final user = FirebaseAuth.instance.currentUser;
    final collection = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await collection.get();

    return querySnapshot.docs.where((doc) => doc.id != user?.uid).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final documents = snapshot.data;
            return ListView.builder(
              itemCount: documents?.length,
              itemBuilder: (context, index) {
                final documentData =
                    documents?[index].data() as Map<String, dynamic>;
                final fullName = documentData['full_name'] as String;
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 15,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Styles.primaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                            right: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Styles.borderColor, width: 3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fullName,
                                    style: Styles.displayXMxtrLightStyle
                                        .copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 46.11199951171875,
                                  height: 31.154996871948242,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Styles.checkContainerColor),
                                  child: Image.asset('assets/icons/tick2.png'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
