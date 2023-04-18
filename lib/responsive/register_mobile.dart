// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
// ignore: unused_import
import 'package:itadministrador/firebase_options.dart';
import 'package:itadministrador/utilities/dialogo_de_errores.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'),),
      body: Column(
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Ingresa Tu Correo",
                      ),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: "Ingresa Tu Contraseña",
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                         await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                        final user = FirebaseAuth.instance.currentUser;
                        user?.sendEmailVerification();
                        Navigator.of(context).pushNamed(rutaVerificarEmail) ; 
                        } on FirebaseAuthException catch (e) {
                         if (e.code=='weak-password') {
                           await mostraDialogoError(context, "Contraseña debil");
                         } else if(e.code=='email-already-in-use'){
                           await mostraDialogoError(context, "El email ya esta en uso");
                         }else if(e.code=='invalid-email'){
                            await mostraDialogoError(context, "El email es invalido");
                         } else {
                          await mostraDialogoError(context, 'Error:${e.code}');
                         }
                        } catch (e){
                          await mostraDialogoError(context, e.toString());
                        }
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(  onPressed:(){
                Navigator.of(context).pushNamedAndRemoveUntil(rutaRegistrar, (route) => false);
                }, child: const Text('Already Registeres? Login Here'))
                  ],
                ),
    );
  }
}