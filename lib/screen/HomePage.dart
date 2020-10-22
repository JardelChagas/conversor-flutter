import 'package:conversor/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double real;
  double dolar;
  double euro;

  void _realChanged(String text) {
    if (text.isEmpty) _clearAll();

    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) _clearAll();

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) _clearAll();

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
  }

  Center texto(String texto) {
    return Center(
      child: Text(
        texto,
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  buildTextField(String label, String prefix, TextEditingController controller,
      Function f) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix,
      ),
      style: TextStyle(color: Colors.amber),
      onChanged: f,
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return texto("Carregando Dados...");
            default:
              if (snapshot.hasError) {
                return texto("Erro ao Carregar Dados...");
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          "Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField(
                          "Dolares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField(
                          "Euros", "€", euroController, _euroChanged),
                      Divider(),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
