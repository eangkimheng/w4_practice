import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

final ColorService colorService = ColorService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

enum CardType { red, blue,}

class ColorService extends ChangeNotifier {
  final Map<CardType, int> _tapCounts = {CardType.red: 0, CardType.blue: 0,};

  Map<CardType, int> get tapCounts => _tapCounts;

  void increment(CardType type) {
    _tapCounts[type] = _tapCounts[type]! + 1;
    notifyListeners();
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? const ColorTapsScreen()
          : const StatisticsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play),
            label: 'Taps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}

class ColorTapsScreen extends StatelessWidget {
  const ColorTapsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Taps')),
      body: ListenableBuilder(
        listenable: ColorService(),
        builder: (context, child) {
          return Column(
            children: [
              ColorTap(type: CardType.red),
              ColorTap(type: CardType.blue),
            ],
          );
        },
      ),
    );
  }
}

class ColorTap extends StatelessWidget {
  final CardType type;

  const ColorTap({super.key, required this.type});

  Color get backgroundColor => type == CardType.red ? Colors.red : Colors.blue;

  @override
  Widget build(BuildContext context) {
    final tapCount = colorService.tapCounts[type]!;
    return GestureDetector(
      onTap: () {
        colorService.increment(type);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 100,
        child: Center(
          child: Text(
            'Taps: $tapCount',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListenableBuilder(
        listenable: colorService,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: colorService.tapCounts.entries.map((entry) {
                return Text(
                  '${entry.key.name.toUpperCase()} Taps: ${entry.value}',
                  style: const TextStyle(fontSize: 24),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
