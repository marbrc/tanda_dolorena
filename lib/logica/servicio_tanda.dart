import '../modelos/tanda.dart';
import '../modelos/cierre_ronda.dart';
import 'resultado_aportacion.dart';
import 'resultado_cierre.dart';

// Aquí van las reglas de la tanda
class ServicioTanda {
  final Tanda tanda;
  ServicioTanda(this.tanda);

      // La tanda termina cuando ya pasaron todos los turnos
      bool haTerminado() => tanda.turnoActual >= tanda.ordenTurnos.length;

        ResultadoAportacion registrarAportacion(String idParticipante) {
          if (haTerminado()) return ResultadoAportacion.tandaTerminada;

          final esParticipante = tanda.participantes.any((p) => p.id == idParticipante);
          if (!esParticipante) return ResultadoAportacion.participanteInvalido;

          final yaAporto = tanda.aportacionesRondaActual.contains(idParticipante);
          if (yaAporto) return ResultadoAportacion.yaAporto;

          tanda.aportacionesRondaActual.add(idParticipante);
          return ResultadoAportacion.registrada;
        }

    // Revisa que todos los participantes ya hayan aportado
  bool puedeCerrarRonda() {
    return tanda.participantes.every((p) => tanda.aportacionesRondaActual.contains(p.id));
  }

    // Cierra la ronda, le da el turno a quien le toca y avanza al siguiente
  CierreRonda cerrarRondaYAvanzar() {
    if (!puedeCerrarRonda()) {
      return CierreRonda(ResultadoCierre.faltanAportaciones, null);
    }

    // El beneficiario sale del orden de turnos que ya estaba acordado
    final idBeneficiario = tanda.ordenTurnos[tanda.turnoActual];
    final beneficiario = tanda.participantes.firstWhere((p) => p.id == idBeneficiario);
    beneficiario.yaRecibioTurno = true;

    tanda.aportacionesRondaActual.clear(); // se limpia para la siguiente ronda
    tanda.turnoActual++;

    return CierreRonda(ResultadoCierre.rondaCerrada, beneficiario);
  }

  
  


  
  
}