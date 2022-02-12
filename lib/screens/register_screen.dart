import 'package:ai_shopping_assistant/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:ai_shopping_assistant/widgets/myTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  bool obsecure = true;
  bool showSpinner = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              autovalidateMode: autovalidateMode,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        height: 200,
                        child: Image.asset('assets/images/logo.jpg'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextFormField(
                      text: 'Name',
                      validator: (value) {
                        return value == '' ? 'Please fill in the value' : null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextFormField(
                      keyboardType: TextInputType.number,
                      text: 'Age',
                      validator: (value) {
                        return value == ''
                            ? 'Please fill in the value'
                            : !ageRegex.hasMatch(value ?? '')
                                ? 'Please enter valid age'
                                : null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(ageRegex),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextFormField(
                      keyboardType: TextInputType.phone,
                      text: 'Phone Number',
                      validator: (value) {
                        return value == ''
                            ? 'Please fill in the value'
                            : value!.length < 10
                                ? 'Phone number must be at least 10 numbers'
                                : null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(phoneRegex),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextFormField(
                      keyboardType: TextInputType.emailAddress,
                      text: 'Email',
                      validator: (value) {
                        return value == ''
                            ? 'Please fill in the value'
                            : !emailRegex.hasMatch(value ?? '')
                                ? 'Please enter valid email format'
                                : null;
                      },
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: obsecure,
                      validator: (value) {
                        return value == ''
                            ? 'Please fill in the value'
                            : value!.length < 6
                                ? 'Please enter at least 6 characters'
                                : null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obsecure = !obsecure;
                            });
                            FocusScope.of(context).unfocus();
                          },
                          child: Icon(
                            obsecure ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: const UnderlineInputBorder(),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyOutlinedButton(
                      text: 'Register',
                      onPressed: () async {
                        autovalidateMode = AutovalidateMode.onUserInteraction;
                        setState(() {
                          showSpinner = true;
                        });
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);
                            Navigator.pushNamed(context, LoginScreen.id);
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(e.message ?? 'Error occured')),
                            );
                          }
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
