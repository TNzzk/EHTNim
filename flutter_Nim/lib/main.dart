import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(NimGameApp());
}

// Classe principal do aplicativo
class NimGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo Nim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Tela inicial do jogo
    );
  }
}

// Tela inicial do jogo
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Nim'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            // Navega para a tela do jogo ao pressionar o botão
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NimGameScreen()),
            );
          },
          child: Text('Começar Jogo'),
        ),
      ),
    );
  }
}

// Tela do jogo
class NimGameScreen extends StatefulWidget {
  @override
  _NimGameScreenState createState() => _NimGameScreenState();
}

class _NimGameScreenState extends State<NimGameScreen> {
  int totalPalitos = 0; // Total de palitos disponíveis
  int palitosRestantes = 0; // Palitos restantes durante o jogo

  // Inicia o jogo com a quantidade especificada de palitos
  void iniciarJogo(int quantidade) {
    setState(() {
      totalPalitos = quantidade; // Define a quantidade total de palitos
      palitosRestantes = totalPalitos; // Reinicia os palitos restantes
    });
  }

  // Função para retirar palitos
  void retirarPalitos(int quantidade) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmar Retirada"),
          content: Text("Você deseja retirar $quantidade palito(s)?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo se cancelar
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                setState(() {
                  palitosRestantes -= quantidade; // Atualiza a quantidade de palitos restantes
                  // Verifica se o jogador perdeu
                  if (palitosRestantes <= 0) {
                    _exibirResultado("Você perdeu! O computador venceu.");
                    return;
                  }
                  // Jogada do computador
                  int computadorRetirada = _jogadaComputador(); // Chama a função para a jogada do computador
                  palitosRestantes -= computadorRetirada; // Atualiza os palitos restantes
                  // Verifica se o computador perdeu
                  if (palitosRestantes <= 0) {
                    _exibirResultado("Você venceu! O computador perdeu.");
                  } else {
                    // Exibe uma mensagem informando quantos palitos o computador retirou
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("O computador retirou $computadorRetirada palito(s)."),
                      ),
                    );
                  }
                });
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  // Função para calcular a jogada do computador
  int _jogadaComputador() {
    int retirada = (palitosRestantes - 1) % 4; // Lógica para tentar forçar a derrota do jogador
    // Se a retirada for 0 ou maior que 3, escolhe aleatoriamente
    if (retirada == 0 || retirada > 3) {
      retirada = Random().nextInt(3) + 1; // Retira aleatoriamente entre 1 e 3
    }
    return retirada;
  }

  // Função para exibir o resultado do jogo
  void _exibirResultado(String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Resultado"),
          content: Text(mensagem), // Mensagem de vitória ou derrota
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                setState(() {
                  palitosRestantes = 0; // Reseta os palitos
                });
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Nim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Se houver palitos restantes, mostra a contagem e botões para retirar
            if (palitosRestantes > 0) ...[
              Text(
                "Palitos restantes: $palitosRestantes",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Escolha quantos palitos retirar:",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8), // Botões menores
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      int quantidade = index + 1; // Determina quantos palitos o jogador quer retirar
                      if (quantidade <= palitosRestantes) {
                        retirarPalitos(quantidade); // Chama a função para retirar os palitos
                      }
                    },
                    child: Text('${index + 1} palito(s)'),
                  );
                }),
              ),
            ] else ...[
              // Se não houver palitos restantes, permite ao jogador escolher a quantidade inicial
              Text(
                "Escolha a quantidade de palitos para iniciar o jogo:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  int quantidade = index + 7; // Gera a quantidade de 7 a 13 palitos
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8), // Botões menores
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      iniciarJogo(quantidade); // Chama a função para iniciar o jogo
                    },
                    child: Text('$quantidade'),
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
