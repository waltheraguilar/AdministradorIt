//excepciones de login

class UsuarioAuthNoEcontrado implements Exception {}

class MalaContrasenaAuthException implements Exception {}

// Excepciones de registrar


class ContrasenaDebilAuthExcepcion implements Exception {}

class EmailYaEstaEnUsoAuthExcepcion implements Exception {}

class EmailInvalidoExcepcion implements Exception {}

// excepciones genericas

class GenericaAuthExcepcion implements Exception {}

class UsuarioNoLogueadoAuthExcepcion implements Exception {}