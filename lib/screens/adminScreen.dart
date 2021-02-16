/* import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return _AdminDesktop();
  }
}

enum CurrentPage { HOME, MOVIES, TV, BULK_UPLOAD }

class _AdminDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.grey[100],
        child: Row(
          children: [
            _SideMenuDesktop(
              currentPage: CurrentPage.HOME,
              onTap: () {},
            ),
            Expanded(
              child: Column(
                children: [
                  _NavBar(),
                  Text(
                    "Dummy",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AdminMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class _NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [BoxShadow(color: Colors.black)]),
      height: 75,
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          SizedBox(
            width: 200,
            child: TextField(
              onChanged: (_) {},
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurpleAccent),
                ),
                hintText: 'Search here',
                hintStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
              autofocus: false,
            ),
          ),
          Spacer(),
          VerticalDivider(),
          Container(
            width: 75,
            height: 75,
            child: FlatButton(
              child: Icon(Icons.mail),
              onPressed: () {},
            ),
          ),
          VerticalDivider(),
          Container(
            width: 75,
            height: 75,
            child: FlatButton(
              child: Icon(Icons.notification_important),
              onPressed: () {},
            ),
          ),
          VerticalDivider(),
          Container(
            width: 75,
            height: 75,
            child: FlatButton(
              child: Icon(Icons.account_box),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _SideMenuDesktop extends StatelessWidget {
  final CurrentPage currentPage;
  final Function onTap;

  const _SideMenuDesktop({Key key, this.currentPage, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      width: 250,
      child: Column(
        children: [
          Container(
            height: 75,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple[400],
                  boxShadow: [BoxShadow(color: Colors.black)]),
              child: Row(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    color: Colors.white,
                    child: FlatButton(
                      child: Icon(Icons.menu),
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "ADMIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Panel",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 5),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          _SideMenuItem(
            icon: Icons.dashboard,
            text: 'Dashboard',
            active: currentPage == CurrentPage.HOME,
            onTap: onTap,
          ),
          _SideMenuItem(
            icon: Icons.movie,
            text: 'Movies',
            active: currentPage == CurrentPage.MOVIES,
            onTap: onTap,
          ),
          _SideMenuItem(
            icon: Icons.tv,
            text: 'TV shows',
            active: currentPage == CurrentPage.TV,
            onTap: onTap,
          ),
          _SideMenuItem(
            icon: Icons.upload_file,
            text: 'Bulk upload',
            active: currentPage == CurrentPage.BULK_UPLOAD,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}


 */
