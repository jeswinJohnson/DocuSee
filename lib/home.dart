// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gdsc_round2/pdfViewer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfx/pdfx.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box box = Hive.box("myBox");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FilledButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => pdfViewer(args: result.files.single.path!, name: result.files.single.name),));
                } else {
                }
              },
        
              child: Text(
                "Select File"
              ),
            ),

            Builder(
              builder: (context){
                Map recents = box.get("recentFiles", defaultValue: {});
                List<Widget> recentsRender = [];
                for(var x in recents.keys){
                  recentsRender.add(
                    Text("${x} : ${recents[x]["pages"]} : ${recents[x]["path"]}")
                  );
                }
                return Column(
                  children: recentsRender,
                );
              }
            )
          ]
        ),
      ),
    );
  }
}