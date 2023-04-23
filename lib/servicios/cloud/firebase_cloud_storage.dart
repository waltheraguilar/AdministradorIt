import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itadministrador/servicios/cloud/cloud_constantes.dart';
import 'package:itadministrador/servicios/cloud/cloud_guardado_excepciones.dart';
import 'package:itadministrador/servicios/cloud/cloud_note.dart';

class FirebaseCloudStorage {
  final equipos = FirebaseFirestore.instance.collection("equipos");

  Future<void> deleteNote({required String documentId}) async {
    try {
      await equipos.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateEquipos({
    required String documentId,
    required String nombreEquipo,
    required String modeloEquipo,
    required String codigoDelEquipo,
    required String usuarioAdministrado,
    required String passwordAdministrador,
    required String ubicacion,
    required String tipoEquipo,
    required String fechaAdquisicion,
    required String informacionExtra,
    required String fechaInstalacion,
    required String descripcionDelEquipo,
  }) async {
    try {
      equipos.doc(documentId).update({
        nombreEquipoConst: nombreEquipo,
        modeloEquipoConst: modeloEquipo,
        codigoDelEquipoConst: codigoDelEquipo,
        usuarioAdministradorConst: usuarioAdministrado,
        passwordAdministradorConst: passwordAdministrador,
        ubicacionConst: ubicacion,
        tipoEquipoConst: tipoEquipo,
        fechaAdquisicionConst: fechaAdquisicion,
        informacionExtraConst: informacionExtra,
        fechaInstalacionConst: fechaInstalacion,
        descripcionDelEquipoConst: descripcionDelEquipo,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> todosEquipos({required String userId}) =>
      equipos.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((equipos) => equipos.userId == userId));

 Stream<Iterable<CloudNote>> todosEquiposFiltrador({required String userId, required String text}) =>
      equipos.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((equipos) => equipos.userId == userId && equipos.nombreEquipo.toLowerCase().contains(text.toLowerCase())));


  Future<Iterable<CloudNote>> obtenerEquipos({required String userId}) async {
    try {
      return await equipos
          .where(userIdConst, isEqualTo: userId)
          .get()
          .then((value) => value.docs.map(
                (doc) => CloudNote.fromSnapshot(doc),
              ));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNuevoEquipo({required String userId}) async {
    final document = await equipos.add({
      userIdConst: userId,
      codigoDelEquipoConst: "",
      descripcionDelEquipoConst: "",
      fechaAdquisicionConst: "",
      fechaInstalacionConst: "",
      informacionExtraConst: "",
      modeloEquipoConst: "",
      nombreEquipoConst: "",
      passwordAdministradorConst: "",
      tipoEquipoConst: "",
      ubicacionConst: "",
      usuarioAdministradorConst: "",
    });
    final fetchequipos = await document.get();
    return CloudNote(
        documentId: fetchequipos.id,
        codigoDelEquipo: " ",
        descripcionDelEquipo: '',
        fechaAdquisicion: '',
        fechaInstalacion: '',
        informacionExtra: '',
        modeloEquipo: '',
        nombreEquipo: '',
        passwordAdministrador: '',
        tipoEquipo: '',
        ubicacion: '',
        usuarioAdministrador: '',
        userId: userId);
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
