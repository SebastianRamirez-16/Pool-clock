import 'package:flutter/material.dart';
import 'package:pooclock/rules/game_rules.dart';
import 'package:pooclock/screens/time_screen.dart';

class Bola9MenuScreen extends StatefulWidget {
  @override
  _Bola9MenuScreenState createState() => _Bola9MenuScreenState();
}

class _Bola9MenuScreenState extends State<Bola9MenuScreen> {
  bool isUnlimitedTime = true;
  int gameDuration = 30;
  int turnTime = 30;
  bool doubleTimeEnabled = true;
  int doubleTimeDuration = 30;
  bool pushOutEnabled = false;
  int pushOutDuration = 15;
  int sets = 3;
  int warnings = 2;
  String player1 = "Jugador Azul";
  String player2 = "Jugador Rojo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración de Bola 9'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botón de Partida Rápida
            _buildQuickMatchButton(),
            SizedBox(height: 16),
            // Tiempo del Juego Total
            _buildSectionTitle('1. Tiempo del Juego Total'),
            _buildUnlimitedTimeSetting(),
            SizedBox(height: 16),
            // Tiempo entre Turnos
            _buildSectionTitle('2. Tiempo entre Turnos'),
            _buildTurnTimeSetting(),
            SizedBox(height: 16),
            // Extensión
            _buildSectionTitle('3. Extensión'),
            _buildExtensionSetting(),

            SizedBox(height: 16),
            // Push Out
            _buildSectionTitle('4. Push Out'),
            _buildPushOutSetting(),
            SizedBox(height: 16),
            // Cantidad de Sets
            _buildSectionTitle('5. Cantidad de Sets'),
            _buildSetCountSetting(),
            SizedBox(height: 16),
            // Configuración de Advertencias
            _buildSectionTitle('6. Configuración de Advertencias'),
            _buildWarningSetting(),
            SizedBox(height: 16),
            // Registro de Jugadores
            _buildSectionTitle('7. Registro de Jugadores'),
            _buildPlayerRegistration(),
            SizedBox(height: 16),
            // Estilo de Juego
            _buildSectionTitle('8. Estilo de Juego'),
            _buildGameStyleSetting(),
            SizedBox(height: 32),
            // Botón Comenzar
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildUnlimitedTimeSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tiempo Ilimitado'),
            Switch(
              value: isUnlimitedTime,
              onChanged: (value) {
                setState(() {
                  isUnlimitedTime = value;
                });
              },
            ),
          ],
        ),
        if (!isUnlimitedTime)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text('Duración del Juego (minutos)'),
              Slider(
                value: gameDuration.toDouble(),
                min: 10,
                max: 120,
                divisions: 11,
                label: '$gameDuration minutos',
                onChanged: (value) {
                  setState(() {
                    gameDuration = value.toInt();
                  });
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTurnTimeSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiempo entre Turnos (en segundos)'),
        Slider(
          value: turnTime.toDouble(),
          min: 5,
          max: 60,
          divisions: 11,
          label: '$turnTime segundos',
          onChanged: (value) {
            setState(() {
              turnTime = value.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget _buildExtensionSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Extensión'),
        Switch(
          value: doubleTimeEnabled,
          onChanged: (value) {
            setState(() {
              doubleTimeEnabled = value;
            });
          },
        ),
        if (doubleTimeEnabled) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text('Duración de la Extensión (en segundos)'),
              Slider(
                value: doubleTimeDuration.toDouble(),
                min: 15,
                max: 60,
                divisions: 3,
                label: '$doubleTimeDuration segundos',
                onChanged: (value) {
                  setState(() {
                    doubleTimeDuration = value.toInt();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Cantidad de Extensiones Permitidas por Jugador'),
          Slider(
            value: warnings.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$warnings extensiones',
            onChanged: (value) {
              setState(() {
                warnings = value.toInt();
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildPushOutSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Push Out'),
        Switch(
          value: pushOutEnabled,
          onChanged: (value) {
            setState(() {
              pushOutEnabled = value;
            });
          },
        ),
        if (pushOutEnabled)
          Slider(
            value: pushOutDuration.toDouble(),
            min: 5,
            max: 30,
            divisions: 5,
            label: '$pushOutDuration segundos',
            onChanged: (value) {
              setState(() {
                pushOutDuration = value.toInt();
              });
            },
          ),
      ],
    );
  }

  Widget _buildSetCountSetting() {
    return DropdownButton<int>(
      value: sets,
      onChanged: (value) {
        setState(() {
          sets = value!;
        });
      },
      items: [3, 5, 7]
          .map((e) => DropdownMenuItem(value: e, child: Text('Mejor de $e')))
          .toList(),
    );
  }

  Widget _buildWarningSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Número de Advertencias'),
        Slider(
          value: warnings.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: '$warnings',
          onChanged: (value) {
            setState(() {
              warnings = value.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget _buildPlayerRegistration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.blue[100],
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(labelText: 'Jugador Azul'),
            onChanged: (value) {
              setState(() {
                player1 = value;
              });
            },
          ),
        ),
        SizedBox(height: 8),
        Container(
          color: Colors.red[100],
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(labelText: 'Jugador Rojo'),
            onChanged: (value) {
              setState(() {
                player2 = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGameStyleSetting() {
    return DropdownButton<String>(
      value: 'Reglas Amistosas',
      onChanged: (value) {
        // Implementar lógica si es necesario
      },
      items: [
        DropdownMenuItem(
            value: 'Reglas Amistosas', child: Text('Reglas Amistosas')),
        DropdownMenuItem(
            value: 'Reglas de Torneo', child: Text('Reglas de Torneo')),
        DropdownMenuItem(value: 'Personalizado', child: Text('Personalizado')),
      ],
    );
  }

  Widget _buildQuickMatchButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isUnlimitedTime = true;
          turnTime = 30;
          doubleTimeEnabled = true;
          sets = 3;
        });
      },
      child: Text('Partida Rápida'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  Widget _buildStartButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimerScreen(
                rules: GameRules(
                  isUnlimitedTime: isUnlimitedTime,
                  gameDuration: gameDuration,
                  turnTime: turnTime,
                  doubleTimeEnabled: doubleTimeEnabled,
                  doubleTimeDuration: doubleTimeDuration,
                  pushOutEnabled: pushOutEnabled,
                  pushOutDuration: pushOutDuration,
                  sets: sets,
                  warnings: warnings,
                  player1: player1,
                  player2: player2,
                ),
              ),
            ),
          );
        },
        child: Text('Comenzar', style: TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
        ),
      ),
    );
  }
}
