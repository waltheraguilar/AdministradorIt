import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:itadministrador/servicios/autenticacion/auth_servicio.dart';
import 'package:itadministrador/utilities/no_se_puedecompartir.dart';

import 'package:itadministrador/utilities/obtener_argumentos.dart';

import 'package:itadministrador/servicios/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

import '../servicios/cloud/cloud_note.dart';

String? _selectedOption = '';
final List<String> _options = [
  'Computadora',
  'Laptop',
  'Router',
  'Access Point',
  'Sonido',
  'Datashow',
  'Switch',
  'Celular',
  'Otros',
  ''
];
bool? _value = false;
String solucion = "";
DateTime _textControllerFechaAdquisicion = DateTime.now();
DateTime _textControllerFechaInstalacion = DateTime.now();

late DateTime? fechaNuvea;
late DateTime? fechaNuevaBien;

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

  late final TextEditingController _textControllerInformacion;
  late final TextEditingController _textControllerModelo;

  late final TextEditingController _textControllerPasswordAdmin;

  late final TextEditingController _textControllerUbicacion;
  late final TextEditingController _textControllerUsuarioAdmin;

  // ignore: prefer_typing_uninitialized_variables

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
    final fechaAdquisicion = _textControllerFechaAdquisicion;
    final fechaInstalacion = _textControllerFechaInstalacion;
    final informacion = _textControllerInformacion.toString();
    await _notesService.updateEquipos(
      documentId: equipo.documentId,
      nombreEquipo: text,
      modeloEquipo: modelo,
      codigoDelEquipo: codigo,
      usuarioAdministrado: usuarioAdmin,
      passwordAdministrador: passwordAdmin,
      descripcionDelEquipo: solucion,
      ubicacion: ubicacion,
      tipoEquipo: seleccionEquipo,
      fechaAdquisicion: fechaAdquisicion.toString(),
      informacionExtra: informacion,
      fechaInstalacion: fechaInstalacion.toString(),
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
      _selectedOption = widgetNote.tipoEquipo;
      _textControllerFechaAdquisicion =
          DateTime.parse(widgetNote.fechaAdquisicion);
      _textControllerFechaInstalacion =
          DateTime.parse(widgetNote.fechaInstalacion);

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
    final fechaAdquisicion = _textControllerFechaAdquisicion;
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
        fechaAdquisicion: fechaAdquisicion.toString(),
        informacionExtra: informacion,
        fechaInstalacion: fechaInstalacion.toString(),
        descripcionDelEquipo: solucion,
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
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textController.text;
                final modelo = _textControllerModelo.text;
                final codigo = _textControllerCodigo.text;
                final usuarioAdmin = _textControllerUsuarioAdmin.text;
                final passwordAdmin = _textControllerPasswordAdmin.text;
                final ubicacion = _textControllerUbicacion.text;
                final seleccionEquipo = _selectedOption.toString();
                final fechaAdquisicion = _textControllerFechaAdquisicion;
                final informacion = _textControllerInformacion.text;
                 final fechaInstalacion = _textControllerFechaInstalacion;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share("Informacion del equipos *$text*  \n modelo : $modelo \n codigo : $codigo \n usuario administrador : $usuarioAdmin \n contraseña administrador : $passwordAdmin \n ubicación : $ubicacion \n tipo de equipo : $seleccionEquipo \n fecha de adquisión : $fechaAdquisicion \n información extra: $informacion \n fecha de instalación : $fechaInstalacion");
                }
              },
              icon: const Icon(Icons.share))
        ],
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
                      const Text(
                        "Nombre del equipo",
                        textAlign: TextAlign.left,
                      ),
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
                      const Text("Modelo del equipo"),
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
                      const Text("Codigo del equipo"),
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
                      const Text("Usuario Administrador"),
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
                      const Text("Password Administrador"),
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
                      const Text("Ubicacion del equipo"),
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
                          children: const [
                            Text(
                              "Seleccione El tipo de equipo",
                              style: TextStyle(fontSize: 14),
                            ),
                            DropDownMasiso(),
                          ],
                        ),
                      ),
                      FeachaAdquisicionMasiso(),
                      const Text("Agregue información extra"),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _textControllerInformacion,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "Ingrese Informacion extra ",
                          ),
                        ),
                      ),
                      const FechaInstalacionMasiso(),
                      const CheckBoxMasiso(),
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

class CheckBoxMasiso extends StatefulWidget {
  const CheckBoxMasiso({super.key});

  @override
  State<CheckBoxMasiso> createState() => _CheckBoxMasisoState();
}

class _CheckBoxMasisoState extends State<CheckBoxMasiso> {
  @override
  Widget build(BuildContext context) {
    if (_value == true) {
      solucion = "si";
    } else {
      solucion = "no ";
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Equipo Activo $solucion',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 20),
          Checkbox(
            value: _value,
            onChanged: (bool? newValue) {
              setState(() {
                _value = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}

class DropDownMasiso extends StatefulWidget {
  const DropDownMasiso({super.key});

  @override
  State<DropDownMasiso> createState() => _DropDownMasisoState();
}

class _DropDownMasisoState extends State<DropDownMasiso> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
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
    );
  }
}

class FechaInstalacionMasiso extends StatefulWidget {
  const FechaInstalacionMasiso({super.key});

  @override
  State<FechaInstalacionMasiso> createState() => _FechaInstalacionMasisoState();
}

class _FechaInstalacionMasisoState extends State<FechaInstalacionMasiso> {
  @override
  Widget build(BuildContext context) {
    if (_textControllerFechaInstalacion == null) {
      fechaNuevaBien = DateTime.now();
    } else {
      fechaNuevaBien = _textControllerFechaInstalacion;
    }
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          const Text("Seleccione la fecha de Instalación"),
          DatePickerWidget(
            onChange: (dateTime, selectedIndex) =>
                _textControllerFechaInstalacion = dateTime,
            initialDate: fechaNuevaBien,
            //lastDate: DateTime.now().add(const Duration(days: -500)),
            //firstDate: DateTime.now().add(const Duration(days: -(365 * 150))),

            locale: DatePicker.localeFromString("es"),
            pickerTheme: DateTimePickerTheme(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor),
          ),
        ],
      ),
    );
  }
}

class FeachaAdquisicionMasiso extends StatefulWidget {
  const FeachaAdquisicionMasiso({super.key});

  @override
  State<FeachaAdquisicionMasiso> createState() =>
      _FeachaAdquisicionMasisoState();
}

class _FeachaAdquisicionMasisoState extends State<FeachaAdquisicionMasiso> {
  @override
  Widget build(BuildContext context) {
    if (_textControllerFechaAdquisicion == null) {
      fechaNuvea = DateTime.now();
    } else {
      fechaNuvea = _textControllerFechaAdquisicion;
    }

    return Column(
      children: [
        const Text("Seleccione la fecha de adquisición"),
        DatePickerWidget(
          onChange: (dateTime, selectedIndex) =>
              _textControllerFechaAdquisicion = dateTime,
          initialDate: fechaNuvea,
          //lastDate: DateTime.now().add(const Duration(days: -500)),
          //firstDate: DateTime.now().add(const Duration(days: -(365 * 150))),

          locale: DatePicker.localeFromString("es"),
          pickerTheme: DateTimePickerTheme(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              dividerColor: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
