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

import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/enums/menu_de_accion.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';

import 'package:itadministrador/servicios/cloud/cloud_note.dart';
import 'package:itadministrador/servicios/cloud/firebase_cloud_storage.dart';
import 'package:itadministrador/utilities/dialogo_logout.dart';
import 'package:itadministrador/views/lista_equipo.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;

  late final TextEditingController buscarController;
  String get userId => AuthServicio.firebase().currentUser!.id;

  @override
  void initState() {
    buscarController = TextEditingController();
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tus Equipos 👨‍💻💻'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(rutaCrearOEliminar);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuDeAccion>(
              onSelected: (value) async {
                switch (value) {
                  case MenuDeAccion.logout:
                    final shouldlogout = await showLogOutDialog(context);
                    if (shouldlogout) {
                      await AuthServicio.firebase().logOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(rutaLogin, (_) => false);
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: buscarController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: const InputDecoration(hintText: "Buscar"),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _notesService.todosEquiposFiltrador(
                    userId: userId, text: buscarController.text),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as Iterable<CloudNote>;
                        return NotesListView(
                          notes: allNotes,
                          onDeleteNote: (note) async {
                            await _notesService.deleteNote(
                                documentId: note.documentId);
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              rutaCrearOEliminar,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              ),
            )
          ],
        ));
  }
}

class Row extends StatelessWidget {
  final FirebaseCloudStorage notesService;
  String get userId => AuthServicio.firebase().currentUser!.id;
  const Row({super.key, required this.notesService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: notesService.todosEquipos(userId: userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allNotes = snapshot.data as Iterable<CloudNote>;
              return NotesListView(
                notes: allNotes,
                onDeleteNote: (note) async {
                  await notesService.deleteNote(documentId: note.documentId);
                },
                onTap: (note) {
                  Navigator.of(context).pushNamed(
                    rutaCrearOEliminar,
                    arguments: note,
                  );
                },
              );
            } else {
              return Column(
                children: [
                  const SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 10,
                       value: 50,
                    ),
                  ),
                ],
              );
            }
          default:
            return const SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 20,
                value: 50,
              ),
            );
        }
      },
    );
  }
}
