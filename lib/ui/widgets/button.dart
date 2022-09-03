import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(

          height: 50,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Container(
             margin: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
  }
}
