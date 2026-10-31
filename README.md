# tanda_dolorena


## Ronda 1 Registrar una aportación válida

### Rojo
<img width="1102" height="580" alt="image" src="https://github.com/user-attachments/assets/61728eb3-1b3e-418b-89a7-58147377e673" />

import 'package:flutter_test/flutter_test.dart';
import 'package:tanda_dolorena/modelos/participante.dart';
import 'package:tanda_dolorena/modelos/tanda.dart';
import 'package:tanda_dolorena/logica/resultado_aportacion.dart';
import 'package:tanda_dolorena/logica/resultado_cierre.dart';
import 'package:tanda_dolorena/logica/servicio_tanda.dart';

// Crea una tanda de prueba con 3 vecinos para usarla en todas las pruebas
Tanda _crearTandaDePrueba() {
  return Tanda(
    participantes: [
      Participante(id: 'p1', nombre: 'Ana'),
      Participante(id: 'p2', nombre: 'Beto'),
      Participante(id: 'p3', nombre: 'Carla'),
    ],
    ordenTurnos: ['p1', 'p2', 'p3'], // el orden en que van a cobrar
    montoAportacion: 200,
  );
}

void main() {
  // Ronda 1: una aportación válida se tiene que guardar en la ronda actual
  test('registrar una aportacion valida la agrega a la ronda actual', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);

    final resultado = servicio.registrarAportacion('p1');

    expect(resultado, ResultadoAportacion.registrada);
    expect(tanda.aportacionesRondaActual.contains('p1'), true);
  });
}

Escribi la prueba y todavía no existe `ServicioTanda`, por eso falla.


###  Verde

<img width="674" height="230" alt="image" src="https://github.com/user-attachments/assets/3098aceb-cf4e-4752-aa50-74681b7b2f6a" />

import '../modelos/tanda.dart';
import '../modelos/cierre_ronda.dart';
import 'resultado_aportacion.dart';
import 'resultado_cierre.dart';

// Aquí van las reglas de la tanda
class ServicioTanda {
  final Tanda tanda;
  ServicioTanda(this.tanda);

  // Por ahora solo agrega la aportación y dice que se registró
  ResultadoAportacion registrarAportacion(String idParticipante) {
    tanda.aportacionesRondaActual.add(idParticipante);
    return ResultadoAportacion.registrada;
  }
}

## Ronda 2 Rechazar una aportación repetida

### Rojo
<img width="1178" height="751" alt="image" src="https://github.com/user-attachments/assets/ee93d55a-ad40-42ba-853d-bc7bbaef3841" />

  // Ronda 2: nadie puede aportar dos veces en la misma ronda
  test('un participante no puede aportar dos veces en la misma ronda', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);
    servicio.registrarAportacion('p1');

    final segundoIntento = servicio.registrarAportacion('p1');

    expect(segundoIntento, ResultadoAportacion.yaAporto);
  });

### Verde
<img width="911" height="193" alt="image" src="https://github.com/user-attachments/assets/757ad12b-c04d-476c-b131-6449099ca075" />

  ResultadoAportacion registrarAportacion(String idParticipante) {
    // Si ya aportó en esta ronda, no lo dejamos otra vez
    if (tanda.aportacionesRondaActual.contains(idParticipante)) {
      return ResultadoAportacion.yaAporto;
    }
    tanda.aportacionesRondaActual.add(idParticipante);
    return ResultadoAportacion.registrada;
  }

## Ronda 3 Rechazar aportaciones de quien no es participante

### Rojo

<img width="1087" height="524" alt="image" src="https://github.com/user-attachments/assets/fbedfe6e-0c2d-4c2d-a411-313c718f75fe" />

  // Ronda 3: alguien que no está en la tanda no puede aportar
  test('alguien que no pertenece a la tanda no puede aportar', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);

    final resultado = servicio.registrarAportacion('desconocido');

    expect(resultado, ResultadoAportacion.participanteInvalido);
  });

###  Verde
<img width="655" height="234" alt="image" src="https://github.com/user-attachments/assets/50a55769-1c24-483a-acd5-4ecd5952f47d" />

  ResultadoAportacion registrarAportacion(String idParticipante) {
    // Primero checamos que sea de la tanda
    final esParticipante = tanda.participantes.any((p) => p.id == idParticipante);
    if (!esParticipante) return ResultadoAportacion.participanteInvalido;

    if (tanda.aportacionesRondaActual.contains(idParticipante)) {
      return ResultadoAportacion.yaAporto;
    }
    tanda.aportacionesRondaActual.add(idParticipante);
    return ResultadoAportacion.registrada;
  }

## Ronda 4  Detectar cuándo todos ya aportaron

### Rojo

