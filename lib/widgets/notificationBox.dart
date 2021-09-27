import 'package:flutter/material.dart';
import 'package:flutterflix/database/clouddata.dart';
import 'package:flutterflix/helpers/uiHelpers.dart';
import 'package:flutterflix/models/contentModel.dart';
import 'package:flutterflix/models/notificationModel.dart';
import 'package:flutterflix/screens/contentDetailScreen.dart';

class NotificationBox extends StatelessWidget {
  static const double width = 300.0;
  static const double height = 200.0;

  final List<NotificationData>? notifications;
  final Function hideNotification;

  const NotificationBox(
      {Key? key, required this.notifications, required this.hideNotification})
      : super(key: key);

  Widget get body {
    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      elevation: 4.0,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: notifications!.length,
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 1.0,
              color: Colors.white.withOpacity(0.5),
            );
          },
          itemBuilder: (BuildContext context, int index) {
            Content content = Cloud.allContent!.firstWhere((Content content) =>
                content.id == notifications![index].contentId);
            return ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5.0),
              hoverColor: Colors.white.withOpacity(0.5),
              leading:
                  CircleAvatar(backgroundImage: NetworkImage(content.poster!)),
              title: Text(
                notifications![index].title!,
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                hideNotification();
                Navigator.push(
                    context,
                    createRoute(ContentDetails(content: content),
                        Offset(0.0, 1.0), Offset.zero));
              },
            );
          },
        ),
      ),
    );
  }

  Widget get nip {
    double nipWidth = 10.0;
    return Container(
      height: 10.0,
      width: nipWidth,
      margin: EdgeInsets.fromLTRB(3 * NotificationBox.width / 4, 0, 0, 10),
      child: CustomPaint(
        painter: _OpenPainter(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        nip,
        body,
      ],
    );
  }
}

class _OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withOpacity(0.5)
      ..isAntiAlias = true;

    _drawThreeShape(canvas,
        first: Offset(15, 0),
        second: Offset(0, 20),
        third: Offset(30, 20),
        size: size,
        paint: paint);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  void _drawThreeShape(Canvas canvas,
      {required Offset first,
      required Offset second,
      required Offset third,
      Size? size,
      required paint}) {
    var path1 = Path()
      ..moveTo(first.dx, first.dy)
      ..lineTo(second.dx, second.dy)
      ..lineTo(third.dx, third.dy);
    canvas.drawPath(path1, paint);
  }
}
