// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/servicios/autenticacion/auth_excepciones.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';
import 'package:itadministrador/utilities/dialogo_de_errores.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Ingresa Tu Correo",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Ingresa Tu Contraseña",
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
               AuthServicio.firebase().logIn(
                  email: email, password: password);
                  final user = AuthServicio.firebase().currentUser;
                  if(user?.isEmailVerified ?? false){
                     Navigator.of(context).pushNamedAndRemoveUntil(
                  rutaNotas,
                  (route) => false,
                );
                  } else {
                     await mostraDialogoError(context, 'Error de Autenticacion');
                  }
            
               
              } 
              on UsuarioAuthNoEcontrado{
                 await mostraDialogoError(context, 'Usuario no encontrado');
              }

              on MalaContrasenaAuthException{
                 await mostraDialogoError(context, 'Credenciales Incorrectas');
              }

              on GenericaAuthExcepcion {
                   await mostraDialogoError(context, 'Error de Autenticacion');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(rutaRegistrar, (route) => false);
            },
            child: const Text("Registrar"),
          ),
        ],
      ),
    );
  }
}


