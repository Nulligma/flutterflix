import 'package:flutter/material.dart';

class SimpleList extends StatefulWidget {
  final List contents;
  final List<String> leadingTexts;
  final List<String> titles;
  final Function onEdit;
  final Function onAdd;
  final Function onDelete;

  const SimpleList(
      {Key key,
      this.contents,
      this.leadingTexts,
      this.titles,
      this.onEdit,
      this.onAdd,
      this.onDelete})
      : super(key: key);

  @override
  _SimpleListState createState() => _SimpleListState();
}

class _SimpleListState extends State<SimpleList> {
  @override
  void didUpdateWidget(SimpleList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.contents.length != oldWidget.contents.length) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.onAdd == null
            ? Container()
            : Container(
                width: 200,
                color: Colors.red,
                child: FlatButton(
                  child: Text(
                    "Add new content",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: widget.onAdd,
                  color: Colors.deepPurple,
                ),
              ),
        SizedBox(
          height: 25,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: widget.contents.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (ctx, index) => ListTile(
              tileColor: Colors.white,
              leading: Text(widget.leadingTexts[index]),
              title: Text(widget.titles[index]),
              trailing: Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      child: Text("Edit"),
                      onPressed: () {
                        widget.onEdit(widget.contents[index]);
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
                            child: AlertDialog(
                              content:
                                  Text("Do you want to delete this content? "),
                              actions: [
                                FlatButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    widget.onDelete(widget.contents[index]);
                                  },
                                ),
                                FlatButton(
                                  child: Text("No"),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            ));
                      },
                      color: Colors.red,
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
