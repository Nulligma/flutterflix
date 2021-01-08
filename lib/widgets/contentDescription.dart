import 'package:flutter/material.dart';
import 'package:flutterflix/data/data.dart';
import 'package:flutterflix/models/contentModel.dart';

class ContentDescription extends StatelessWidget {
  final Content content;
  final Function setState;
  final bool noDescription;

  const ContentDescription(
      {Key key, this.content, this.setState, this.noDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          noDescription
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    child: Text(
                      content.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              child: Text(
                'Starring: ${content.cast.join(', ')}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                FlatButton(
                  textColor: Colors.white70,
                  onPressed: () => print('My List'),
                  child: Container(
                    height: 50.0,
                    child: InkWell(
                      onTap: () {
                        if (myList.contains(content))
                          myList.remove(content);
                        else
                          myList.add(content);

                        setState(() {});
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            myList.contains(content) ? Icons.check : Icons.add,
                            size: 32.0,
                          ),
                          Text(
                            'My List',
                            style: TextStyle(fontSize: 10.0),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  textColor: Colors.white70,
                  onPressed: () => print('Rate'),
                  child: Container(
                    height: 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.thumb_up,
                          size: 24.0,
                        ),
                        Text(
                          'Rate',
                          style: TextStyle(fontSize: 10.0),
                        )
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  textColor: Colors.white70,
                  onPressed: () => print('Share'),
                  child: Container(
                    height: 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          size: 20.0,
                        ),
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 10.0),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
