import 'package:flutter/material.dart';
import 'package:flutterflix/admin/screens/bulkUpload.dart';
import 'package:flutterflix/admin/screens/searchScreen.dart';
import 'package:flutterflix/admin/screens/contentForm.dart';
import 'package:flutterflix/admin/screens/dashboard.dart';
import 'package:flutterflix/admin/widgets/navBar.dart';
import 'package:flutterflix/admin/widgets/secondaryForm.dart';
import 'package:flutterflix/admin/widgets/simpleList.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/helpers/logicHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/models/notificationModel.dart';
import 'package:flutterflix/screens/screens.dart';
import 'package:flutterflix/widgets/responsive.dart';

enum AdminTab {
  DASHBOARD,
  MOVIES,
  TV,
  BULK_UPLOAD,
  NOTIFICATION,
  SEARCH,
  CONTENT_FORM,
}

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  AdminTab currentTab;
  Content content;

  @override
  void initState() {
    super.initState();

    currentTab = AdminTab.DASHBOARD;
  }

  void changeTab(AdminTab newTab) {
    setState(() {
      currentTab = newTab;
    });
  }

  void openContentForm(Content contentData) {
    setState(() {
      currentTab = AdminTab.CONTENT_FORM;
      content = contentData;
    });
  }

  void editNotification(NotificationData n, Map newVal) async {
    Cloud.notificationList[Cloud.notificationList.indexOf(n)] =
        NotificationData.fromMap(newVal);
    await Cloud.updateNotification();
    setState(() {});
  }

  void addNotification(Map newVal) async {
    Cloud.notificationList.add(NotificationData.fromMap(newVal));
    await Cloud.updateNotification();
    setState(() {});
  }

  void deleteContent(Content c) {
    if (Cloud.featureHome == c ||
        Cloud.featureMovie == c ||
        Cloud.featureTv == c) {
      showDialog(
          context: context,
          child: AlertDialog(
            content: Text("Cannot delete a featured content"),
          ));

      return;
    }

    Cloud.deleteContent(c).then((_) {
      setState(() {});
    });
  }

  Widget tab(BuildContext ctx) {
    switch (currentTab) {
      case AdminTab.DASHBOARD:
        return Dashboard(
          onCreateContent: openContentForm,
        );
      case AdminTab.MOVIES:
        return SimpleList(
          contents: Cloud.allContent
              .where((el) => el.category == ContentCategory.MOVIES)
              .toList(),
          leadingTexts: Cloud.allContent
              .expand((Content c) =>
                  [if (c.category == ContentCategory.MOVIES) c.id])
              .toList(),
          titles: Cloud.allContent
              .expand((Content c) =>
                  [if (c.category == ContentCategory.MOVIES) c.name])
              .toList(),
          onEdit: openContentForm,
          onAdd: () {
            openContentForm(Content.blank(ContentCategory.MOVIES));
          },
          onDelete: deleteContent,
        );
      case AdminTab.TV:
        return SimpleList(
            contents: Cloud.allContent
                .where((el) => el.category == ContentCategory.TV_SHOW)
                .toList(),
            leadingTexts: Cloud.allContent
                .expand((Content c) =>
                    [if (c.category == ContentCategory.TV_SHOW) c.id])
                .toList(),
            titles: Cloud.allContent
                .expand((Content c) =>
                    [if (c.category == ContentCategory.TV_SHOW) c.name])
                .toList(),
            onEdit: openContentForm,
            onAdd: () {
              openContentForm(Content.blank(ContentCategory.TV_SHOW));
            },
            onDelete: deleteContent);
      case AdminTab.BULK_UPLOAD:
        return BulkUpload(
          onEdit: openContentForm,
        );
      case AdminTab.SEARCH:
        return SearchScreen(
          onEdit: openContentForm,
          onDelete: deleteContent,
        );
      case AdminTab.CONTENT_FORM:
        return ContentForm(
          content: content,
          onCancel: () {
            changeTab(AdminTab.DASHBOARD);
          },
        );
      case AdminTab.NOTIFICATION:
        return SimpleList(
          contents: Cloud.notificationList,
          leadingTexts:
              Cloud.notificationList.map((NotificationData n) => n.id).toList(),
          titles: Cloud.notificationList
              .map((NotificationData n) => n.contentId + "--" + n.title)
              .toList(),
          onEdit: (var n) {
            showDialog(
                context: ctx,
                child: SecondaryForm(
                  onConfirm: (Map newVal) => editNotification(n, newVal),
                  initValue: n,
                  title: "Edit notification",
                  type: SecondaryFormType.Custom,
                ));
          },
          onAdd: () {
            showDialog(
                context: ctx,
                child: SecondaryForm(
                  onConfirm: addNotification,
                  initValue: NotificationData(null, null, null),
                  title: "Add new notification",
                  type: SecondaryFormType.Custom,
                ));
          },
          onDelete: (var n) async {
            Cloud.notificationList.remove(n);
            await Cloud.updateNotification();
            setState(() {});
          },
        );
        break;
    }
    return Container();
  }

  Future<bool> willPop() async {
    if (currentTab != AdminTab.DASHBOARD) changeTab(AdminTab.DASHBOARD);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Theme(
        data: ThemeData(primaryColor: Colors.deepPurple),
        child: Responsive(
          desktop: _DesktopUI(
            onTabChange: changeTab,
            currentTab: currentTab,
            editSearchContent: openContentForm,
            deleteSearchContent: deleteContent,
            tabWidget: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: tab(context),
            ),
          ),
          mobile: _MobileUI(
            onTabChange: changeTab,
            currentTab: currentTab,
            tabWidget: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: tab(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopUI extends StatelessWidget {
  final Function onTabChange;
  final Widget tabWidget;
  final AdminTab currentTab;
  final Function editSearchContent;
  final Function deleteSearchContent;

  const _DesktopUI(
      {Key key,
      this.onTabChange,
      this.tabWidget,
      this.currentTab,
      this.editSearchContent,
      this.deleteSearchContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.grey[100],
        child: Row(
          children: [
            SideMenuDesktop(
              currentTab: currentTab,
              onTap: onTabChange,
            ),
            Expanded(
              child: Column(
                children: [
                  NavBar(
                    changeTab: onTabChange,
                  ),
                  Expanded(child: tabWidget)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MobileUI extends StatelessWidget {
  final Function onTabChange;
  final Widget tabWidget;
  final AdminTab currentTab;

  const _MobileUI({Key key, this.onTabChange, this.tabWidget, this.currentTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: Container(
            color: Colors.deepPurple,
            child: _SideMenuMobile(
              currentTab: currentTab,
              changeTab: onTabChange,
            )),
      ),
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              onTabChange(AdminTab.NOTIFICATION);
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              onTabChange(AdminTab.SEARCH);
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        title: Center(
          child: Text(
            "Admin Panel",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: tabWidget,
    );
  }
}

class SideMenuDesktop extends StatefulWidget {
  final AdminTab currentTab;
  final Function onTap;

  const SideMenuDesktop({Key key, this.currentTab, this.onTap})
      : super(key: key);

  @override
  _SideMenuDesktopState createState() => _SideMenuDesktopState();
}

class _SideMenuDesktopState extends State<SideMenuDesktop> {
  bool collapsedMenu = false;

  void changeMenu() {
    setState(() {
      collapsedMenu = !collapsedMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: collapsedMenu ? Colors.white : Colors.deepPurple,
      width: collapsedMenu ? 75 : 250,
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
                    color:
                        collapsedMenu ? Colors.deepPurple[400] : Colors.white,
                    child: FlatButton(
                      child: Icon(Icons.menu,
                          color: collapsedMenu ? Colors.white : Colors.black),
                      onPressed: changeMenu,
                    ),
                  ),
                  collapsedMenu
                      ? Container()
                      : Expanded(
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
            active: widget.currentTab == AdminTab.DASHBOARD,
            onTap: () {
              widget.onTap(AdminTab.DASHBOARD);
            },
            collapsed: collapsedMenu,
          ),
          _SideMenuItem(
            icon: Icons.movie_creation_outlined,
            text: 'Movies',
            active: widget.currentTab == AdminTab.MOVIES,
            onTap: () {
              widget.onTap(AdminTab.MOVIES);
            },
            collapsed: collapsedMenu,
          ),
          _SideMenuItem(
            icon: Icons.tv,
            text: 'TV shows',
            active: widget.currentTab == AdminTab.TV,
            onTap: () {
              widget.onTap(AdminTab.TV);
            },
            collapsed: collapsedMenu,
          ),
          _SideMenuItem(
            icon: Icons.upload_file,
            text: 'Bulk upload',
            active: widget.currentTab == AdminTab.BULK_UPLOAD,
            onTap: () {
              widget.onTap(AdminTab.BULK_UPLOAD);
            },
            collapsed: collapsedMenu,
          ),
        ],
      ),
    );
  }
}

class _SideMenuMobile extends StatelessWidget {
  final AdminTab currentTab;
  final Function changeTab;

  const _SideMenuMobile({Key key, this.currentTab, this.changeTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SideMenuItem(
          icon: Icons.dashboard,
          text: 'Dashboard',
          active: currentTab == AdminTab.DASHBOARD,
          collapsed: false,
          onTap: () {
            changeTab(AdminTab.DASHBOARD);
            Navigator.of(context).pop();
          },
        ),
        _SideMenuItem(
          icon: Icons.movie_creation_outlined,
          text: 'Movies',
          active: currentTab == AdminTab.MOVIES,
          collapsed: false,
          onTap: () {
            changeTab(AdminTab.MOVIES);
            Navigator.of(context).pop();
          },
        ),
        _SideMenuItem(
          icon: Icons.tv,
          text: 'TV shows',
          active: currentTab == AdminTab.TV,
          collapsed: false,
          onTap: () {
            changeTab(AdminTab.TV);
            Navigator.of(context).pop();
          },
        ),
        _SideMenuItem(
          icon: Icons.upload_file,
          text: 'Bulk upload',
          active: currentTab == AdminTab.BULK_UPLOAD,
          collapsed: false,
          onTap: () {
            changeTab(AdminTab.BULK_UPLOAD);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _SideMenuItem extends StatelessWidget {
  final bool active;
  final String text;
  final IconData icon;
  final Function onTap;
  final bool collapsed;

  Widget get expandedTiles {
    return ListTile(
        onTap: onTap,
        leading: Icon(icon, color: active ? Colors.yellow[800] : Colors.white),
        title: Text(
          text,
          style: TextStyle(
            color: active ? Colors.yellow[800] : Colors.white,
            fontSize: 12,
          ),
        ));
  }

  Widget get collapsedIcons {
    return IconButton(
      icon: Icon(icon),
      color: active ? Colors.yellow[800] : Colors.black,
      onPressed: onTap,
    );
  }

  const _SideMenuItem(
      {Key key, this.active, this.text, this.icon, this.onTap, this.collapsed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return collapsed ? collapsedIcons : expandedTiles;
  }
}
