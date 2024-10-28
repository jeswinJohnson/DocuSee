// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
      body: Container(
        color: Colors.grey.shade200,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
        
                Row(
                  children: [       
        
                    Image.asset(
                      height: 35,
                      "lib/img/logo.png",
                      fit: BoxFit.cover,
                    ),
        
                    SizedBox(width: 10,),
        
                    Text(
                      "DocuSee",
                      style: TextStyle(
                        fontFamily: "Mont",
                        fontWeight: FontWeight.w900,
                        fontSize: 25
                      ),
                    ),
                  ],
                ),
        
                SizedBox(
                  height: 20,
                ),
        
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ["pdf"]
                    );
                    if (result != null) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => pdfViewer(args: result.files.single.path!, name: result.files.single.name),));
                    } else {
                    }
                  },
                  child: Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade200,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 40,
                        ),
                  
                        SizedBox(
                          height: 3,
                        ),
                  
                        Text(
                          "Open Pdf",
                          style: TextStyle(
                            fontFamily: "Mont",
                            fontWeight: FontWeight.w900,
                            fontSize: 20
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        
                SizedBox(
                  height: 20,
                ),
        
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recents",
                    style: TextStyle(
                      fontFamily: "Mont",
                      fontWeight: FontWeight.w900,
                      fontSize: 25
                    ),
                  ),
                ),
            
                Expanded(
                  child: Builder(
                    builder: (context){
                      Map recents = box.get("recentFiles", defaultValue: {});
                      List<Widget> recentsRender = [];
                      for(var x in recents.keys){
                        recentsRender.add(
                          GestureDetector(
                            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => pdfViewer(args: recents[x]["path"], name: x),)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade200,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      x,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Mont",
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20
                                      ),
                                    ),
                                                            
                                    SizedBox(
                                      height: 5,
                                    ),
                                                            
                                    Text(
                                      "Page Count : ${recents[x]["pages"]}",
                                      style: TextStyle(
                                        fontFamily: "Mont",
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        );
                      }
                      return GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        padding: EdgeInsets.all(10),
                        children: recentsRender,
                      );
                    }
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}