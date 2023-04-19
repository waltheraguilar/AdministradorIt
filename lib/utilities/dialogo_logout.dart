import 'package:flutter/material.dart';
import 'package:itadministrador/utilities/dilogo_generica.dart';



Future<bool> showLogOutDialog(BuildContext context){
return showGenericDialog<bool>(
  context: context,
 title: 'Salir de la Aplicacion', 
 content: 'Esta seguro de salir?',
  optionBuilder: () => {
  'Cancel':false,
  'Log Out' : true, 
  }, ).then((value) => value ?? false,
  );
}