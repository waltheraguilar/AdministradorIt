/*
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/enums/menu_de_accion.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';
import 'package:itadministrador/servicios/autenticacion/crud/servicio_equipos.dart';

class VistaNotas extends StatefulWidget {
  const VistaNotas({super.key});

  @override
  State<VistaNotas> createState() => _VistaNotasState();
}



class _VistaNotasState extends State<VistaNotas> {
late final NotesService _notesService;
 String get userEmail => AuthServicio.firebase().currentUser!.email;

@override
void initState(){
  _notesService = NotesService();
  _notesService.open();
  super.initState();
}


@override
void dispose(){
  _notesService.close();
  super.dispose();
}

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
                 AuthServicio.firebase().logOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    rutaLogin, (route) => false);
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
}*/

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/enums/menu_de_accion.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';
import 'package:itadministrador/servicios/autenticacion/crud/servicio_equipos.dart';
import 'package:itadministrador/utilities/dialogo_logout.dart';
import 'package:itadministrador/views/lista_equipo.dart';


class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthServicio.firebase().currentUser!.email;

 @override
  void initState()  {
    _notesService = NotesService();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus Notas 😺'),
        actions: [
          IconButton(
            onPressed: (){Navigator.of(context).pushNamed(rutaCrearOEliminar);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuDeAccion>(
            onSelected: (value) async{
             switch (value) {
               case MenuDeAccion.logout:
                 final shouldlogout =await showLogOutDialog(context);
                 if(shouldlogout){
                    await AuthServicio.firebase().logOut(); 
                    Navigator.of(context).pushNamedAndRemoveUntil(rutaLogin
                    , (_) => false);
                 }
                 break;

               default:
             }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuDeAccion>(
                    value: MenuDeAccion.logout, child: Text('Log Out')),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot){
         switch (snapshot.connectionState) {
           case ConnectionState.done:
            return StreamBuilder(stream: _notesService.allNotes,
            builder: (context, snapshot){
              switch(snapshot.connectionState){                           
                case ConnectionState.waiting:
                case ConnectionState.active:
                 if(snapshot.hasData){
                    final allNotes = snapshot.data as List<DatabaseNote>;
                   return NotesListView(notes: allNotes,
                    onDeleteNote: (note) async{
                      await _notesService.deleteNote(id: note.id);
                    },
                    onTap: (note)  {
                     Navigator.of(context).pushNamed(
                      rutaCrearOEliminar
                     ,
                     arguments: note,);
                    },);
                 }else{
                  return const CircularProgressIndicator();
                 }
                default:
                  return const CircularProgressIndicator(); 
              }
            },
            );
            default:
            return const CircularProgressIndicator();
         }
        },
      ),
    );
  }
}