import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';

import 'package:itadministrador/utilities/obtener_argumentos.dart';

import 'package:itadministrador/servicios/cloud/firebase_cloud_storage.dart';

import '../servicios/cloud/cloud_note.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  late final TextEditingController _textControllerCodigo;


  late final String _textControllerFechaAdquisicion;
  late final String _textControllerFechaInstalacion;
  late final TextEditingController _textControllerInformacion;
  late final TextEditingController _textControllerModelo;
 
  late final TextEditingController _textControllerPasswordAdmin;

  late final TextEditingController _textControllerUbicacion;
  late final TextEditingController _textControllerUsuarioAdmin;

  // ignore: prefer_typing_uninitialized_variables
  var _selectedOption;

  final List<String> _options = [
    'Computadora',
    'Laptop',
    'Router',
    'Access Point',
    'Sonido',
    'Datashow',
    'Switch',
    'Otros'
  ];

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    _textControllerCodigo = TextEditingController();
    _textControllerModelo = TextEditingController();
    
    //  _textControllerFechaAdquisicion = String;
    //_textControllerFechaInstalacion = TextEditingController();
    _textControllerInformacion = TextEditingController();
  
    _textControllerPasswordAdmin = TextEditingController();
   
    _textControllerUbicacion = TextEditingController();
    _textControllerUsuarioAdmin = TextEditingController();

    super.initState();
  }

  void _textControllerListener() async {
    final equipo = _note;
    if (equipo == null) {
      return;
    }
    /*   aqui  */
    final text = _textController.text;
      
    final modelo = _textControllerModelo.text;
    final codigo = _textControllerCodigo.text;
    final usuarioAdmin = _textControllerUsuarioAdmin.text;
    final passwordAdmin = _textControllerPasswordAdmin.text;
    final ubicacion = _textControllerUbicacion.text;
    final seleccionEquipo = _selectedOption.toString();
    final  fechaAdquisicion = _textControllerFechaAdquisicion;
    final  fechaInstalacion = _textControllerFechaInstalacion;
    final informacion = _textControllerInformacion.toString();
    await _notesService.updateEquipos(
        documentId: equipo.documentId,
        nombreEquipo: text,
        modeloEquipo: modelo,
        codigoDelEquipo: codigo,
        usuarioAdministrado: usuarioAdmin,
        passwordAdministrador: passwordAdmin,
        descripcionDelEquipo: informacion,
         ubicacion: ubicacion,
         tipoEquipo: seleccionEquipo,
        fechaAdquisicion: fechaAdquisicion,
      
        informacionExtra: informacion,
         fechaInstalacion: fechaInstalacion,
       
        
        
       
        
        );
  }

  void _setupTextControlerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.nombreEquipo;
     _textControllerModelo.text = widgetNote.modeloEquipo;
     _textControllerCodigo.text = widgetNote.codigoDelEquipo;
     _textControllerUsuarioAdmin.text = widgetNote.usuarioAdministrador;
    _textControllerPasswordAdmin.text = widgetNote.passwordAdministrador;
    _textControllerUbicacion.text = widgetNote.ubicacion;
 //  _selectedOption = widgetNote.tipoEquipo;
   _textControllerFechaAdquisicion = widgetNote.fechaAdquisicion;
    _textControllerInformacion.text = widgetNote.informacionExtra;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthServicio.firebase().currentUser!;

    final userId = currentUser.id;
    final newNote = await _notesService.createNuevoEquipo(userId: userId);

    _note = newNote;

    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;

    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final equipo = _note;
    final text = _textController.text;
    final modelo = _textControllerModelo.text;
    final codigo = _textControllerCodigo.text;
    final usuarioAdmin = _textControllerUsuarioAdmin.text;
    final passwordAdmin = _textControllerPasswordAdmin.text;
    final ubicacion = _textControllerUbicacion.text;
    final seleccionEquipo = _selectedOption.toString();
    final  fechaAdquisicion = _textControllerFechaAdquisicion;
    final informacion = _textControllerInformacion.text;

    final fechaInstalacion = _textControllerFechaInstalacion;
    if (equipo != null && text.isNotEmpty) {
      await _notesService.updateEquipos(
          documentId: equipo.documentId,
          nombreEquipo: text,
          modeloEquipo: modelo,
          codigoDelEquipo: codigo,
          usuarioAdministrado: usuarioAdmin,
          passwordAdministrador: passwordAdmin,
            ubicacion: ubicacion,
            tipoEquipo: seleccionEquipo,
            fechaAdquisicion: fechaAdquisicion,
              informacionExtra: informacion,
                  fechaInstalacion:fechaInstalacion ,
          descripcionDelEquipo: informacion,
          
      
        
      
          
          
          
        
          );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Equipo 📳'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControlerListener();
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                 
                  child: Column(
                    
                    children: [
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Ingrese el nombre del equipo",
                        ),
                      ),
                      const SizedBox(
                        //Use of SizedBox
                        height: 16,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _textControllerModelo,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Ingrese el modelo del equipo",
                        ),
                      ),
                      const SizedBox(
                        //Use of SizedBox
                        height: 16,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _textControllerCodigo,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Ingrese el Codigo del equipo",
                        ),
                      ),
                      const SizedBox(
                        //Use of SizedBox
                        height: 16,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _textControllerUsuarioAdmin,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Ingrese el usuario administrador",
                        ),
                      ),
                      const SizedBox(
                        //Use of SizedBox
                        height: 16,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _textControllerPasswordAdmin,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Ingrese el password administrador",
                        ),
                      ),
                      const SizedBox(
                        //Use of SizedBox
                        height: 16,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _textControllerUbicacion,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Ingrese la ubicación actual del equipo",
                        ),
                      ),
                      const SizedBox(
                        //Use of SizedBox
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            const Text(
                              "Seleccione El tipo de equipo",
                              style: TextStyle(fontSize: 14),
                            ),
                            DropdownButton(
                              value: _selectedOption,
                              
                              items: _options.map((option) {
                                return DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                           
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            const Text("Seleccione la fecha de adquisición"),
                            DatePickerWidget(
                              onChange: (dateTime, selectedIndex) =>
                                  _textControllerFechaAdquisicion =
                                      dateTime.toString(),
                              initialDate: DateTime.now(),
                              //lastDate: DateTime.now().add(const Duration(days: -500)),
                              //firstDate: DateTime.now().add(const Duration(days: -(365 * 150))),
                              dateFormat: "dd-MM-yyyy",
                              locale: DatePicker.localeFromString("es"),
                              pickerTheme: DateTimePickerTheme(
                                  backgroundColor: Theme.of(context)
                                      .scaffoldBackgroundColor,
                                      dividerColor: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _textControllerInformacion,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText:
                                "Ingrese Informacion extra ",
                          ),
                        ),
                      ),


                    Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            const Text("Seleccione la fecha de Instalación"),
                            DatePickerWidget(
                              onChange: (dateTime, selectedIndex) =>
                                  _textControllerFechaInstalacion =
                                      dateTime.toString(),
                              initialDate: DateTime.now(),
                              //lastDate: DateTime.now().add(const Duration(days: -500)),
                              //firstDate: DateTime.now().add(const Duration(days: -(365 * 150))),
                              dateFormat: "dd-MM-yyyy",
                              locale: DatePicker.localeFromString("es"),
                              pickerTheme: DateTimePickerTheme(
                                  backgroundColor: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ],
                        ),
                      ),      

                    ],
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
