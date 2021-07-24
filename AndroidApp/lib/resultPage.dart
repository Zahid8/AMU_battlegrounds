import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';


class ResultPage extends StatefulWidget {
  const ResultPage({Key ?key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  File ? _image;
  Future<List> ? _recognitions;
  final ImagePicker _picker = ImagePicker();
  Future predictImagePicker() async {

    var image = await _picker.pickImage(source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 180,
        maxWidth: 180,
    );

    if (image == null)  {
      _image=null;
      return;
    }
      _image=File(image.path);
      _recognitions=predictImage(File(image.path));
    }

  @override
  void initState() {
    super.initState();
    loadModel().then((val) {
      // setState(() {
      // });
    });
    predictImagePicker().then((value) {
      // setState(() {
      // });
    });
  }

  Future loadModel() async {
    String? res = await Tflite.loadModel(
        model: "assets/resnet_tumor_model.tflite",
        labels: "assets/labels.txt",
        // numThreads: 1, // defaults to 1
        // isAsset: true, // defaults to true, set to false to load resources outside assets
        // useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
    print(res);
  }
  Future <List> predictImage(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      // model: "tumor",
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 4,
      asynch: true,
    );
    
    // setState(() {
    //   
    //   });

    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
    print(recognitions);
    return Future.value(recognitions);
  }

  @override
  Widget build(BuildContext context) {
    if(_image==null){
      return Center(child: Column(
          children: [
            Expanded(
              child: Center(
                child:  Image.asset('assets/image_not_selected.jpg'),
              ),
            ),
          ]
      ),
      );
    }
        return FutureBuilder(
        future: _recognitions,
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.done) {
            if (snapshot.hasData) {
              List value=snapshot.data as List;
              if(value[0]['label']=='no_tumor'){
                return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child:  Image.asset('assets/no_tumor.jpg'),
                        ),
                      ),
                    ]
                );
              }else{
                return Column(
                    children: [
                      Expanded(
                        child: Center(
                          child:  Image.asset('assets/tumor_found.jpg'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 25.0),
                        child: Center(
                          child: Text("${value[0]['label']} found!!",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xff2b2525),
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                      ),
                    ]
                );
              }
            }
            return Column(
                children: [
                  Expanded(
                    child: Center(
                      child:  Image.asset('assets/image_not_found.jpg'),
                    ),
                  ),
                ]
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),

              ),
              Text("Trying to process the imaage"),
            ],
          );
        },
    );
  }
}
