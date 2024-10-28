// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gdsc_round2/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdfx/pdfx.dart';

class pdfViewer extends StatefulWidget {
  const pdfViewer({super.key, required this.args, required this.name});
  final String args;
  final String name;
  
  @override
  State<pdfViewer> createState() => _pdfViewerState();
}

class _pdfViewerState extends State<pdfViewer> {
  late PdfController _pdfController;
  Box box = Hive.box("myBox");

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.args),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        child: SafeArea(
          child: Column(
            children: [
          
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Home())), 
                        icon: Icon(Icons.arrow_back_ios_rounded)
                      ),
        
                      SizedBox(
                        width: 5,
                      ),
                  
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Mont",
                              fontWeight: FontWeight.w900,
                              fontSize: 15
                            ),
                          )
                        )
                      )
                    ],
                  ),
                )
              ),
          
              Expanded(
                flex: 10,
                child: PdfView(
                  onPageChanged: (_) => setState(() {}),
                  onDocumentLoaded: (_) {
        
                    Map recent = box.get("recentFiles", defaultValue: {});
                    recent[widget.name] = {
                      "pages":_pdfController.pagesCount,
                      "path": widget.args
                    };
                    box.put("recentFiles", recent);
        
                    setState(() {});
                  },
                  controller: _pdfController,
                  builders: PdfViewBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    documentLoaderBuilder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    pageLoaderBuilder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
          
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
        
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => {
                              _pdfController.previousPage(duration: Duration(milliseconds: 250), curve: Curves.linear)
                            }, 
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 20,
                            ),
                          ),
                          Text(
                            "Previous Page",
                            style: TextStyle(
                              fontFamily: "Mont",
                              fontWeight: FontWeight.w900,
                              fontSize: 10
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${_pdfController.page} / ${_pdfController.pagesCount}",
                          style: TextStyle(
                            fontFamily: "Mont",
                            fontWeight: FontWeight.w900,
                            fontSize: 16
                          ),
                        )
                      )
                    ),
                    
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => {
                              _pdfController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.linear)
                            }, 
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                            ),
                          ),
                          Text(
                            "Next Page",
                            style: TextStyle(
                              fontFamily: "Mont",
                              fontWeight: FontWeight.w900,
                              fontSize: 10
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
          
          
            ],
          ),
        ),
      )
    );
  }
}