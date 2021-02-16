import 'package:flutter/material.dart';
import 'package:flutterflix/admin/widgets/SecondaryForm.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/database/firestoreFields.dart';
import 'package:flutterflix/helpers/logicHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/models/episodeModel.dart';
import 'package:flutterflix/models/trailerModel.dart';
import 'package:flutterflix/sampleData/localdata.dart';
import 'package:flutterflix/screens/homeScreen.dart';

class ContentForm extends StatefulWidget {
  final Content content;
  final Function onCancel;

  ContentForm({Key key, @required this.content, @required this.onCancel})
      : super(key: key);

  @override
  _ContentFormState createState() => _ContentFormState();
}

class _ContentFormState extends State<ContentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  void upload() {
    setState(() {
      isLoading = true;
    });

    Cloud.uploadContent(widget.content).then((_) {
      setState(() {
        isLoading = false;
      });
      widget.onCancel();
    });
  }

  void addNewSeason(String seasonName) {
    setState(() {
      widget.content.seasons.add(seasonName);
    });
  }

  void colorEdit(String colorVal) {
    setState(() {
      widget.content.color = new Color(getColorInt_fromString(colorVal));
    });
    widget.content.variableMap["color"] = colorVal;
  }

  void castEdit(String val, int index) {
    setState(() {
      widget.content.cast[index] = val;
    });
  }

  void castCreate(String val) {
    setState(() {
      widget.content.cast.add(val);
    });
  }

  void castDelete(int index) {
    setState(() {
      widget.content.cast.removeAt(index);
    });
  }

  void genresEdit(String val, int index) {
    setState(() {
      widget.content.genres[index] = val;
    });
  }

  void genresCreate(String val) {
    setState(() {
      widget.content.genres.add(val);
    });
  }

  void genresDelete(int index) {
    setState(() {
      widget.content.genres.removeAt(index);
    });
  }

  void trailersEdit(Map<String, dynamic> val, int index) {
    setState(() {
      widget.content.trailers[index] = Trailer.fromMap(val);
    });
  }

  void trailersCreate(Map<String, dynamic> val) {
    setState(() {
      widget.content.trailers.add(Trailer.fromMap(val));
    });
  }

  void trailersDelete(int index) {
    setState(() {
      widget.content.trailers.removeAt(index);
    });
  }

  void episodesEdit(Map<String, dynamic> val, int index) {
    setState(() {
      widget.content.episodes[index] = Episode.fromMap(val);
    });
  }

  void episodesCreate(Map<String, dynamic> val) {
    setState(() {
      widget.content.episodes.add(Episode.fromMap(val));
    });
  }

  void episodesDelete(int index) {
    setState(() {
      widget.content.episodes.removeAt(index);
    });
  }

  void saveAndUpload() {
    _formKey.currentState.save();
    widget.content.name = widget.content.variableMap["name"];
    widget.content.imageUrl = widget.content.variableMap["imageUrl"];
    widget.content.imageUrlLandscape =
        widget.content.variableMap["imageUrlLandscape"];
    widget.content.poster = widget.content.variableMap["poster"];
    widget.content.titleImageUrl = widget.content.variableMap["titleImageUrl"];
    widget.content.videoUrl = widget.content.variableMap["videoUrl"];
    widget.content.previewVideo = widget.content.variableMap["previewVideo"];
    widget.content.description = widget.content.variableMap["description"];
    widget.content.percentMatch = widget.content.variableMap["percentMatch"];
    widget.content.year = widget.content.variableMap["year"];
    widget.content.rating = widget.content.variableMap["rating"];
    widget.content.duration = widget.content.variableMap["duration"];
    upload();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> urls = {
      "imageUrl": widget.content?.imageUrl,
      "imageUrlLandscape": widget.content?.imageUrlLandscape,
      "poster": widget.content?.poster,
      "titleImageUrl": widget.content?.titleImageUrl,
      "videoUrl": widget.content?.videoUrl,
      "previewVideo": widget.content?.previewVideo
    };
    Map<String, String> metaData = {
      "percentMatch": widget.content.percentMatch == null
          ? null
          : widget.content.percentMatch.toString(),
      "year":
          widget.content.year == null ? null : widget.content.year.toString(),
      "rating": widget.content.rating == null
          ? null
          : widget.content.rating.toString(),
      "duration": widget.content.duration == null
          ? null
          : widget.content.duration.toString(),
    };

    if (isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    else
      return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 3,
                      child: _InputField(
                        initialValue: widget.content?.id,
                        labelText: "ID",
                        hintText: "Enter id",
                        onSave: (String val) {
                          widget.content.id = val;
                        },
                      )),
                  Spacer(),
                  Flexible(
                    flex: 3,
                    child: InkWell(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        color: widget.content == null
                            ? Colors.white
                            : widget.content.color,
                        child: Center(
                            child: Text("Color",
                                style: TextStyle(
                                    backgroundColor: Colors.black,
                                    color: Colors.white))),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            child: SecondaryForm(
                              onConfirm: colorEdit,
                              itemList: colors,
                              initValue: widget.content == null
                                  ? Colors.white
                                  : widget.content.color,
                              title: "Change color",
                              type: SecondaryFormType.ColorList,
                            ));
                      },
                    ),
                  ),
                  Spacer(),
                  Flexible(
                      flex: 6,
                      child: _InputField(
                        initialValue: widget.content?.name,
                        labelText: "Name",
                        hintText: "Enter name",
                        onSave: (String val) {
                          widget.content.variableMap['name'] = val;
                        },
                      )),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: _InputField(
                  initialValue: widget.content?.description,
                  labelText: "Description",
                  hintText: "Enter description",
                  onSave: (String val) {
                    widget.content.variableMap['description'] = val;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text("URLs:"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: Column(
                    children: urls.entries
                        .map((url) => _InputField(
                            initialValue: url.value,
                            labelText: url.key,
                            onSave: (String val) {
                              widget.content.variableMap[url.key] = val;
                            },
                            hintText: "Enter Url"))
                        .toList()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text("MetaData:"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: Column(
                    children: metaData.entries
                        .map((data) => _InputField(
                            onSave: (String val) {
                              widget.content.variableMap[data.key] =
                                  int.parse(val);
                            },
                            initialValue: data.value,
                            labelText: data.key,
                            hintText: "Enter Value"))
                        .toList()),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: _ExpandedListView(
                  title: "Cast",
                  objects: widget.content?.cast,
                  onCreate: castCreate,
                  onDelete: castDelete,
                  onEdit: castEdit,
                  secondaryFormType: SecondaryFormType.SimpleText,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: _ExpandedListView(
                  title: "Genre",
                  objects: widget.content?.genres,
                  onCreate: genresCreate,
                  onDelete: genresDelete,
                  onEdit: genresEdit,
                  secondaryFormType: SecondaryFormType.TextList,
                  selectionList: genres,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 25.0),
                child: _ExpandedListView(
                  title: "Trailer",
                  objects: widget.content?.trailers,
                  onCreate: trailersCreate,
                  onDelete: trailersDelete,
                  onEdit: trailersEdit,
                  customClassFormat: Trailer(null, null, null),
                  secondaryFormType: SecondaryFormType.Custom,
                ),
              ),
              if (widget.content.category == ContentCategory.TV_SHOW)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text("Seasons:"),
                    ),
                    if (widget.content != null &&
                        widget.content.seasons != null)
                      Column(
                        children: List.generate(widget.content.seasons.length,
                            (seasonIndex) {
                          return _ExpandedListView(
                            title: widget.content.seasons[seasonIndex],
                            objects: widget.content?.episodes,
                            onCreate: episodesCreate,
                            onDelete: episodesDelete,
                            onEdit: episodesEdit,
                            customClassFormat: Episode(
                                number: 0,
                                duration: 0,
                                name: null,
                                seasonName: widget.content.seasons[seasonIndex],
                                imageUrl: null,
                                videoUrl: null,
                                summary: null),
                            secondaryFormType: SecondaryFormType.Custom,
                          );
                        }),
                      ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                              context: context,
                              child: SecondaryForm(
                                onConfirm: addNewSeason,
                                title: "Create new Season",
                                type: SecondaryFormType.SimpleText,
                              ));
                        },
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    width: 200,
                    height: 30,
                    child: FlatButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: widget.onCancel,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    width: 200,
                    height: 30,
                    child: FlatButton(
                      child: Text(
                        "Upload",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate())
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text("Upload content"),
                                content: Text(
                                    "Are you sure you want to upload?This will overwrite content with same id"),
                                actions: [
                                  FlatButton(
                                    child: Text("Confirm"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      saveAndUpload();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                      },
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
  }
}

class _InputField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final String hintText;
  final Function onSave;

  const _InputField(
      {Key key, this.labelText, this.initialValue, this.hintText, this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (String s) {
        if (s.isEmpty)
          return "This is required";
        else
          return null;
      },
      onSaved: onSave,
      maxLines: null,
      initialValue: initialValue,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class _ExpandedListView extends StatelessWidget {
  final SecondaryFormType secondaryFormType;
  final String title;
  final List objects;
  final List selectionList;
  final Function onEdit;
  final Function onCreate;
  final Function onDelete;
  final dynamic customClassFormat;

  const _ExpandedListView(
      {Key key,
      this.secondaryFormType,
      this.title,
      this.objects,
      this.selectionList,
      this.customClassFormat,
      this.onEdit,
      this.onCreate,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        backgroundColor: Colors.white,
        title: Text(title),
        children: [
          if (objects != null)
            Column(
              children: List.generate(objects.length, (index) {
                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(objects[index] is String
                      ? objects[index]
                      : objects[index].name),
                  trailing: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                child: SecondaryForm(
                                  initValue: objects[index],
                                  itemList: selectionList,
                                  onConfirm: (value) {
                                    onEdit(value, index);
                                  },
                                  title: "Edit",
                                  type: secondaryFormType,
                                ));
                          },
                          color: Colors.amber,
                        ),
                        FlatButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                child: SecondaryForm(
                                  onConfirm: () {
                                    onDelete(index);
                                  },
                                  title: "Are you sure?",
                                  type: SecondaryFormType.Delete,
                                ));
                          },
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )
          else
            Container(),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            width: 200,
            child: FlatButton(
              child: Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    child: SecondaryForm(
                      onConfirm: onCreate,
                      itemList: selectionList,
                      initValue: customClassFormat,
                      title: "Add new object to $title",
                      type: secondaryFormType,
                    ));
              },
              color: Colors.teal,
            ),
          )
        ]);
  }
}
