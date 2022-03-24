import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:peteproj/models/quotes_model.dart';
import 'package:peteproj/utility/my_constant.dart';
import 'package:peteproj/widgets/show_progress.dart';
import 'package:peteproj/widgets/show_title.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // List<QuotesModel> aaa = [];
  var quotesModels = <QuotesModel>[];
  var indexWallpapers = <int>[];
  var pathWallpapers = <String>[];
  List<String> favorites = [];

  var globalKeys = <GlobalKey>[];
  Uint8List? captureBytes;
  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
    readDataJson();
  }

  Future<void> readDataJson() async {
    preferences = await SharedPreferences.getInstance();
    var data = preferences!.getStringList('favorite');
    print('data = $data');

    await rootBundle.loadString('assets/data.json').then((value) {
      // print('value ==>> $value');
      final result = json.decode(value);
      var listMaps = result['quotes'];
      // print('listMaps ==> $listMaps');

      if (data == null) {
        for (var item in listMaps) {
          favorites.add('false');
        }
        preferences!.setStringList('favorite', favorites);
      } else {
        favorites = data;
      }

      print('favorites ==> $favorites');

      int i = 0;
      for (var item in listMaps) {
        GlobalKey globalKey = GlobalKey();
        globalKeys.add(globalKey);

        QuotesModel model = QuotesModel.fromMap(item);
        setState(() {
          quotesModels.add(model);
          indexWallpapers.add(i);
          pathWallpapers.add('images/${model.wallpaper}');
        });
        i++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.grey,
          ),
        ),
        title: ShowTitle(
          title: 'Main Home',
          textStyle: MyConstant().h2BarStyle(),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.grey,
              ))
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(),
      body: quotesModels.isEmpty
          ? const ShowProgress()
          : LayoutBuilder(builder: (context, constrained) {
              return ListView.builder(
                itemCount: quotesModels.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    RepaintBoundary(
                      key: globalKeys[index],
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                pathWallpapers[indexWallpapers[index]]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: constrained.maxWidth * 1.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: constrained.maxWidth * 0.75,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ShowTitle(
                                    title: quotesModels[index].quote,
                                    textStyle: MyConstant().h2QuoteStyle(),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ShowTitle(
                                    title: quotesModels[index].author,
                                    textStyle: MyConstant().h3QuoteStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            print('index Click = ${indexWallpapers[index]}');

                            setState(() {
                              if (indexWallpapers[index] ==
                                  indexWallpapers.length - 1) {
                                indexWallpapers[index] = 0;
                              } else {
                                indexWallpapers[index]++;
                              }
                            });
                          },
                          icon: const Icon(Icons.image_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: quotesModels[index].quote));

                            Fluttertoast.showToast(msg: 'Copy Clipboard');
                          },
                          icon: const Icon(Icons.copy),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.filter_3),
                        ),
                        IconButton(
                          onPressed: () {
                            processSave(index);
                          },
                          icon: Icon(Icons.save),
                        ),
                        IconButton(
                          onPressed: () {
                            print('You clidk');
                            setState(() {
                              favorites[index] =
                                  changeFavorite(favorites[index]);
                            });
                            preferences!.setStringList('favorite', favorites);
                          },
                          icon: favorites[index] == 'false'
                              ? Icon(Icons.favorite_border)
                              : Icon(Icons.favorite, color: Colors.pink,),
                        ),
                      ],
                    ),
                    // captureBytes == null ? Text('No Capture') :  Image.memory(captureBytes!),
                  ],
                ),
              );
            }),
    );
  }

  Future<void> processSave(int index) async {
    RenderRepaintBoundary? boundary = globalKeys[index]
        .currentContext!
        .findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    captureBytes = byteData?.buffer.asUint8List();
    if (captureBytes == null) {
      print('Error Cannot Capture');
    } else {
      print('Capture not null');

      var result = await ImageGallerySaver.saveImage(captureBytes!);
      print('result Save ==>> ${result.toString()}');
    }
  }

  String changeFavorite(String favorit) {
    bool bolFavorite = true;
    if (favorit == 'true') {
      bolFavorite = false;
    }
    return bolFavorite.toString();
  }
}
