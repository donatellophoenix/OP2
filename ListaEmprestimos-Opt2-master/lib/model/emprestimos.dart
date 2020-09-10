class Emprestimos {
  String _objeto;
  String _descricao;
  String _nome;
  bool _emprestado;

  Emprestimos(this._objeto, this._descricao, this._nome, this._emprestado);

  String get objeto => _objeto;
  String get descricao => _descricao;
  String get nome => _nome;
  bool get emprestado => _emprestado;

  Map getEmprestimos() {
    Map<String, dynamic> emprestimos = Map();
    emprestimos["objeto"] = _objeto;
    emprestimos["descricao"] = _descricao;
    emprestimos["nome"] = _nome;
    emprestimos["emprestado"] = _emprestado;

    return emprestimos;
  }
}
