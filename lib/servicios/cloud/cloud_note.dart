
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:itadministrador/servicios/cloud/cloud_constantes.dart';

@immutable
class CloudNote{
  final String documentId;
 final String codigoDelEquipo ;

final String descripcionDelEquipo ;

final String fechaAdquisicion ;

final String fechaInstalacion ;

final String informacionExtra ;

final String modeloEquipo ;

final String  nombreEquipo ;

final String passwordAdministrador ;

final String  tipoEquipo ;

final String  ubicacion ;

final String usuarioAdministrador ;


final String userId ;

const   CloudNote({
 required this.documentId,
 required  this.codigoDelEquipo, 
 required  this.descripcionDelEquipo,
 required   this.fechaAdquisicion, 
 required   this.fechaInstalacion, 
 required   this.informacionExtra, 
required    this.modeloEquipo,
 required    this.nombreEquipo, 
required     this.passwordAdministrador,
required      this.tipoEquipo,
required       this.ubicacion, 
required       this.usuarioAdministrador,
 required       this.userId
}
        );

CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
 documentId = snapshot.id,
 codigoDelEquipo = snapshot.data()[codigoDelEquipoConst] as String,
 descripcionDelEquipo = snapshot.data()[descripcionDelEquipoConst] as String,
 fechaAdquisicion = snapshot.data()[fechaAdquisicionConst] as String,
fechaInstalacion = snapshot.data()[fechaInstalacionConst] as String,
informacionExtra = snapshot.data()[informacionExtraConst] as String,
modeloEquipo = snapshot.data()[modeloEquipoConst] as String,
nombreEquipo = snapshot.data()[nombreEquipoConst] as String,
passwordAdministrador = snapshot.data()[passwordAdministradorConst] as String,
tipoEquipo = snapshot.data()[tipoEquipoConst] as String,
ubicacion = snapshot.data()[ubicacionConst] as String, 
usuarioAdministrador = snapshot.data()[usuarioAdministradorConst] as String,

userId = snapshot.data()[userIdConst];
}