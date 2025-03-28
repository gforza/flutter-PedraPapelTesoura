import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> opcoes = ['pedra', 'papel', 'tesoura'];
  String escolhaUsuario = '';
  String escolhaMaquina = '';
  int pontosUsuario = 0;
  int pontosEmpate = 0;
  int pontosMaquina = 0;
  bool jogadaRealizada = false;

  void _jogar(String escolha) {
    if (jogadaRealizada) return;

    final random = Random();
    final escolhaMaquinaIndex = random.nextInt(3);

    setState(() {
      escolhaUsuario = escolha;
      escolhaMaquina = opcoes[escolhaMaquinaIndex];
      jogadaRealizada = true;
      _calcularResultado();
    });
  }

  void _calcularResultado() {
    if (escolhaUsuario == escolhaMaquina) {
      pontosEmpate++;
    } else if (
      (escolhaUsuario == 'pedra' && escolhaMaquina == 'tesoura') ||
      (escolhaUsuario == 'papel' && escolhaMaquina == 'pedra') ||
      (escolhaUsuario == 'tesoura' && escolhaMaquina == 'papel')
    ) {
      pontosUsuario++;
    } else {
      pontosMaquina++;
    }
  }

  Color _getBordaColor(String jogada, bool isUsuario) {
    if (!jogadaRealizada) return Colors.transparent;
    
    if (escolhaUsuario == escolhaMaquina) {
      return Colors.orange;
    }

    bool usuarioVenceu = 
      (escolhaUsuario == 'pedra' && escolhaMaquina == 'tesoura') ||
      (escolhaUsuario == 'papel' && escolhaMaquina == 'pedra') ||
      (escolhaUsuario == 'tesoura' && escolhaMaquina == 'papel');

    if (isUsuario) {
      return usuarioVenceu ? Colors.green : Colors.transparent;
    } else {
      return usuarioVenceu ? Colors.transparent : Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedra, Papel, Tesoura'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Disputa',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _getBordaColor(escolhaUsuario, true),
                    width: 3,
                  ),
                ),
                child: Image.asset(
                  'assets/${escolhaUsuario.isEmpty ? 'indefinido' : escolhaUsuario}.png',
                  width: 100,
                  height: 100,
                ),
              ),
              const Text(
                'VS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _getBordaColor(escolhaMaquina, false),
                    width: 3,
                  ),
                ),
                child: Image.asset(
                  'assets/${escolhaMaquina.isEmpty ? 'indefinido' : escolhaMaquina}.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Placar',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Você'),
                    Text(
                      pontosUsuario.toString(),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Empate'),
                    Text(
                      pontosEmpate.toString(),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Máquina'),
                    Text(
                      pontosMaquina.toString(),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          const Text(
            'Opções',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: opcoes.map((opcao) {
                return GestureDetector(
                  onTap: () {
                    _jogar(opcao);
                  },
                  child: Image.asset(
                    'assets/$opcao.png',
                    width: 80,
                    height: 80,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: jogadaRealizada
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  escolhaUsuario = '';
                  escolhaMaquina = '';
                  jogadaRealizada = false;
                });
              },
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }
} 