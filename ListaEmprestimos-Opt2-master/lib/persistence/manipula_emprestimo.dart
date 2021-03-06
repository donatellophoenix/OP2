import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ManipulaEmprestimo {
  Future<File> _getArquivo() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/emprestimos.json");
  }

  Future<String> readEmprestimos() async {
    try {
      final file = await _getArquivo();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<File> saveEmprestimos(List emprestimoList) async {
    String data = json.encode(emprestimoList);
    final file = await _getArquivo();
    return file.writeAsString(data);
  }
}
