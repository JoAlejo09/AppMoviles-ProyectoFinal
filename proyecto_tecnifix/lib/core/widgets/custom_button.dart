import 'package:flutter/material.dart';

// Widget personalizado para botones reutilizables
class CustomButton extends StatelessWidget {
  // Texto del botón
  final String text;

  // Acción cuando se presiona
  final VoidCallback onPressed;

  // Constructor con parámetros obligatorios
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Acción del botón
      onPressed: onPressed,

      // Texto que se muestra
      child: Text(text),
    );
  }
}
