//  clase  cada vecino que participa en la tanda
class Participante {
  final String id; // identificador único del vecino
  final String nombre;
  bool yaRecibioTurno; // para saber si ya le tocó cobrar

  Participante({
    required this.id,
    required this.nombre,
    this.yaRecibioTurno = false, // al inicio nadie ha cobrado
  });
}