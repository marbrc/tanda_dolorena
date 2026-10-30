import 'participante.dart';
import '../logica/resultado_cierre.dart';

// guarda cómo salió el cierre y quién fue el beneficiario (si hubo)
class CierreRonda {
  final ResultadoCierre resultado;
  final Participante? beneficiario; // puede ser null si no se pudo cerrar
  CierreRonda(this.resultado, this.beneficiario);
}