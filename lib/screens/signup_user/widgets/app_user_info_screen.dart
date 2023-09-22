import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ease_tour/common/resources/constants/styles.dart';
import 'package:ease_tour/common/widgets/appBar/app_bar.dart';
import 'package:ease_tour/common/widgets/button/app_text_button.dart';
import 'package:ease_tour/common/widgets/textFields/app_text_field.dart';
import 'package:ease_tour/models/appUser.dart';
import 'package:ease_tour/screens/role/providers/role_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/contact_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/email_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/gender_text_controller_provider.dart';
import 'package:ease_tour/screens/signup_user/providers/name_text_controller_provider.dart';
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
  bool isRegisterLoading = false; // Add this flag

  @override
  void initState() {
    super.initState();
    ref.read(contactTextControllerProvider).clear();
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

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final contactController = ref.watch(contactTextControllerProvider);

    final List<String> genderItems = [
      'Male',
      'Female',
    ];

    String? selectedValue;

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
                    isRegisterLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppTextButton(
                            text: "Register",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                final contactNumber = ref
                                    .read(contactTextControllerProvider)
                                    .text;
                                final gender =
                                    ref.read(genderProvider.notifier).state;
                                final email =
                                    ref.read(emailTextControllerProvider).text;

                                final name =
                                    ref.read(nameTextControllerProvider).text;

                                String role =
                                    ref.read(roleProvider.notifier).state;

                                if (role == "users") {
                                  final user = GoogleAppUser(
                                      contactNumber: contactNumber,
                                      gender: gender,
                                      email: email,
                                      name: name);
                                  saveUser(user, role);
                                } else {
                                  Get.toNamed('/transport_details');
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
