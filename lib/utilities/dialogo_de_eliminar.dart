import 'package:flutter/material.dart';
import 'package:itadministrador/utilities/dilogo_generica.dart';

Future<bool> showDeleteDialog(BuildContext context){
return showGenericDialog<bool>(
  context: context,
 title: 'Delete', 
 content: 'Are You Sure You Want To Delete this item?',
  optionBuilder: () => {
  'Cancel':false,
  'Yes' : true, 
  }, ).then((value) => value ?? false,
  );
}