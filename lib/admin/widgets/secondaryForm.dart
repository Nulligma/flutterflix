import 'package:flutter/material.dart';
import 'package:flutterflix/helpers/logicHelpers.dart';

enum SecondaryFormType {
  SimpleText,
  TextList,
  ColorList,
  URL,
  Custom,
  Delete,
}

class SecondaryForm extends StatefulWidget {
  final String title;
  final SecondaryFormType type;
  final Function onConfirm;
  final dynamic initValue;
  final List? itemList;

  const SecondaryForm(
      {Key? key,
      required this.title,
      required this.type,
      required this.onConfirm,
      this.initValue,
      this.itemList})
      : super(key: key);

  @override
  _SecondaryFormState createState() => _SecondaryFormState();
}

class _SecondaryFormState extends State<SecondaryForm> {
  Color? color;
  String? text;
  Map<String, dynamic>? variableMap;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case SecondaryFormType.SimpleText:
        text = widget.initValue;
        break;
      case SecondaryFormType.TextList:
        text = widget.initValue ?? widget.itemList![0];
        break;
      case SecondaryFormType.ColorList:
        color = Color(getColorInt_fromString(widget.initValue.toString()));
        break;
      case SecondaryFormType.URL:
        break;
      case SecondaryFormType.Custom:
        variableMap = Map.from(widget.initValue.variableMap);
        break;
      case SecondaryFormType.Delete:
        break;
    }
  }

  Widget get _textForrm {
    return TextField(
      maxLines: null,
      controller: TextEditingController(text: text),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: "New Text",
        hintText: "Enter new text",
        hintStyle: const TextStyle(
          fontSize: 16.0,
        ),
      ),
      onChanged: (String val) {
        text = val;
      },
    );
  }

  Widget get _textListForm {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          value: text!,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          onChanged: (value) {
            setState(() {
              text = value;
            });
          },
          items: widget.itemList!.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget get _colorForm {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text("Current Color"),
            Spacer(),
            Container(
              width: 50,
              height: 50,
              color: color,
            )
          ],
        ),
        Divider(),
        Row(
          children: [
            Text("Select new Color"),
            Spacer(),
            DropdownButton<String>(
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              onChanged: (value) {
                setState(() {
                  color = Color(getColorInt_fromString(value!));
                });
              },
              items: widget.itemList!.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Color(getColorInt_fromString(value)),
                  ),
                );
              }).toList(),
            ),
          ],
        )
      ],
    );
  }

  Widget get _customForm {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: variableMap!.entries.map((entry) {
          String? value;
          if (entry.value == null)
            value = null;
          else
            value = entry.value.toString();

          return TextFormField(
            maxLines: null,
            initialValue: value,
            onSaved: (value) {
              var newValue;
              if (entry.value is int)
                newValue = int.parse(value!);
              else
                newValue = value;
              variableMap![entry.key] = newValue;
            },
            validator: (String? value) {
              if (value!.isEmpty) return "This is required";

              return null;
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              labelText: entry.key,
              hintText: "Enter correct value",
              hintStyle: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget get _body {
    switch (widget.type) {
      case SecondaryFormType.SimpleText:
        return _textForrm;
      case SecondaryFormType.TextList:
        return _textListForm;
      case SecondaryFormType.ColorList:
        return _colorForm;
      case SecondaryFormType.URL:
        break;
      case SecondaryFormType.Custom:
        return _customForm;
      case SecondaryFormType.Delete:
        return Text("Delete current field");
    }

    return Container();
  }

  void confirm() {
    var newVal;

    switch (widget.type) {
      case SecondaryFormType.SimpleText:
        newVal = text;
        break;
      case SecondaryFormType.TextList:
        newVal = text;
        break;
      case SecondaryFormType.ColorList:
        newVal = color.toString();
        break;
      case SecondaryFormType.URL:
        break;
      case SecondaryFormType.Custom:
        if (!_formKey.currentState!.validate()) return;
        _formKey.currentState!.save();
        newVal = variableMap;
        break;
      case SecondaryFormType.Delete:
        break;
    }

    if (widget.type == SecondaryFormType.Delete)
      widget.onConfirm();
    else
      widget.onConfirm(newVal);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: [
        TextButton(
          child: Text("Confirm"),
          onPressed: () {
            confirm();
          },
        ),
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      content: _body,
    );
  }
}
