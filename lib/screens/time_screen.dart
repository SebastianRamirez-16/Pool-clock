import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pooclock/rules/game_rules.dart';

class TimerScreen extends StatefulWidget {
  final GameRules rules;

  TimerScreen({required this.rules});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int remainingTime = 0; // Tiempo restante para cada turno
  String currentPlayer = ""; // Jugador actual
  late Timer timer;
  Color timerColor = Colors.blue; // Color inicial del timer
  bool isGameRunning = true;
  int totalGameTimeRemaining = 0; // Tiempo restante del juego completo.
  bool showTimeoutOverlay = false; // Variable para mostrar el overlay
  int player1Extensions = 0; // Extensiones restantes para el Jugador Azul
  int player2Extensions = 0; // Extensiones restantes para el Jugador Rojo
  bool extensionUsed =
      false; // Bandera para controlar el uso de extensión por turno
  int currentTurnTime =
      0; // Tiempo total actual del turno, incluyendo extensiones

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    currentPlayer = widget.rules.player1; // Jugador Azul inicia
    currentTurnTime = widget.rules.turnTime; // Tiempo inicial configurado
    remainingTime = currentTurnTime;

    if (!widget.rules.isUnlimitedTime) {
      totalGameTimeRemaining =
          widget.rules.gameDuration * 60; // Convertir minutos a segundos
    }

