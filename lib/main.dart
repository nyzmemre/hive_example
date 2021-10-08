import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  ///TR
  ///hive başlatılıyor. Eğer bağımlılıklar eklendikten sonra
  /// platform exception hatası alırsan uygulamayı durdurup
  /// tekrar çalıştır.

  ///EN
  ///hive initialize
  ///After adding dependencies, if you get a platform exception error,
  ///stop application and run it again.
  await Hive.initFlutter();

  ///TR
  ///kalıcı bilgilerin saklanacağı added isminde kutu aç.

  ///EN
  ///Open box named added where permanent information will be stored.

  await Hive.openBox<String>("added");
  runApp(HiveExample());
}

class HiveExample extends StatefulWidget {
  const HiveExample({Key? key}) : super(key: key);

  @override
  _HiveExampleState createState() => _HiveExampleState();
}

class _HiveExampleState extends State<HiveExample> {
  final _hiveBox = Hive.box<String>("added");

  String _addedText = "";

  List<String> _addList = [];

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _addList = _hiveBox.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Hive Example")),
        body: scaffoldBody(),
      ),
    );
  }

  Widget scaffoldBody() {
    return Center(
        child: ListView(
      children: [
        myTextfield(),
        addButtonWidget(),
        for (String value in _addList) showSavedTextsWidget(value)
      ],
    ));
  }

  Widget myTextfield() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          _addedText = value;
        },
        decoration: const InputDecoration(
            labelText: "Veri Giriniz", border: OutlineInputBorder()),
      ),
    );
  }

  Padding addButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 40.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            if (_addedText.length > 3) {
              _addList.add(_addedText);
              _hiveBox.add(_addedText);
              _addedText = "";
              _controller.clear();
              setState(() {});
            }
          },
          child: Text("Ekle"),
        ),
      ),
    );
  }

  Padding showSavedTextsWidget(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: ListTile(
          title: Text(value),
        ),
      ),
    );
  }
}
