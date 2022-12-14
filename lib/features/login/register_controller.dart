import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../notes/notes_controller.dart';
import '../utils/validate.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  String? emailError;
  String? passwordError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final retypePasswordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();

    super.dispose();
  }

  void register(VoidCallback onSuccess) async {
    final formState = _formKey.currentState;

    if (formState == null || !formState.validate()) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      if (userCredential.user == null) {
        return setState(() {
          emailError = AppLocalizations.of(context)!.unknownError;
          passwordError = null;
        });
      }

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users.doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'uid': userCredential.user!.uid
      });

      onSuccess.call();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          passwordError = AppLocalizations.of(context)!.passwordWeaknessError;
          emailError = null;
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          emailError = AppLocalizations.of(context)!.emailInUseError;
          passwordError = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registerPageTitle),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                      child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ))),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: emailController,
                  validator: (email) => email == null
                      ? null
                      : emailRegex.hasMatch(email)
                          ? null
                          : 'Invalid email address',
                  decoration: InputDecoration(
                      errorText: emailError,
                      labelText: AppLocalizations.of(context)!.emailLabel),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 10, bottom: 0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  validator: (password) =>
                      password != null && password.isNotEmpty
                          ? null
                          : AppLocalizations.of(context)!.passwordEmptyError,
                  decoration: InputDecoration(
                      errorText: passwordError,
                      labelText: AppLocalizations.of(context)!.passwordLabel),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 10, bottom: 0),
                child: TextFormField(
                  obscureText: true,
                  controller: retypePasswordController,
                  validator: (password) => password == passwordController.text
                      ? null
                      : AppLocalizations.of(context)!.passwordMatchError,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.retypePasswordLabel,
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    register(
                      () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotesPage(),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.registerLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
