// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/servicios/autenticacion/auth_excepciones.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';
import 'package:itadministrador/utilities/dialogo_de_errores.dart';


class LoginVista extends StatefulWidget {
  const LoginVista({Key? key}) : super(key: key);

  @override
  State<LoginVista> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginVista> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
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
        title: const Padding(
          padding: const EdgeInsets.all( 12.0),
          child: const Text('Bienvenido'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
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
                  await AuthServicio.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthServicio.firebase().currentUser;

            
                  if (user?.isEmailVerified ?? false) {
          
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(rutaNotas, (route) => false);
                  } else {
//not verify
                  }
                  // ignore: use_build_context_synchronously

                } on UsuarioAuthNoEcontrado {
                  await mostraDialogoError(
                    context,
                    'Usuario No Encontrados',
                  );
                } on MalaContrasenaAuthException{
                    await mostraDialogoError(
                      context,
                      'Credenciales Invalidas',
                    );
                } on GenericaAuthExcepcion{
                     await mostraDialogoError(
                    context,
                  'Algo algo salio ;(',
                  );
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
      ),
    );
  }
}