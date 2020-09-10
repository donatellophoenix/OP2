import 'package:flutter/material.dart';
import 'package:trabalho3_op2/view/lista_emprestimo.dart';

void main() {
  runApp((MaterialApp(
    theme: ThemeData(
        primaryColor: Colors.amber[900],
        accentColor: Colors.blueAccent[700],
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary)),
    home: Home(),
  )));
}
