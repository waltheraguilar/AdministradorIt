// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/servicios/autenticacion/auth_excepciones.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';
// ignore: unused_import

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
                         AuthServicio.firebase().crearUsuario(
                          email: email, password: password);
                        AuthServicio.firebase().enviarEmailDeVerificacion();
                       // Navigator.of(context).pushNamed(rutaVerificarEmail) ; 
                        } 
                        on ContrasenaDebilAuthExcepcion{
                            await mostraDialogoError(context, "Contraseña debil");
                        }
                        
                        on EmailYaEstaEnUsoAuthExcepcion {
                            await mostraDialogoError(context, "El email ya esta en uso");
                        }
                        

                        on EmailInvalidoExcepcion{
                          await mostraDialogoError(context, "El email es invalido");
                        }

                        on GenericaAuthExcepcion {
                          await mostraDialogoError(context, 'Error al registrar');
                        }
                        
                      },
                      child: const Text('Register'),
                    ),
                    TextButton(  onPressed:(){
                Navigator.of(context).pushNamedAndRemoveUntil(rutaLogin, (route) => false);
                }, child: const Text('Already Registeres? Login Here'))
                  ],
                ),
    );
  }
}