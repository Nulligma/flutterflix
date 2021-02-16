import 'package:flutter/material.dart';
import 'package:flutterflix/admin/adminPanel.dart';

class NavBar extends StatelessWidget {
  final Function changeTab;

  void removeSearchFocus(context) {
    FocusScope.of(context).unfocus();
  }

  const NavBar({Key key, this.changeTab}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [BoxShadow(color: Colors.black)]),
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VerticalDivider(),
          Container(
            width: 75,
            height: 75,
            child: FlatButton(
              child: Icon(Icons.search),
              onPressed: () {
                changeTab(AdminTab.SEARCH);
              },
            ),
          ),
          VerticalDivider(),
          Container(
            width: 75,
            height: 75,
            child: FlatButton(
              child: Icon(Icons.notifications),
              onPressed: () {
                changeTab(AdminTab.NOTIFICATION);
              },
            ),
          ),
          VerticalDivider(),
          Container(
            width: 75,
            height: 75,
            child: FlatButton(
              child: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
