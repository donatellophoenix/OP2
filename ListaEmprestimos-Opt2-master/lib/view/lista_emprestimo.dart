import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trabalho3_op2/model/emprestimos.dart';
import 'package:trabalho3_op2/persistence/manipula_emprestimo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _dataInfo = DateTime.now();
  ManipulaEmprestimo manipulaArquivo = ManipulaEmprestimo();
  final _objetoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _nomeController = TextEditingController();
  Map<String, dynamic> _ultimoRemovido;
  int _ultimoRemovidoPos;
  List _emprestimoList = [];
  @override
  void initState() {
    super.initState();
    manipulaArquivo.readEmprestimos().then((dado) {
      setState(() {
        _emprestimoList = json.decode(dado);
      });
    });
  }

  void _addEmprestimo() {
    setState(() {
      Map<String, dynamic> novoEmprestimo = Map();
      Emprestimos emprestimos = Emprestimos(_objetoController.text,
          _descricaoController.text, _nomeController.text, true);
      novoEmprestimo = emprestimos.getEmprestimos();
      _objetoController.text = "";
      _descricaoController.text = "";
      _nomeController.text = "";
      _emprestimoList.add(novoEmprestimo);
      manipulaArquivo.saveEmprestimos(_emprestimoList);
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _emprestimoList.sort((a, b) {
        if (a["emprestado"] && !b["emprestado"])
          return 1;
        else if (!a["emprestado"] && b["emprestado"])
          return -1;
        else
          return 0;
      });
      manipulaArquivo.saveEmprestimos(_emprestimoList);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Emprestimos"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _objetoController,
                    decoration: InputDecoration(labelText: "Objeto"),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _descricaoController,
                    decoration:
                        InputDecoration(labelText: "Descrição do objeto"),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: "Nome"),
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            child: Row(
              children: <Widget>[
                Text("${_dataInfo}"),
                Icon(Icons.calendar_today),
              ],
            ),
            onPressed: () async {
              final dataSelecionada = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1967),
                lastDate: DateTime(2050),
                builder: (BuildContext context, Widget child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child,
                  );
                },
              );
              if (dataSelecionada != null && dataSelecionada != _dataInfo) {
                setState(() {
                  _dataInfo = dataSelecionada as DateTime;
                });
              }
            },
          ),
          Center(
            child: Container(
              child: RaisedButton(
                child: Text("+"),
                textColor: Colors.white,
                onPressed: () {
                  _addEmprestimo();
                },
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _emprestimoList.length,
                  itemBuilder: buildItem),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text("${_emprestimoList[index]["objeto"]}\n" +
            "${_emprestimoList[index]["descricao"]}\n" +
            "${_emprestimoList[index]["nome"]}\n" +
            "${_dataInfo}"),
        value: _emprestimoList[index]["emprestado"],
        secondary: CircleAvatar(
          child: Icon(
              _emprestimoList[index]["emprestado"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _emprestimoList[index]["emprestado"] = c;
            manipulaArquivo.saveEmprestimos(_emprestimoList);
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _ultimoRemovido = Map.from(_emprestimoList[index]);
          _ultimoRemovidoPos = index;
          _emprestimoList.removeAt(index);
          manipulaArquivo.saveEmprestimos(_emprestimoList);
          final snack = SnackBar(
            content:
                Text("Emprestimo \"${_ultimoRemovido["objeto"]}\" removida!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _emprestimoList.insert(_ultimoRemovidoPos, _ultimoRemovido);
                    manipulaArquivo.saveEmprestimos(_emprestimoList);
                  });
                }),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }
}
