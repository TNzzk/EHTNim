import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo NIM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NimGame(),
    );
  }
}

class NimGame extends StatefulWidget {
  @override
  _NimGameState createState() => _NimGameState();
}

class _NimGameState extends State<NimGame> {
  int totalSticks = 0;
  int playerScore = 0;
  int computerScore = 0;
  TextEditingController controller = TextEditingController();

  void startGame(int initialSticks) {
    setState(() {
      totalSticks = initialSticks;
      playerScore = 0;
      computerScore = 0;
    });
  }

  void playerTurn(int sticks) {
    setState(() {
      totalSticks -= sticks;
      if (totalSticks <= 0) {
        computerScore++;
        showGameOverDialog("Você perdeu!");
      } else {
        computerTurn();
      }
    });
  }

  void computerTurn() {
    int computerSticks = (1 + (2 * (totalSticks - 1) / 3).toInt());
    if (totalSticks > 3) {
      computerSticks = (totalSticks - 1) % 4;
    }
    setState(() {
      totalSticks -= computerSticks;
      showSnackBar("Computador retirou: $computerSticks palitos");
      if (totalSticks <= 0) {
        playerScore++;
        showGameOverDialog("Você ganhou!");
      }
    });
  }

  void showGameOverDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message, style: TextStyle(fontSize: 20)),
          content: Text('Deseja recomeçar o jogo?'),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text('Sim', style: TextStyle(color: Colors.teal)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Não', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    totalSticks = 0;
    playerScore = 0;
    computerScore = 0;
    controller.clear();
    setState(() {});
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogo NIM')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[300]!, Colors.teal[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Palitos restantes: $totalSticks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Placar: Jogador $playerScore - Computador $computerScore',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                for (var i = 7; i <= 13; i++)
                  ElevatedButton(
                    onPressed: () {
                      startGame(i);
                    },
                    child: Text('Iniciar com $i', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Colors.teal,
                      onPrimary: Colors.white,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            if (totalSticks > 0) ...[
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Quantos palitos retirar (1-3)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
                maxLength: 1,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  int sticks = int.tryParse(controller.text) ?? 0;
                  if (sticks >= 1 && sticks <= 3) {
                    playerTurn(sticks);
                  } else {
                    showSnackBar("Por favor, escolha entre 1 e 3 palitos.");
                  }
                },
                child: Text('Retirar Palitos', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: Colors.teal,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
