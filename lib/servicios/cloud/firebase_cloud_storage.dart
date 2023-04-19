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


  Future<void> updateEquipos(
      {required String documentId,
      required String codigoDelEquipo,
      required String descripcionDelEquipo,
      required String fechaAdquisicion,
      required String fechaInstalacion,
      required String informacionExtra,
      required String modeloEquipo,
      required String nombreEquipo,
      required String passwordAdministrador,
      required String tipoEquipo,
      required String ubicacion,
      required String usuarioAdministrado}) async {
    try {
      equipos.doc(documentId).update({
      codigoDelEquipoConst :codigoDelEquipo,
      descripcionDelEquipoConst : descripcionDelEquipo,
      fechaAdquisicionConst : fechaAdquisicion,
      fechaInstalacionConst  : fechaInstalacion,
      informacionExtraConst : informacionExtra,
      modeloEquipoConst : modeloEquipoConst,
      nombreEquipoConst : nombreEquipoConst, 
      passwordAdministradorConst : passwordAdministradorConst,
      tipoEquipoConst : tipoEquipoConst,
      ubicacionConst : ubicacionConst,
      usuarioAdministradorConst : usuarioAdministradorConst
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> todosEquipos({required String userId}) =>
      equipos.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((equipos) => equipos.userId == userId));

  Future<Iterable<CloudNote>> obtenerEquipos({required String userId}) async {
    try {
      return await equipos
          .where(userIdConst, isEqualTo: userId)
          .get()
          .then((value) => value.docs.map((doc) {
                return CloudNote(
                    documentId: doc.id,
                    codigoDelEquipo: doc.data()[userIdConst] as String,
                    descripcionDelEquipo:
                        doc.data()[descripcionDelEquipoConst] as String,
                    fechaAdquisicion:
                        doc.data()[fechaAdquisicionConst] as String,
                    fechaInstalacion:
                        doc.data()[fechaInstalacionConst] as String,
                    informacionExtra:
                        doc.data()[informacionExtraConst] as String,
                    modeloEquipo: doc.data()[modeloEquipoConst] as String,
                    nombreEquipo: doc.data()[nombreEquipoConst] as String,
                    passwordAdministrador:
                        doc.data()[passwordAdministradorConst] as String,
                    tipoEquipo: doc.data()[tipoEquipoConst] as String,
                    ubicacion: doc.data()[ubicacionConst] as String,
                    usuarioAdministrador:
                        doc.data()[usuarioAdministradorConst] as String,
                    userId: userId);
              }));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  void createNuevoEquipo({required String userId}) async {
    await equipos.add({
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
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
