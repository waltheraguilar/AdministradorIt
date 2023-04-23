import 'package:flutter/material.dart';
import 'package:itadministrador/utilities/dilogo_generica.dart';

Future<bool> showDeleteDialog(BuildContext context){
return showGenericDialog<bool>(
  context: context,
 title: 'Eliminar', 
 content: 'Esta Seguro de Eliminar este Item',
  optionBuilder: () => {
  'Cancel':false,
  'Yes' : true, 
  }, ).then((value) => value ?? false,
  );
}