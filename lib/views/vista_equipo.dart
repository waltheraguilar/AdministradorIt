
import 'package:flutter/material.dart';
import 'package:itadministrador/constantes/rutas.dart';
import 'package:itadministrador/enums/menu_de_accion.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';

class VistaNotas extends StatefulWidget {
  const VistaNotas({super.key});

  @override
  State<VistaNotas> createState() => _VistaNotasState();
}



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
}