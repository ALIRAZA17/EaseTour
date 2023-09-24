import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/models/appDriver.dart';
import 'package:ease_tour/models/appUser.dart';
import 'package:ease_tour/screens/role/providers/role_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/cnic_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/contact_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/email_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/gender_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/license_number_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/name_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/vehicle_name_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/vehicle_number_plate_text_contoller_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class AppUserInfoScreen extends ConsumerStatefulWidget {
  const AppUserInfoScreen({super.key});

  @override
  ConsumerState<AppUserInfoScreen> createState() => _AppUserInfoScreenState();
}

class _AppUserInfoScreenState extends ConsumerState<AppUserInfoScreen> {
  final formKey = GlobalKey<FormState>();
  bool isRegisterLoading = false;

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    ref.read(contactTextControllerProvider).clear();
    ref.read(vehicleNameTextControllerProvider).clear();
    ref.read(vehicleNumberPlateTextControllerProvider).clear();
  }

  void saveUser(GoogleAppUser user, String role) async {
    try {
      setState(() {
        isRegisterLoading = true;
      });

      CollectionReference users = FirebaseFirestore.instance.collection(role);

      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userRef = users.doc(uid);

      userRef
          .set({
            'full_name': user.name,
            'email': user.email,
            'contact': user.contactNumber,
            'gender': user.gender,
          })
          .then((value) =>
              Get.snackbar("User Added", "User has been added successfully!"))
          .catchError(
            (error) => Get.snackbar("Process Failed", "Error: $error"),
          );
    } catch (e) {
      Get.snackbar("Process Failed", "Error: $e");
    } finally {
      Get.toNamed("/onBoarding/primary");
      setState(() {
        isRegisterLoading = false;
      });
    }
  }

  void saveDriver(GoogleAppDriver driver, String role) async {
    try {
      setState(() {
        isRegisterLoading = true;
      });

      CollectionReference users = FirebaseFirestore.instance.collection(role);

      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userRef = users.doc(uid);

      userRef
          .set({
            'full_name': driver.name,
            'email': driver.email,
            'contact': driver.contactNumber,
            'gender': driver.gender,
            'cnic': driver.cnic,
            'licenseNo': driver.licenseNumber,
            'vehicleName': driver.vehicleName,
            'vehicalNumber': driver.vehicleNumberPlate,
          })
          .then((value) =>
              Get.snackbar("User Added", "User has been added successfully!"))
          .catchError(
            (error) => Get.snackbar("Process Failed", "Error: $error"),
          );
    } catch (e) {
      Get.snackbar("Process Failed", "Error: $e");
    } finally {
      Get.toNamed("/onBoarding/primary");
      setState(() {
        isRegisterLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactController = ref.watch(contactTextControllerProvider);
    String role = ref.read(roleProvider.notifier).state;
    final vehicleNameController = ref.watch(vehicleNameTextControllerProvider);
    final vehicleNumberPlateController =
        ref.watch(vehicleNumberPlateTextControllerProvider);
    final cnicController = ref.watch(cnicTextControllerProvider);
    final licenseNoController = ref.watch(licenseNumberTextControllerProvider);
    final email = ref.watch(emailTextControllerProvider).text;

    final name = ref.watch(nameTextControllerProvider).text;

    final List<String> genderItems = [
      'Male',
      'Female',
    ];

    return Scaffold(
      appBar: const EtAppBar(
        height: 90,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "Please fill out this information to complete your sign up",
                style: Styles.displayLargeNormalStyle.copyWith(
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: "Mobile Number",
                      keyboardType: TextInputType.text,
                      controller: contactController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mobile Number is required';
                        } else if (!RegExp(
                                r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}')
                            .hasMatch(
                          value,
                        )) {
                          return "Enter valid mobile number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField2<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text(
                        'Select Your Gender',
                        style: TextStyle(fontSize: 14),
                      ),
                      items: genderItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select gender.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        selectedValue = value;
                        ref.read(genderProvider.notifier).state =
                            selectedValue ?? "Male";
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 24,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: role == "drivers",
                      child: Column(
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
                          AppTextField(
                            label: "Cnic",
                            keyboardType: TextInputType.text,
                            controller: cnicController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Cnic';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            label: "License No.",
                            keyboardType: TextInputType.text,
                            controller: licenseNoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter license no';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isRegisterLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppTextButton(
                            text: "Register",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                final gender =
                                    ref.read(genderProvider.notifier).state;
                                if (role == "users") {
                                  final user = GoogleAppUser(
                                    contactNumber: contactController.text,
                                    gender: gender,
                                    email: email,
                                    name: name,
                                  );
                                  saveUser(user, role);
                                } else {
                                  final driver = GoogleAppDriver(
                                    contactNumber: contactController.text,
                                    gender: gender,
                                    cnic: cnicController.text,
                                    licenseNumber: licenseNoController.text,
                                    vehicleName: vehicleNameController.text,
                                    vehicleNumberPlate:
                                        vehicleNumberPlateController.text,
                                    email: email,
                                    name: name,
                                  );
                                  saveDriver(driver, role);
                                }
                              }
                            },
                            color: Styles.buttonColorPrimary,
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
