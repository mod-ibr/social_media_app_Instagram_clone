import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String header;
  final List<Widget> buttons;

  const CustomBottomSheet({
    super.key,
    required this.header,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Text(
              header,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          const Divider(
            height: 1.0,
            color: Colors.grey,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: buttons,
          ),
        ],
      ),
    );
  }
}

/* How to use */
/*
void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return IOSBottomSheet(
        header: 'Options',
        buttons: [
          ElevatedButton(
            onPressed: () {
              // Handle button press
              Navigator.of(context).pop(); // Dismiss the bottom sheet
            },
            child: Text('Button 1'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle button press
              Navigator.of(context).pop(); // Dismiss the bottom sheet
            },
            child: Text('Button 2'),
          ),
        ],
      );
    },
  );
}

 */