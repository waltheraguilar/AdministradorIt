import 'package:flutter/material.dart';

import 'package:itadministrador/servicios/cloud/cloud_note.dart';
import 'package:itadministrador/utilities/dialogo_de_eliminar.dart';


typedef NoteCallback = void Function(CloudNote note);
class NotesListView extends StatelessWidget {

  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote; 

  final NoteCallback onTap;
  const NotesListView({Key? key, required this.notes, 
  required this.onDeleteNote,
  required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                      

                      itemCount: notes.length,
                      itemBuilder: (context, index){
                        final note = notes.elementAt(index);
                         return ListTile(
                          onTap: () {
                            onTap(note);
                          },
                          
                         title:Text(
                           note.nombreEquipo ,
                         
                           maxLines: 10,
                           softWrap: true,
                           overflow: TextOverflow.ellipsis,
                         ),
                         subtitle: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(
                            note.modeloEquipo,
                            
                           ),
                         ),

                         trailing: IconButton(
                          onPressed: () async{
                            final shouldDelete = await showDeleteDialog(context);
                            if(shouldDelete){
                                 onDeleteNote(note);   
                            }
                          },
                           icon: const Icon(Icons.delete),
                         ) ,
                        
                         );
                      },
                    );
  }
}