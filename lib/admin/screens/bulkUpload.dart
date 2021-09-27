import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/database/firestoreFields.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/sampleData/localdata.dart';

class BulkUpload extends StatefulWidget {
  final Function onEdit;

  const BulkUpload({Key? key, required this.onEdit}) : super(key: key);
  @override
  _BulkUploadState createState() => _BulkUploadState();
}

class _BulkUploadState extends State<BulkUpload> {
  late bool uploadAll;
  @override
  void initState() {
    super.initState();
    uploadAll = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          color: Colors.red,
          child: uploadAll
              ? Container()
              : TextButton(
                  child: Text(
                    "Upload All",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content:
                                Text("Do you want to upload all the content?"),
                            actions: [
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  uploadAll = true;
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                              ),
                              TextButton(
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          );
                        });
                  },
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.deepPurple),
                ),
        ),
        SizedBox(
          height: 25,
        ),
        Expanded(
          child: ListView.separated(
              itemCount: allContent.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (context, index) {
                return _UploadItem(
                  index: index + 1,
                  content: allContent[index],
                  autoUpload: uploadAll,
                  onEdit: widget.onEdit,
                );
              }),
        ),
      ],
    );
  }
}

enum UploadState {
  Not_Uploaded,
  Uploading,
  Uploaded,
}

class _UploadItem extends StatefulWidget {
  final Content content;
  final int index;
  final bool autoUpload;
  final Function onEdit;

  const _UploadItem(
      {Key? key,
      required this.content,
      required this.index,
      required this.autoUpload,
      required this.onEdit})
      : super(key: key);

  @override
  __UploadItemState createState() => __UploadItemState();
}

class __UploadItemState extends State<_UploadItem> {
  late UploadState state;

  @override
  void initState() {
    super.initState();

    state = UploadState.Uploading;

    setUploadState();
  }

  @override
  void didUpdateWidget(_UploadItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool autoUploadEnabled = !oldWidget.autoUpload && widget.autoUpload;

    if (autoUploadEnabled && state == UploadState.Not_Uploaded) {
      upload();
    }
  }

  void setUploadState() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection(FirestoreFields.CONTENT_COLLECTION)
        .doc(widget.content.id)
        .get();

    if (doc.exists) {
      setState(() {
        state = UploadState.Uploaded;
      });
    } else
      setState(() {
        state = UploadState.Not_Uploaded;
      });
  }

  void upload() {
    setState(() {
      state = UploadState.Uploading;
    });

    Cloud.uploadContent(widget.content).then((_) {
      setState(() {
        state = UploadState.Uploaded;
      });
    });
  }

  Widget get trailingWidget {
    switch (state) {
      case UploadState.Not_Uploaded:
        return Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showDialog(
                      builder: (context) => AlertDialog(
                            content:
                                Text("Do you want to upload this content?"),
                            actions: [
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  upload();
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("No"),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          ),
                      context: context);
                },
                style: TextButton.styleFrom(backgroundColor: Colors.deepPurple),
              ),
              TextButton(
                child: Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  widget.onEdit(widget.content);
                },
                style: TextButton.styleFrom(backgroundColor: Colors.amber),
              ),
            ],
          ),
        );
      case UploadState.Uploading:
        return Container(
          child: Center(child: const CircularProgressIndicator()),
          width: 200,
          height: 30,
        );
      case UploadState.Uploaded:
        return Container(
          width: 200,
          child: Center(
            child: Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      leading: Text(widget.index.toString() + " : " + widget.content.id!),
      title: Text(widget.content.name!),
      trailing: trailingWidget,
    );
  }
}
