// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/servicios/autenticacion/auth_proveedor.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificacion de email'),),
      body: Column(
          children: [
            const Text("le hemos enviando un correo de verificacion de email. Por favor verifique su email"),
            const Text("Si no ha recibido el email, presione el boton inferior"),
          TextButton(onPressed:() {
          
          AuthServicio.firebase().enviarEmailDeVerificacion();

    
          }, child: const Text("Volver a enviar email de verificacion"),
          
          
          ),

          TextButton(onPressed: () async{

            await AuthServicio.firebase().logOut();
           

          Navigator.of(context).restorablePushNamedAndRemoveUntil(rutaRegistrar,
            (route) => false);
          }, child: const Text('Restart')
          ),
          ],
    
        ),
    );
  }
}