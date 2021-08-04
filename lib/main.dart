import 'package:flutter/material.dart';

void main() => runApp(ByteBankApp());

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTransferencia(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _textControllerNumConta = TextEditingController();
  final TextEditingController _textControllerValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferência'),
      ),
      body: Column(
        children: <Widget>[
          Editor(
            controlador: _textControllerNumConta,
            rotulo: 'Número da Conta',
            dica: '0000',
          ),
          Editor(
            controlador: _textControllerValor,
            rotulo: 'Valor',
            dica: '0.00',
            icone: Icons.monetization_on,
          ),
          ElevatedButton(
            onPressed: () => _criaTranferncia(context),
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void _criaTranferncia(BuildContext context) {
    final int numeroConta = int.parse(_textControllerNumConta.text);
    final double valor = double.parse(_textControllerValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {

  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData? icone;


  Editor({required this.controlador, required this.rotulo, required this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      //numero da conta
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
            labelText: rotulo,
            hintText: dica
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}


class ListaTransferencia extends StatelessWidget {

  final List<Transferencia> _trasnferencias = [];

  @override
  Widget build(BuildContext context) {

    _trasnferencias.add(Transferencia(100.0, 1000));

    // TODO: implement build
    return Scaffold(
      body: ListView.builder(
        itemCount: _trasnferencias.length,
        itemBuilder: (context, indice){
          final transferencia = _trasnferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      appBar: AppBar(
        title: Text('Transferências'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         final Future<Transferencia?> future = Navigator.push(context, MaterialPageRoute(builder: (context){
            return FormularioTransferencia();
          }));
         future.then((transferenciaRecebida){
           debugPrint('chegou no future');
           debugPrint('$transferenciaRecebida');
           _trasnferencias.add(transferenciaRecebida!);
         });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}
