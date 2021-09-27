import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/admin/adminPanel.dart';
import 'package:flutterflix/assets.dart';
import 'package:flutterflix/database/firestoreFields.dart';
import 'package:flutterflix/helpers/uiHelpers.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  bool? admin;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    init();
  }

  void init() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference userDocument = FirebaseFirestore.instance
        .collection(FirestoreFields.USERS_COLLECTION)
        .doc(userId);

    DocumentSnapshot snapshot = await userDocument.get();

    email = snapshot.get(FirestoreFields.USER_EMAIL);
    name = snapshot.get(FirestoreFields.USER_NAME);
    admin = snapshot.get(FirestoreFields.ADMIN);

    setState(() {
      isLoading = false;
    });
  }

  Widget get _form {
    if (isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: const CircularProgressIndicator(),
            width: 60,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 26.0),
            ),
          )
        ],
      );
    } else
      return _UserDataForm(name: name, email: email, admin: admin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              image: NetworkImage(Assets.profile_background),
              fit: BoxFit.cover)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Image.network(
            Assets.netflixLogo1,
            fit: BoxFit.contain,
            height: 50,
          ),
        ),
        body: Center(
          child: Container(
            color: Colors.black.withOpacity(0.75),
            width: 400,
            height: 700,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: _form),
          ),
        ),
      ),
    );
  }
}

class _UserDataForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String? name;
  final String? email;
  final bool? admin;

  _UserDataForm({Key? key, this.name, this.email, this.admin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "Profile",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white30,
              filled: true,
              hintText: 'Enter your name',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Name is Required';
              }
              return null;
            },
            autofocus: false,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: email,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white30,
              filled: true,
              hintText: 'Enter your name',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Email is Required';
              }

              if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return 'Please enter a valid email Address';
              }

              return null;
            },
            autofocus: false,
          ),
          SizedBox(
            height: 40,
          ),
          if (admin!)
            Container(
              width: double.infinity,
              height: 50.0,
              child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.red[800]),
                  child: Text(
                    "Admin Panel",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(createRoute(
                        AdminPanel(), Offset(1.0, 0.0), Offset.zero));
                  }),
            )
          else
            Container(),
          Spacer(),
          Container(
            width: double.infinity,
            height: 50.0,
            child: TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.grey[800]),
                child: Text(
                  "Sign Out",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((_) {
                    if (Navigator.of(context).canPop())
                      Navigator.of(context).pop();
                  });
                }),
          )
        ],
      ),
    );
  }
}
