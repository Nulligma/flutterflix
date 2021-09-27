import 'package:flutter/material.dart';

class SimpleList extends StatefulWidget {
  final List? contents;
  final List<String?> leadingTexts;
  final List<String?> titles;
  final Function onEdit;
  final VoidCallback? onAdd;
  final Function onDelete;

  const SimpleList(
      {Key? key,
      required this.contents,
      required this.leadingTexts,
      required this.titles,
      required this.onEdit,
      this.onAdd,
      required this.onDelete})
      : super(key: key);

  @override
  _SimpleListState createState() => _SimpleListState();
}

class _SimpleListState extends State<SimpleList> {
  @override
  void didUpdateWidget(SimpleList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.contents!.length != oldWidget.contents!.length) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.onAdd == null
            ? Container()
            : Container(
                width: 200,
                child: TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: Text(
                    "Add new content",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: widget.onAdd,
                ),
              ),
        SizedBox(
          height: 25,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: widget.contents!.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (ctx, index) => ListTile(
              tileColor: Colors.white,
              leading: Text(widget.leadingTexts[index]!),
              title: Text(widget.titles[index]!),
              trailing: Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.black, backgroundColor: Colors.amber),
                      child: Text("Edit"),
                      onPressed: () {
                        widget.onEdit(widget.contents![index]);
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog(
                          builder: (_) {
                            return AlertDialog(
                              content:
                                  Text("Do you want to delete this content? "),
                              actions: [
                                TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    widget.onDelete(widget.contents![index]);
                                  },
                                ),
                                TextButton(
                                  child: Text("No"),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            );
                          },
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