    // Inicializar extensiones según configuraciones
    player1Extensions = widget.rules.warnings;
    player2Extensions = widget.rules.warnings;

    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
          if (remainingTime <= 5) {
            // Cambiar color a rojo cuando queden 5 segundos
            timerColor = Colors.red;
          } else {
            timerColor = Colors.blue;
          }
        } else {
          // Cuando el tiempo llega a 0
          _showTimeoutOverlay();
        }

        if (!widget.rules.isUnlimitedTime && totalGameTimeRemaining > 0) {
          totalGameTimeRemaining--;
          if (totalGameTimeRemaining == 0) {
            _endGame();
          }
        }
      });
    });
  }

  void _useExtension() {
    setState(() {
      if (currentPlayer == widget.rules.player1 &&
          player1Extensions > 0 &&
          !extensionUsed) {
        remainingTime += widget.rules.doubleTimeDuration; // Añadir tiempo extra
        currentTurnTime += widget
            .rules.doubleTimeDuration; // Actualizar tiempo total del turno
        player1Extensions--; // Reducir extensiones disponibles
        extensionUsed = true; // Marcar extensión como usada en este turno
      } else if (currentPlayer == widget.rules.player2 &&
          player2Extensions > 0 &&
          !extensionUsed) {
        remainingTime += widget.rules.doubleTimeDuration;
        currentTurnTime += widget.rules.doubleTimeDuration;
        player2Extensions--;
        extensionUsed = true;
      }
      timerColor = Colors.blue; // Restablece el color del temporizador
    });
  }

  void _showTimeoutOverlay() {
    timer.cancel(); // Pausar el temporizador
    setState(() {
      showTimeoutOverlay = true; // Mostrar el overlay
    });
  }

  void _hideTimeoutOverlay() {
    setState(() {
      showTimeoutOverlay = false; // Ocultar el overlay
      _nextTurn(); // Continuar al siguiente turno
    });
    _startTimer(); // Reiniciar el temporizador
  }

  void _endGame() {
    timer.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Juego Finalizado'),
        content: Text('El tiempo total del juego ha terminado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _nextTurn() {
    setState(() {
      currentPlayer = currentPlayer == widget.rules.player1
          ? widget.rules.player2
          : widget.rules.player1; // Cambia el turno
      currentTurnTime =
          widget.rules.turnTime; // Reinicia el tiempo total del turno
      remainingTime = currentTurnTime; // Reinicia el temporizador
      timerColor = Colors.blue; // Restablece el color del temporizador
      extensionUsed =
          false; // Permitir una nueva extensión en el siguiente turno
    });
  }

  void _resetTurnTimer() {
    setState(() {
      currentTurnTime =
          widget.rules.turnTime; // Reinicia el tiempo total del turno
      remainingTime = currentTurnTime; // Reinicia el temporizador
      extensionUsed = false; // Permitir el uso de extensión si no se ha usado
      timerColor = Colors.blue; // Restablece el color
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer - Bola 9'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Información del Juego
              _buildGameInfo(),
              SizedBox(height: 16),
              // Timer Circular
              _buildCircularTimer(),
              SizedBox(height: 16),
              // Botones para pasar turno
              _buildTurnButtons(),
              // Tiempo Restante (si no es ilimitado)
              SizedBox(height: 16),
              _buildExtensionButtons(), // Botones de Extensión
              SizedBox(height: 16),
              if (!widget.rules.isUnlimitedTime) _buildTotalGameTime(),

              SizedBox(height: 16),
              // Controles del Juego
              _buildGameControls(),
            ],
          ),
          if (showTimeoutOverlay) _buildTimeoutOverlay(),
        ],
      ),
    );
  }

  Widget _buildExtensionButtons() {
    // Verificar si la extensión está habilitada en las configuraciones
    if (!widget.rules.doubleTimeEnabled) {
      return SizedBox
          .shrink(); // Retornar un widget vacío si la extensión está desactivada
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            ElevatedButton(
              onPressed: currentPlayer == widget.rules.player1 &&
                      player1Extensions > 0 &&
                      !extensionUsed
                  ? _useExtension
                  : null, // Habilitar solo si es el turno del jugador y tiene extensiones
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              child: Column(
                children: [
                  Text(
                    'Extensión',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${player1Extensions} restantes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.rules.player1,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: currentPlayer == widget.rules.player2 &&
                      player2Extensions > 0 &&
                      !extensionUsed
                  ? _useExtension
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              child: Column(
                children: [
                  Text(
                    'Extensión',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${player2Extensions} restantes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.rules.player2,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeoutOverlay() {
    return GestureDetector(
      onTap: _hideTimeoutOverlay, // Ocultar el overlay al hacer clic
      child: Container(
        color: Colors.black.withOpacity(0.7),
        alignment: Alignment.center,
        child: Text(
          'FALTA\nBOLA EN MANO',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGameInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Jugador Actual: $currentPlayer',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCircularTimer() {
    return GestureDetector(
      onTap: _resetTurnTimer, // Reinicia el temporizador al hacer clic
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 220,
              height: 220,
              child: CircularProgressIndicator(
                value: currentTurnTime > 0
                    ? remainingTime / currentTurnTime // Calcular progreso
                    : 0.0, // Valor predeterminado si el tiempo total es 0
                strokeWidth: 20, // Borde más ancho
                color: timerColor,
              ),
            ),
            Text(
              '$remainingTime s',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurnButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              currentPlayer = widget.rules.player1; // Cambia al jugador azul
              _resetTurnTimer();
            });
          },
          child: Container(
            width: 120,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: currentPlayer == widget.rules.player1
                  ? Colors.blue
                  : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.rules.player1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              currentPlayer = widget.rules.player2; // Cambia al jugador rojo
              _resetTurnTimer();
            });
          },
          child: Container(
            width: 120,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: currentPlayer == widget.rules.player2
                  ? Colors.red
                  : Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.rules.player2,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalGameTime() {
    return Center(
      child: Text(
        _formatTime(totalGameTimeRemaining),
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildGameControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _pauseGame,
          child: Text('Pausar'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        ),
        ElevatedButton(
          onPressed: _resumeGame,
          child: Text('Reanudar'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }

  void _pauseGame() {
    setState(() {
      isGameRunning = false;
      timer.cancel();
    });
  }

  void _resumeGame() {
    if (!isGameRunning) {
      setState(() {
        isGameRunning = true;
        _startTimer();
      });
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
