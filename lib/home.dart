// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gdsc_round2/pdfViewer.dart';
import 'package:pdfx/pdfx.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              Navigator.push(context, MaterialPageRoute(builder:(context) => pdfViewer(args: result.files.single.path!, name: result.files.single.name),));
            } else {
            }
          },

          child: Text(
            "Select File"
          ),
        )
      ),
    );
  }
}