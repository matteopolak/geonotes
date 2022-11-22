import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../notes/notes_controller.dart';
import '../utils/validate.dart';
import './register_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String? emailError;
  String? passwordError;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();

    super.dispose();
  }

  void authenticate(VoidCallback onSuccess) async {
    final formState = _formKey.currentState;

    if (formState == null || !formState.validate()) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      onSuccess.call();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          emailError = AppLocalizations.of(context)!.emailNotRegisteredError;
          passwordError = null;
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          passwordError = AppLocalizations.of(context)!.invalidPasswordError;
          emailError = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: emailController,
                  validator: (email) => email == null
                      ? null
                      : emailRegex.hasMatch(email)
                          ? null
                          : AppLocalizations.of(context)!.invalidEmailError,
                  decoration: InputDecoration(
                    errorText: emailError,
                    labelText: AppLocalizations.of(context)!.emailLabel,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 10, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  validator: (password) =>
                      password != null && password.isNotEmpty
                          ? null
                          : AppLocalizations.of(context)!.passwordEmptyError,
                  decoration: InputDecoration(
                    errorText: passwordError,
                    labelText: AppLocalizations.of(context)!.passwordLabel,
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
                    authenticate(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotesPage(),
                        ),
                      );
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.loginButtonLabel,
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()));
                },
                child: Text(AppLocalizations.of(context)!.newUserCreateAccount),
              )
            ],
          ),
        ),
      ),
    );
  }
}
