import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert'; // for the utf8.encode method
import 'package:flutter/services.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String hashname = "SHA256";
  String encoded = "";
  final input_controller = TextEditingController();
  Widget WarningDialog(BuildContext context) {
    return new AlertDialog(
        title: const Text('Security warning'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("MD5 is an insecure hash algorithm and should not be used for cryptographic purposes.")

          ],
        ),
        actions: <Widget>[
    new FlatButton(
    onPressed: () {
      Navigator.of(context).pop();
    },
    textColor: Theme.of(context).primaryColor,
    child: const Text('Okay, got it!'),
    ),
    ],
    );
  }
  @override
  void dispose() {
    input_controller.dispose();
    super.dispose();
  }
  Digest hash(String Hash, String plaintext) {
    var bytes = utf8.encode(plaintext);
    if (Hash == 'MD5') {
      return md5.convert(bytes);
    }
    else if (Hash == 'SHA') {
      return sha1.convert(bytes);
    } else if (Hash == "SHA256") {
      return sha256.convert(bytes);
    }


  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32.0),
              child: TextField(
                controller: input_controller,
                onSubmitted: (String val) {
                  setState(() {
                    encoded = hash(hashname, val).toString();

                  });
                },
              ),
            ),

            DropdownButton<String> (
              value: hashname,
              onChanged: (String value) {
                setState(() {

                  hashname = value;
                  if (hashname == 'MD5'){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => WarningDialog(context),
                    );
                    // Perform some action
                  }
                });

              },

              items: <String>['SHA256', 'SHA', 'MD5']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FlatButton(
                  child: Text("Generate hash", style:
                    TextStyle(
                      fontSize: 16
                    )
                  ),
                  onPressed: () {
                    setState(() {
                      encoded = hash(hashname, input_controller.text).toString();
                    });
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: AutoSizeText(encoded, maxLines: 1)
            ),
            FlatButton(
              child: Text(
                  "Copy",
                style: TextStyle(
                  color: Colors.lightBlueAccent
                )
              ),
              onPressed: () {
                setState(() {
                  ClipboardManager.copyToClipBoard(encoded);
                  });



              }
            )



             ]
            )

        ),
      );

  }
}
