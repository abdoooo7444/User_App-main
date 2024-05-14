import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import "package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart";
import 'package:project_second/Pages/Login_Page.dart';
import 'package:project_second/helper/ShowSnackBar.dart';
import 'package:project_second/widgets/CustomConfirmPasswordTextField.dart';
import 'package:project_second/widgets/CustomMaterilButton.dart';
import 'package:project_second/widgets/CustomTextField.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  /////////////////////////////////////////////
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  bool isPasswordMatchesRules = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
       
        ),
        body:  
        Form(
          
          key: formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
            'Sign Up',
            style: TextStyle(
              fontFamily: "Newsreader",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 45,
            ),
          ),
                    const Text(
                      'User Name',
                      style: TextStyle(
                        fontFamily: "Newsreader",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextForm(
                      hinttext: 'Enter username',
                      mycontroller: userName,
                      icon: Icons.person_2_outlined,
                      obsecureTe: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: "Newsreader",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextForm(
                      hinttext: 'Enter email',
                      mycontroller: email,
                      icon: Icons.email,
                      obsecureTe: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: "Newsreader",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextForm(
                      hinttext: 'Enter password',
                      mycontroller: password,
                      icon: Icons.lock,
                      obsecureTe: isPasswordHidden,
                      iconButton: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                        icon: !isPasswordHidden
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    FlutterPwValidator(
                      width: 400,
                      height: 140,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      specialCharCount: 1,
                      numericCharCount: 2,
                      onSuccess: () {
                        isPasswordMatchesRules = true;
                      },
                      onFail: () {
                        isPasswordMatchesRules = false;
                      },
                      controller: password,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontFamily: "Newsreader",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomConfirmationPasswordTextForm(
                      confirmPassword: password.text,
                      hinttext: 'Enter Password Again',
                      mycontroller: confirmPassword,
                      icon: Icons.lock,
                      obsecureTe: isConfirmPasswordHidden,
                      iconButton: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordHidden = !isConfirmPasswordHidden;
                          });
                        },
                        icon: !isConfirmPasswordHidden
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                        child: CustomButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (!isPasswordMatchesRules) {
                            ShowSnackBar(context, " U should follow the rules");
                            return;
                          }
                          setState(() {
                            isLoading = false;
                          });
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );

                            FirebaseAuth.instance.currentUser!
                                .sendEmailVerification();
                            CollectionReference collRef = FirebaseFirestore
                                .instance
                                .collection('userAccount');
                            collRef.add({
                              'mail': email.text,
                              'userName': userName.text,
                              'password': password.text,
                            });
                            navMehod(context);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ShowSnackBar(context,
                                  "The password provided is too weak.");
                            } else if (e.code == 'email-already-in-use') {
                              ShowSnackBar(context, "Email already exsists");
                            }
                          } catch (e) {
                            print(e);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          ' Already have an account ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Newsreader",
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'LogIn',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[300],
                                fontFamily: "Newsreader",
                                fontSize: 16),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const LoginPage();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navMehod(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, "LoginPage", (route) => false);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return const LoginPage();
    // }));
  }
}
