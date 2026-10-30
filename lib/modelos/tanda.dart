import 'participante.dart';

// guarda todos los datos de la tanda
class Tanda {
  final List<Participante> participantes; // los vecinos del grupo
  final List<String> ordenTurnos; // ids en el orden en que van a cobrar
  final double montoAportacion; // lo que aporta cada uno por ronda
  int turnoActual = 0; // en que turno vamos
  final Set<String> aportacionesRondaActual = {}; // quienes ya aportaron en esta ronda

  Tanda({
    required this.participantes,
    required this.ordenTurnos,
    required this.montoAportacion,
  });
}