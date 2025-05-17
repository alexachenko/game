import 'package:flutter/material.dart';


class BackgroundSelector extends StatelessWidget {
  final List<Map<String, dynamic>> backgrounds;
  final Function(String) onBackgroundSelected;
  final VoidCallback onClose;

  const BackgroundSelector({
    super.key,
    required this.backgrounds,
    required this.onBackgroundSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/map.png',
              width: 500,
              height: 550,
            ),
          ),
          Positioned(
            left: screenSize.width / 2 - 251,
            top: screenSize.height / 2 - 200,
            child: SizedBox(
              width: 500,
              height: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(backgrounds.length, (index) {
                  return GestureDetector(
                    onTap: () => onBackgroundSelected(backgrounds[index]['path']),
                    child: Container(
                      width: 135,
                      height: 150,
                      color: const Color.fromARGB(0, 0, 0, 0),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}