<img width="1098" height="636" alt="image" src="https://github.com/user-attachments/assets/6a202a9c-1066-4722-81fc-f4230e33a089" />


**test/servicio_tanda_test.dart (pruebas agregadas)**

```dart
  // Ronda 4: si falta alguien por aportar no se puede cerrar la ronda
  test('puedeCerrarRonda es falso si falta algun participante por aportar', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);
    servicio.registrarAportacion('p1');
    servicio.registrarAportacion('p2');

    expect(servicio.puedeCerrarRonda(), false);
  });

  // Si ya aportaron todos sí se puede cerrar
  test('puedeCerrarRonda es verdadero cuando todos ya aportaron', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);
    servicio.registrarAportacion('p1');
    servicio.registrarAportacion('p2');
    servicio.registrarAportacion('p3');

    expect(servicio.puedeCerrarRonda(), true);
  });
```


###  Verde

<img width="668" height="233" alt="image" src="https://github.com/user-attachments/assets/3d42fa83-826a-495b-88c9-e1d7a972e8a4" />



**lib/logica/servicio_tanda.dart (método agregado)**

```dart
  // Revisa que todos los participantes ya hayan aportado
  bool puedeCerrarRonda() {
    return tanda.participantes.every((p) => tanda.aportacionesRondaActual.contains(p.id));
  }
```


## Ronda 5 Cerrar la ronda y entregar el turno

### Rojo
<img width="1092" height="602" alt="image" src="https://github.com/user-attachments/assets/cf748185-136d-4860-8377-ea0898d85c97" />


**test/servicio_tanda_test.dart (prueba agregada)**

```dart
  // Ronda 5: al cerrar la ronda se entrega el turno y se avanza
  test('cerrar la ronda entrega el turno al beneficiario y avanza', () {
    final tanda = _crearTandaDePrueba(); // orden: p1, p2, p3
    final servicio = ServicioTanda(tanda);
    servicio.registrarAportacion('p1');
    servicio.registrarAportacion('p2');
    servicio.registrarAportacion('p3');

    final cierre = servicio.cerrarRondaYAvanzar();

    expect(cierre.resultado, ResultadoCierre.rondaCerrada);
    expect(cierre.beneficiario!.id, 'p1');
    expect(tanda.participantes.firstWhere((p) => p.id == 'p1').yaRecibioTurno, true);
    expect(tanda.turnoActual, 1);
    expect(tanda.aportacionesRondaActual.isEmpty, true);
  });
```

### Verde

<img width="709" height="208" alt="image" src="https://github.com/user-attachments/assets/1b36cb89-b6f5-4ea0-9b80-ffbe80749ddf" />


**lib/logica/servicio_tanda.dart (método agregado)**

```dart
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
```

## Ronda 6  No cerrar la ronda si faltan aportaciones

### Rojo

<img width="758" height="230" alt="image" src="https://github.com/user-attachments/assets/7d263759-f22d-45d7-a127-83e4dbdcd44d" />


**test/servicio_tanda_test.dart (prueba agregada)**

```dart
  // Ronda 6: si falta alguien no se debe poder cerrar
  test('no se puede cerrar la ronda si algun participante no ha aportado', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);
    servicio.registrarAportacion('p1');
    servicio.registrarAportacion('p2'); // p3 no aporta

    final cierre = servicio.cerrarRondaYAvanzar();

    expect(cierre.resultado, ResultadoCierre.faltanAportaciones);
    expect(cierre.beneficiario, isNull);
    expect(tanda.turnoActual, 0); // no debió avanzar
  });
```

Esta prueba no sale en rojo, pasa directo porque el `if (!puedeCerrarRonda())` de la ronda 5 ya cubre este caso.

### 🟢 Verde

No se necesita código nuevo solo dejamos la prueba para proteger la regl


## Ronda 7  Detectar cuándo la tanda ha terminado

### Rojo

<img width="1092" height="613" alt="image" src="https://github.com/user-attachments/assets/10a668a5-46f9-46ca-9b2d-9d54d4899a48" />


**test/servicio_tanda_test.dart (pruebas agregadas)**

```dart
  // Ronda 7: mientras queden turnos la tanda no ha terminado
  test('haTerminado es falso mientras queden turnos pendientes', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);
    expect(servicio.haTerminado(), false);
  });

  // Cuando todos ya cobraron la tanda termina
  test('haTerminado es verdadero cuando todos ya recibieron su turno', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);
    for (final id in ['p1', 'p2', 'p3']) {
      servicio.registrarAportacion('p1');
      servicio.registrarAportacion('p2');
      servicio.registrarAportacion('p3');
      servicio.cerrarRondaYAvanzar();
    }
    expect(servicio.haTerminado(), true);
  });

  // Ya terminada, no se aceptan más aportaciones
  test('no se puede aportar una vez que la tanda ha terminado', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);
    for (final id in ['p1', 'p2', 'p3']) {
      servicio.registrarAportacion('p1');
      servicio.registrarAportacion('p2');
      servicio.registrarAportacion('p3');
      servicio.cerrarRondaYAvanzar();
    }

    final resultado = servicio.registrarAportacion('p1');

    expect(resultado, ResultadoAportacion.tandaTerminada);
  });
```

