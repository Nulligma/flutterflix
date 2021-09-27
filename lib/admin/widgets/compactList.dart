import 'package:flutter/material.dart';
import 'package:flutterflix/admin/widgets/secondaryForm.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/models/contentModel.dart';

class CompactList extends StatelessWidget {
  final String heading;
  final Color? backColor;
  final Color headColor;
  final List<String?> contentNames;
  final Function onDelete;
  final Function onAdd;

  const CompactList(
      {Key? key,
      required this.heading,
      required this.backColor,
      required this.headColor,
      required this.contentNames,
      required this.onDelete,
      required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backColor,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: headColor, boxShadow: [BoxShadow(color: Colors.black)]),
            width: double.infinity,
            height: 50,
            child: Center(
                child: Text(
              heading,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            )),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: contentNames.length,
                itemBuilder: (BuildContext ctx, int index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(contentNames[index]!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                builder: (context) => SecondaryForm(
                                      onConfirm: () {
                                        onDelete(index);
                                      },
                                      title: "Are you sure?",
                                      type: SecondaryFormType.Delete,
                                    ),
                                context: context);
                          },
                        ),
                      ),
                    )),
          ),
          Container(
              height: 30,
              color: headColor,
              child: TextButton(
                child: Center(
                  child: Text("Add", style: TextStyle(color: Colors.white)),
                ),
                onPressed: () {
                  showDialog(
                      builder: (context) => SecondaryForm(
                            onConfirm: onAdd,
                            itemList: Cloud.allContent!
                                .map((Content val) => val.name)
                                .toList(),
                            title: "Add new value",
                            type: SecondaryFormType.TextList,
                          ),
                      context: context);
                },
              ))
        ],
      ),
    );
  }
}
