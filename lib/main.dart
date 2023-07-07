import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xsizero/vsplayer.dart';
import 'package:xsizero/selectdif.dart';
void main() {
  runApp(const NavApp());
}

class NavApp extends StatelessWidget {
  const NavApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/vsplayer': (context) => const PlayerVsPlayer(),
        '/selectDifficulty': (context) => const VsComputer(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 200, // Adjust the height as needed
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/selectDifficulty');
              },
              child: SizedBox(
                width: 145,
                height: 35,
                child: Row(
                  children: const [
                    Icon(Icons.computer, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Play vs Computer'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/vsplayer');
              },
              child: SizedBox(
                width: 145,
                height: 35,
                child: Row(
                  children: const [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Play vs Player'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