### Verde

<img width="671" height="230" alt="image" src="https://github.com/user-attachments/assets/f863d406-1842-4e71-92c2-4a1011a39226" />


**lib/logica/servicio_tanda.dart (método agregado y método corregido)**

```dart
  // La tanda termina cuando ya pasaron todos los turnos
  bool haTerminado() => tanda.turnoActual >= tanda.ordenTurnos.length;

  ResultadoAportacion registrarAportacion(String idParticipante) {
    if (haTerminado()) return ResultadoAportacion.tandaTerminada;

    final esParticipante = tanda.participantes.any((p) => p.id == idParticipante);
    if (!esParticipante) return ResultadoAportacion.participanteInvalido;

    if (tanda.aportacionesRondaActual.contains(idParticipante)) {
      return ResultadoAportacion.yaAporto;
    }
    tanda.aportacionesRondaActual.add(idParticipante);
    return ResultadoAportacion.registrada;
  }
```

## Ronda 8  Refactor: nombrar las condiciones como reglas de negocio

### Refactor

<img width="660" height="235" alt="image" src="https://github.com/user-attachments/assets/561267ac-1ab9-4659-9615-9229fc9ae0ec" />


Con las rondas anteriores en verde, le pongo nombre a las condiciones para que el método se lea como reglas de negocio. No cambia lo que hace, solo se lee mejo

**lib/logica/servicio_tanda.dart (refactorizado)**

```dart
  ResultadoAportacion registrarAportacion(String idParticipante) {
    if (haTerminado()) return ResultadoAportacion.tandaTerminada;

    final esParticipante = tanda.participantes.any((p) => p.id == idParticipante);
    if (!esParticipante) return ResultadoAportacion.participanteInvalido;

    final yaAporto = tanda.aportacionesRondaActual.contains(idParticipante);
    if (yaAporto) return ResultadoAportacion.yaAporto;

    tanda.aportacionesRondaActual.add(idParticipante);
    return ResultadoAportacion.registrada;
  }
```

## Prueba de integración: una tanda completa

<img width="674" height="234" alt="image" src="https://github.com/user-attachments/assets/5a90e70a-b18c-4a76-8381-1945dfe64114" />


**test/servicio_tanda_test.dart (prueba agregada)**

```dart
  // Simula una tanda completa de principio a fin
  test('simulacion completa: 3 vecinas completan una tanda de principio a fin', () {
    final tanda = _crearTandaDePrueba();
    final servicio = ServicioTanda(tanda);
    final beneficiarios = <String>[];

    while (!servicio.haTerminado()) {
      for (final p in tanda.participantes) {
        servicio.registrarAportacion(p.id);
      }
      final cierre = servicio.cerrarRondaYAvanzar();
      beneficiarios.add(cierre.beneficiario!.id);
    }

    expect(beneficiarios, ['p1', 'p2', 'p3']);
    expect(tanda.participantes.every((p) => p.yaRecibioTurno), true);
    expect(servicio.registrarAportacion('p1'), ResultadoAportacion.tandaTerminada);
  });
```

## CAPTURAS

<img width="370" height="834" alt="image" src="https://github.com/user-attachments/assets/10829d50-3eaa-45c6-a425-e411282807d2" />

<img width="372" height="830" alt="image" src="https://github.com/user-attachments/assets/45364564-4e44-43ca-81a0-a04955c4c1b2" />

<img width="374" height="829" alt="image" src="https://github.com/user-attachments/assets/2feb2a28-f19b-4745-8f91-4774a3bc2d22" />

<img width="370" height="833" alt="image" src="https://github.com/user-attachments/assets/3dd07231-dff5-4ca5-9263-ce1a055d57ea" />

<img width="369" height="833" alt="image" src="https://github.com/user-attachments/assets/3a90faf6-bafa-4780-a08b-601fe9a9b966" />

<img width="366" height="832" alt="image" src="https://github.com/user-attachments/assets/b56cd495-7237-4e98-a053-8d3e2c2ad5a1" />


La pantalla (`lib/presentation/tanda_screen.dart`) muestra el orden de turnos, resalta con animación a quien le toca, tiene una barra animada de cuántos ya aportaron y una animación al entregar el turno. La pantalla no decide quién cobra, solo se lo pregunta a `ServicioTanda`.

Capturas 

App inicio

App turno entregado



