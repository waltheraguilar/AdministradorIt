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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itadministrador/responsive/login_mobile.dart';
import 'package:itadministrador/responsive/register_mobile.dart';
import 'package:itadministrador/responsive/verificar_email.dart';


import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Administrador IT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/':(context)=>const LoginView(),
        '/register/':(context)=>const RegisterView(),
        '/notas/':(context) => const VistaNotas(),



      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
             final user = FirebaseAuth.instance.currentUser;
             if(user != null){
                if (user.emailVerified) {
                return const VistaNotas();
                }else{
                       
                 return const VerifyEmailView();
           
                }
             }else{
                   return const LoginView();
             }
            
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}

class VistaNotas extends StatefulWidget {
  const VistaNotas({super.key});

  @override
  State<VistaNotas> createState() => _VistaNotasState();
}

enum MenuDeAccion { salir }

class _VistaNotasState extends State<VistaNotas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tus Equipos"),
      actions: [
        PopupMenuButton<MenuDeAccion> (
          onSelected: (value) async {
            switch (value) {
              case MenuDeAccion.salir:
                final deberiaSalir = await mostrarDialogoSalir(context);

                if (deberiaSalir) {
                  FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/', (route) => false);
                } 
                break;
              default:
            }
          },
        itemBuilder: (context){
          return const[
         PopupMenuItem<MenuDeAccion>
         (value: MenuDeAccion.salir,
          child: Text('Salir'),)
      ];},
        
        )
      ],
      ),
    body: const Text("Primera Nota"),

    );
  }
}


Future<bool> mostrarDialogoSalir(BuildContext context){
  return showDialog<bool>(
    context: context,
     builder: (context){
      return AlertDialog(
        title: const Text("Salir"),
        content: const Text("Esta seguro de salir"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, 
          child: const Text('Cancelar')),
          
          TextButton(onPressed: (){
             Navigator.of(context).pop(true);
          }, 
          child: const Text('Salir')),
          
        ],
      );
     },
     ).then((value) => value ?? false);
}