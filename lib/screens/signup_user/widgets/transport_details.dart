import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/models/appDriver.dart';
import 'package:ease_tour/screens/role/providers/role_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/cnic_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/contact_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/email_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/gender_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/license_number_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/name_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/password_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/vehicle_name_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/vehicle_number_plate_text_contoller_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class TransportDetails extends ConsumerStatefulWidget {
  const TransportDetails({super.key});

  @override
  ConsumerState<TransportDetails> createState() => _TransportDetailsState();
}

class _TransportDetailsState extends ConsumerState<TransportDetails> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ref.read(vehicleNameTextControllerProvider).clear();
    ref.read(vehicleNumberPlateTextControllerProvider).clear();
  }

  Future<User?> saveDriver(AppDriver driver) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: driver.email, password: driver.password);

      String role = ref.read(roleProvider.notifier).state;

      CollectionReference drivers = FirebaseFirestore.instance.collection(role);

      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userRef = drivers.doc(uid);

      userRef
          .set({
            'full_name': driver.name,
            'email': driver.email,
            'password': driver.password,
            'contact': driver.contactNumber,
            'gender': driver.gender,
            'cnic': driver.cnic,
            'licenseNo': driver.licenseNumber,
            'vehicleName': driver.vehicleName,
            'vehicalNumber': driver.vehicleNumberPlate,
          })
          .then((value) => Get.snackbar(
              "Driver Added", "Driver has been added successfully!"))
          .catchError(
            (error) => Get.snackbar("Process Failed", "Error: $error"),
          );

      Get.toNamed('/login');
      return credential.user;
    } catch (e) {
      Get.snackbar("Process Failed", "Error: $e");
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final vehicleNameController = ref.watch(vehicleNameTextControllerProvider);
    final vehicleNumberPlateController =
        ref.watch(vehicleNumberPlateTextControllerProvider);
    return Scaffold(
        appBar: const EtAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          "Transport Detials",
                          style: Styles.displayLargeNormalStyle.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              label: "Enter your Vehicle Name",
                              keyboardType: TextInputType.text,
                              controller: vehicleNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter vehicle name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppTextField(
                              label: "Enter your vehicle number",
                              keyboardType: TextInputType.text,
                              controller: vehicleNumberPlateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter vehicle number";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 5,
                child: AppTextButton(
                  color: Styles.buttonColorPrimary,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      final contactNumber =
                          ref.read(contactTextControllerProvider).text;
                      final gender = ref.read(genderProvider.notifier).state;
                      final email = ref.read(emailTextControllerProvider).text;
                      final password =
                          ref.read(passswordTextControllerProvider).text;
                      final name = ref.read(nameTextControllerProvider).text;
                      final cnic = ref.read(cnicTextControllerProvider).text;
                      final licenseNo =
                          ref.read(licenseNumberTextControllerProvider).text;
                      final vehicleName =
                          ref.read(vehicleNameTextControllerProvider).text;
                      final vehicleNumberlate = ref
                          .read(vehicleNumberPlateTextControllerProvider)
                          .text;

                      final driver = AppDriver(
                        contactNumber: contactNumber,
                        gender: gender,
                        email: email,
                        password: password,
                        name: name,
                        cnic: cnic,
                        licenseNumber: licenseNo,
                        vehicleName: vehicleName,
                        vehicleNumberPlate: vehicleNumberlate,
                      );
                      saveDriver(driver);
                    }
                  },
                  text: "Save",
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
