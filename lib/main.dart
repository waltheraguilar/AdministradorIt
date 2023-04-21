/*
import 'package:flutter/material.dart';
import 'package:itadministrador/responsive/responsive.dart';

import 'responsive/desktop_scaffold.dart';
import 'responsive/mobile_scaffold.dart';
import 'responsive/tablet_scaffold.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

 @override

 Widget build(BuildContext context){
  return  MaterialApp(
    debugShowCheckedModeBanner: false,
    home:ResponsiveLayout(
      desktopScaffold: const DesktopScaffold(),
       mobileScaffold: const MobileScaffold(),
        tabletScaffold: const TabletScaffold()
        ),
  );
 }
 

}*/



import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/responsive/login_mobile.dart';
import 'package:itadministrador/responsive/register_mobile.dart';
import 'package:itadministrador/responsive/verificar_email.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';
import 'package:itadministrador/views/crear_actualizar.dart';
import 'package:itadministrador/views/login_general.dart';
import 'package:itadministrador/views/vista_equipo.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        rutaLogin: (context) => const LoginVista(),
        rutaRegistrar: (context) => const RegisterView(),
        rutaNotas: (context) => const NotesView(),
      //  rutaVerificarEmail:(context) => const VerifyEmailView(),
        rutaCrearOEliminar:(context)=> const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthServicio.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthServicio.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
            
                return const NotesView();
              } else {
                return const NotesView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

