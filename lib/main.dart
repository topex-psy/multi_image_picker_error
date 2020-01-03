import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MAX_IMAGE_SELECT = 3;
  var _images = <Asset>[];

  _pickImages() async {
    var resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: MAX_IMAGE_SELECT, enableCamera: true);
    } on Exception catch (e) {
      print("PICK IMAGES ERROOOOOOOOOOOOOOOOOR: $e");
    }
    if (mounted)
      setState(() {
        _images = resultList;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: MAX_IMAGE_SELECT,
          children: _images.map((asset) {
            return Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _images.remove(asset);
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 22,
                      )),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImages,
        tooltip: 'Select Photos',
        child: Icon(Icons.camera),
      ),
    );
  }
}
