import 'package:flutter/material.dart';
import 'package:game/widgets/background_choice.dart';
import 'package:game/widgets/cat.dart';

class TamagotchiScreen extends StatefulWidget {
  const TamagotchiScreen({super.key});

  @override
  State<TamagotchiScreen> createState() => _TamagotchiScreenState();
}

class _TamagotchiScreenState extends State<TamagotchiScreen> {
  bool _showBackground = false;
  String _currentBackground = 'assets/images/background1.png';
  bool _showBackgroundSelection = false;

  final List<Map<String, dynamic>> backgrounds = [
    {'path': 'assets/images/background1.png', 'name': 'Комната'},
    {'path': 'assets/images/background2.png', 'name': 'Кухня'},
    {'path': 'assets/images/background3.png', 'name': 'Двор'},
  ];

  @override
  void initState() {
    super.initState();
    _loadBackground();
  }

  void _loadBackground() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _showBackground = true);
    });
  }

  void _openBackgroundSelection() => setState(() => _showBackgroundSelection = true);
  void _closeBackgroundSelection() => setState(() => _showBackgroundSelection = false);

  void _changeBackground(String newBackground) {
    setState(() {
      _currentBackground = newBackground;
      _showBackgroundSelection = false;
    });
  }

  void _handleScreenTap(TapDownDetails details) {
    if (_showBackgroundSelection) {
      _closeBackgroundSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: _handleScreenTap,
        child: Stack(
          children: [
            if (_showBackground)
              Positioned.fill(
                child: Image.asset(
                  _currentBackground,
                  fit: BoxFit.cover,
                ),
              ),

            if (_showBackground)
          CatWidget(
            onTapDown: (details) {
              if (_showBackgroundSelection) {
                _closeBackgroundSelection();
              }
            },
          ),

            if (_showBackground && !_showBackgroundSelection)
              Positioned(
                left: 42,
                top: 10,
                child: GestureDetector(
                  onTap: _openBackgroundSelection,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.transparent,
                  ),
                ),
              ),

            if (_showBackgroundSelection)
              BackgroundSelector(
                backgrounds: backgrounds,
                onBackgroundSelected: _changeBackground,
                onClose: _closeBackgroundSelection,
              ),
          ],
        ),
      ),
    );
  }
}