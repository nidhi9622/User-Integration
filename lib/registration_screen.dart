import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class RegistrationScreen extends StatefulWidget {
  Map object;
  String buttonText;

  RegistrationScreen({Key? key, required this.object, required this.buttonText})
      : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  dynamic datePicked;
  dynamic selectedDate;

  @override
  void initState() {
    checkData();
    super.initState();
  }

  checkData() async {
    if (widget.object.isNotEmpty) {
      nameController.text = widget.object['name'];
      emailController.text = widget.object['email'];
      dateController.text = widget.object['dob'];
      selectedDate = widget.object['dob'];
      passwordController.text = widget.object['password'];
      confirmPasswordController.text = widget.object['confirmPassword'] ?? "";
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("database")) {
      String? newList = preferences.getString('database');
      list = jsonDecode(newList!);
    } else {
      list = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(
                    color: Color(0xff87CEEB),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: nameController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter Your Name",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter your E-mail address';
                            }
                            if (widget.buttonText == "Register") {
                              for (int i = 0; i < list.length; i++) {
                                if (list[i]['email'] ==
                                    emailController.text.trim()) {
                                  return "Email already exist";
                                }
                              }
                            }
                            String pattern = r'\w+@\w+\.\w+';
                            if (!RegExp(pattern).hasMatch(value)) {
                              return 'Invalid E-mail format';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter Your Email",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            _selectDate();
                          },
                          controller: dateController,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter your DOB';
                            }
                            var birthDate =
                                DateFormat("dd/MM/yyyy").parse(selectedDate);
                            var today = DateTime.now();
                            final difference =
                                today.difference(birthDate).inDays;
                            final year = difference / 365;
                            if (year < 18) {
                              return "Age must be 18";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Date of Birth",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: !_passwordVisible,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText: !_confirmPasswordVisible,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter Confirm Password';
                            } else if (passwordController.text.trim() !=
                                confirmPasswordController.text.trim()) {
                              return 'Password should match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Confirm Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                list.removeWhere((item) =>
                                    item['email'] == widget.object['email']);
                              });
                              list.add({
                                "name": nameController.text.trim(),
                                "email": emailController.text.trim(),
                                "dob": dateController.text.trim(),
                                "password": passwordController.text.trim(),
                                "confirmPassword":
                                    confirmPasswordController.text.trim()
                              });
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.setString(
                                  'database', jsonEncode(list));
                              setState(() {
                                selectedIndex = 2;
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TabBarWidget(
                                        object: {},
                                        buttonText: 'Register',
                                      )));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                widget.buttonText,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  _selectDate() async {
    datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1947, 8),
        lastDate: DateTime(2101));

    if (datePicked != null && datePicked != selectedDate) {
      setState(() {
        selectedDate = DateFormat("dd/MM/yyyy").format(datePicked);
        dateController.text = selectedDate;
      });
    }
  }
}
