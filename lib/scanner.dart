import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'pdfContent.dart';
import 'dart:async';
import 'package:edge_detection/edge_detection.dart';
//import 'package:photofilters/photofilters.dart';
import './PhotoFilter/photofilters.dart';
//import './photofilters-master/lib/filters/preset_filters.dart';
import 'package:image/image.dart' as imageLib;
import 'file_extension.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scanner(),
      theme: new ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Scanner extends StatefulWidget {
  @override
  State createState() => new ScannerState();
}

class ScannerState extends State<Scanner> {
  File _photoId;
  bool isUploaded = false;
  imageLib.Image _image;
  String filename;
  final picker = ImagePicker();
  final pdf = pw.Document();
  final file = File("example.pdf");
  Filter _filter;
  List<Filter> filters = presetFiltersList;
  String bright = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Photo Filter Example'),
      ),
      body: new Container(
        alignment: Alignment(0.0, 0.0),
        child: _image == null
            ? new Text('No image selected.')
            : new PhotoFilterSelector(
                title: Text("Filter"),
                image: _image,
                filters: filters,
                filename: filename,
                loader: Center(child: CircularProgressIndicator()),
              ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: Center(
  //       child: Column(
  //         children: <Widget>[
  //           Visibility(
  //             visible: isUploaded,
  //             child: Center(
  //               child: _image == null
  //                   ? Text("No Image")
  //                   : new PhotoFilterSelector(
  //                       title: new Text("Add Filter"),
  //                       image: _image,
  //                       filters: filters,
  //                       filename: filename,
  //                       loader: Center(child: CircularProgressIndicator()),
  //                     ),
  //             ),
  //           ),
  //           Container(
  //               margin: EdgeInsets.only(top: 30),
  //               height: 40,
  //               child: RaisedButton(
  //                   shape: new RoundedRectangleBorder(
  //                     borderRadius: new BorderRadius.circular(5.0),
  //                   ),
  //                   child: Text(
  //                     'Get Report',
  //                     style: TextStyle(
  //                         color: Colors.white, fontWeight: FontWeight.bold),
  //                   ),
  //                   color: Colors.blue,
  //                   onPressed: () async {
  //                     String imagePath = await EdgeDetection.detectEdge;
  //                     var image = imageLib
  //                         .decodeImage(File(imagePath).readAsBytesSync());
  //                     _photoId = File(imagePath);
  //                     String name = _photoId.name;

  //                     setState(() {
  //                       _image = image;
  //                       filename = name;
  //                       isUploaded = true;
  //                     });
  //                     //reportView(context, File(imagePath));
  //                     //_optionsDialogBox();
  //                   }))
  //         ],
  //       ),
  //     ),
  //     // body: SingleChildScrollView(
  //     //   child: Center(
  //     //     child: Column(
  //     //       children: <Widget>[
  //     //         Visibility(
  //     //         visible: isUploaded,
  //     //         child: Center(
  //     //           child: _photoId == null
  //     //               ? Text("No Image")
  //     //               : Image.file(
  //     //                   _photoId,
  //     //                   width: MediaQuery.of(context).size.width * 0.66,
  //     //                   height: MediaQuery.of(context).size.height / 3,
  //     //                 ),
  //     //         ),
  //     //       ),
  //     //       const SizedBox(
  //     //         height: 16.0,
  //     //       ),
  //     //       Center(
  //     //         child: Container(
  //     //           width: MediaQuery.of(context).size.width / 3,
  //     //           child: new RaisedButton(
  //     //             padding: const EdgeInsets.all(16.0),
  //     //             textColor: Colors.white,
  //     //             color: Color(0xff696b9e),
  //     //             child: Center(child: Text('Upload')),
  //     //             onPressed: () async {
  //     //               _optionsDialogBox();
  //     //               final image = PdfImage.file(
  //     //                 pdf.document,
  //     //                 bytes: _photoId.readAsBytesSync(),
  //     //               );
  //     //               pdf.addPage(pw.Page(
  //     //                 build: (pw.Context context) {
  //     //                   return pw.Center(
  //     //                     child: pw.Image(image),
  //     //                   ); // Center
  //     //                 }));

  //     //                 await file.writeAsBytes(pdf.save());
  //     //             },
  //     //             shape: RoundedRectangleBorder(
  //     //                 borderRadius: BorderRadius.circular(16.0)),
  //     //           ),
  //     //         ),
  //     //       ),
  //     //       ],
  //     //     ),
  //     //   ),
  //     // ),
  //   );
  // }

  void getImage() async {
    String imagePath = await EdgeDetection.detectEdge;
    var image = imageLib.decodeImage(File(imagePath).readAsBytesSync());
    _photoId = File(imagePath);
    String name = _photoId.name;
    filename = name;

    setState(() {
      _image = image;
    });
    //reportView(context, File(imagePath));
    //_optionsDialogBox();
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: () {
                      openCamera();
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: () {
                      openGallery();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    var camera = await picker.getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _photoId = File(camera.path);
      if (_photoId != null) {
        isUploaded = true;
        //reportView(context, _photoId);
      }
    });
  }

  Future openGallery() async {
    var gallery = await picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _photoId = File(gallery.path);
      if (_photoId != null) isUploaded = true;
    });
  }
}
