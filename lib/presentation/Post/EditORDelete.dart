import 'dart:convert';
import 'dart:io';

import 'package:central_borssa/business_logic/Company/bloc/company_bloc.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_event.dart';
import 'package:central_borssa/business_logic/Company/bloc/company_state.dart';
import 'package:central_borssa/presentation/Home/Company_Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import 'package:central_borssa/business_logic/Post/bloc/post_bloc.dart';
import 'package:central_borssa/constants/string.dart';

class EditORDelete extends StatefulWidget {
  final String? body;
  final String image;
  final int id;
  final String type;
  const EditORDelete({
    Key? key,
    required this.body,
    required this.image,
    required this.type,
    required this.id,
  }) : super(key: key);
  EditORDeletePostPage createState() => EditORDeletePostPage();
}

class EditORDeletePostPage extends State<EditORDelete> {
  final ImagePicker _picker = ImagePicker();
  final postTextInpput = TextEditingController();
  late final String postValue;
  late PostBloc _postBloc;
  late CompanyBloc _CompanyBloc;

  late String base64Image;
  late String encodeImage = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? mainFile;

  Future chooseFile() async {
    setState(() async {
      final postFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        mainFile = File(postFile!.path);
      });

      String baseimage = base64Encode(mainFile!.readAsBytesSync());
      print(baseimage);
      String extension = p.extension(postFile!.path);
      String extensionWithoutDot = extension.substring(1);

      String someWorld = 'data:image/$extensionWithoutDot;base64,';
      setState(() {
        mainFile = File(postFile.path);
        encodeImage = '$someWorld$baseimage';
        print(encodeImage);
      });
    });
  }

  Future clearFile() async {
    setState(() {
      mainFile = null;
      encodeImage = "";
    });
  }

  @override
  void initState() {
    _postBloc = BlocProvider.of<PostBloc>(context);
    _CompanyBloc = BlocProvider.of<CompanyBloc>(context);
    postTextInpput.text = widget.body!;
    encodeImage = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Center(),
          backgroundColor: Color(navbar.hashCode),
        ),
        body: BlocListener<CompanyBloc, CompanyState>(
          listener: (context, state) {
            if (state is DeletePostLoaded) {
              print(state);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('???? ?????????? ??????????'),
                  action: SnackBarAction(
                    label: '??????????',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return CompanyProfile();
              }));
            }
            if (state is DeletePostError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('???????????? ???????????? ???? ?????? ?????????????????? ??????????????'),
                  action: SnackBarAction(
                    label: '?????? ???? ??????????????????',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            } else if (state is DeletePostLoading) {
              // Future.delayed(const Duration(seconds: 2000), () {
              //   showDialog(
              //       context: context,
              //       builder: (context) {
              //         return Center(child: CircularProgressIndicator());
              //       });
              // });
            } else if (state is EditPostLoaded) {
              print(state);
              print('state of edit');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('???? ?????????????? ??????????'),
                  action: SnackBarAction(
                    label: '??????????',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
                return CompanyProfile();
              }));
            }
            if (state is EditPostError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('???????????? ???????????? ???? ?????? ?????????????????? ??????????????'),
                  action: SnackBarAction(
                    label: '?????? ???? ??????????????????',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            } else if (state is EditPostLoading) {
              // Future.delayed(const Duration(seconds: 2000), () {
              //   showDialog(
              //       context: context,
              //       builder: (context) {
              //         return Center(child: CircularProgressIndicator());
              //       });
              // });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(
                      top: 40.0, left: 10.0, right: 10.0, bottom: 10.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                top: 25.0,
                                left: 15.0,
                                right: 15.0,
                                bottom: 20.0),
                            child: new Theme(
                                data: new ThemeData(
                                    primaryColor: Colors.red,
                                    primaryColorDark: Colors.red,
                                    focusColor: Colors.red),
                                child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      maxLines: null,
                                      cursorColor: Colors.black,
                                      controller: postTextInpput,
                                      maxLength: 512,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(color: Colors.black),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return '???????????? ?????????? ?????????????? ????????????';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        postValue = value ?? "";
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(0, 0, 40, 35),
                                        labelText: '??????????????',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        fillColor: Colors.red,
                                        border: OutlineInputBorder(),
                                        enabledBorder: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Color(navbar.hashCode))),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3,
                                              color: Color(navbar.hashCode)),
                                        ),
                                      ),
                                    )))),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 20.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(navbar.hashCode)),
                                          onPressed: () {
                                            chooseFile();
                                          },
                                          child: Text("?????????? ????????"),
                                        ),
                                      ),
                                      Spacer(),
                                      mainFile != null || encodeImage != ""
                                          ? Container(
                                              height: 50,
                                              width: 50,
                                              margin: const EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 0.0,
                                                  right: 10.0),
                                              child: new IconButton(
                                                icon: new Icon(
                                                    Icons.delete_forever),
                                                highlightColor: Colors.grey,
                                                onPressed: () {
                                                  clearFile();
                                                },
                                              ),
                                            )
                                          : Container(),
                                      Container(
                                        height: 125,
                                        width: 125,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, left: 0.0, right: 20.0),
                                        child: mainFile == null
                                            ? Card(
                                                child: encodeImage == ""
                                                    ? Icon(Icons
                                                        .camera_alt_rounded)
                                                    : Image.network(
                                                        (encodeImage)))
                                            : Card(
                                                child: mainFile == null
                                                    ? Icon(Icons
                                                        .camera_alt_rounded)
                                                    : Image.file(
                                                        File(mainFile!.path))),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (widget.type == "?????? ??????????????") {
                                print(widget.id);
                                _CompanyBloc.add(DeletePost(
                                  id: widget.id,
                                ));
                              } else if (widget.type == "?????????? ??????????????") {
                                print('edit post');
                                if (encodeImage != "") {
                                  _CompanyBloc.add(UpdatePost(
                                    body: postTextInpput.text,
                                    image: encodeImage,
                                    id: widget.id,
                                  ));
                                }
                                if (encodeImage == "") {
                                  print(encodeImage);
                                  _CompanyBloc.add(UpdatePost(
                                    body: postTextInpput.text,
                                    image: encodeImage,
                                    id: widget.id,
                                  ));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Color(navbar.hashCode)),
                            child: Text(widget.type),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
