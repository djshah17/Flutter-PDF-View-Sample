import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutterpdfviewsample/pdf_view_screen.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {

  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePathPDF = "";

  @override
  void initState() {
    super.initState();
    fromAsset('docs/test_pdf.pdf', 'test_pdf.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });

    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePathPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset pdf file!');
    }

    return completer.future;
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
      final url = "http://www.pdf995.com/samples/pdf.pdf";
      final fileName = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error downloading pdf file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.red,
                child: Text("Simple PDF", style: TextStyle(fontSize: 22)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PDFViewScreen(path: pathPDF)),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.amber,
                child: Text("Remote PDF", style: TextStyle(fontSize: 22)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PDFViewScreen(path: remotePathPDF)),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
      ),
    );
  }
}
