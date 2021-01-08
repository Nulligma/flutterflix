import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflix/assets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum FormType { login, register, error }

class _LoginScreenState extends State<LoginScreen> {
  FormType type;
  String formMessage;
  bool isLoading;

  @override
  void initState() {
    super.initState();

    type = FormType.login;
    isLoading = false;
  }

  void changeForm(FormType newType, {String message}) {
    formMessage = message;
    setState(() {
      type = newType;
    });
  }

  void showLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Widget get form {
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
    }

    switch (type) {
      case FormType.login:
        return _LoginForm(
          onFormChange: changeForm,
          showLoading: showLoading,
        );
      case FormType.register:
        return _RegisterForm(
          onFormChange: changeForm,
          showLoading: showLoading,
        );
      case FormType.error:
        return _ErrorForm(
          onFormChange: changeForm,
          message: formMessage,
        );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.darken),
              image: AssetImage(Assets.login_background),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Image.asset(
            Assets.netflixLogo1,
            fit: BoxFit.contain,
            height: 50,
          ),
        ),
        body: Center(
          child: Container(
            color: Colors.black.withOpacity(0.75),
            width: 500,
            height: 700,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: form),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final Function onFormChange;
  final Function showLoading;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _LoginForm({Key key, @required this.onFormChange, @required this.showLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email;
    String password;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "Sign In",
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white30,
              filled: true,
              hintText: 'Enter your email',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Email is Required';
              }

              if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return 'Please enter a valid email Address';
              }

              return null;
            },
            onSaved: (String value) {
              email = value;
            },
            autofocus: false,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white30,
              filled: true,
              hintText: 'Enter your password',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            autofocus: false,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Password is Required';
              }

              return null;
            },
            onSaved: (String value) {
              password = value;
            },
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: double.infinity,
            height: 50.0,
            child: FlatButton(
              color: Colors.red[800],
              child: Text(
                "Sign in",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  try {
                    showLoading(true);
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);

                    showLoading(false);
                  } on FirebaseAuthException catch (e) {
                    showLoading(false);
                    onFormChange(FormType.error, message: e.message);
                  }
                }
              },
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: 50.0,
            child: FlatButton(
              color: Colors.grey[800],
              child: Text(
                "Register",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () => onFormChange(FormType.register),
            ),
          )
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final Function onFormChange;
  final Function showLoading;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _RegisterForm(
      {Key key, @required this.onFormChange, @required this.showLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name;
    int age;
    String email;
    String password;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            "Register",
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
            validator: (String value) {
              if (value.isEmpty) {
                return 'Name is Required';
              }

              return null;
            },
            onSaved: (String value) {
              name = value;
            },
            autofocus: false,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white30,
              filled: true,
              hintText: 'Enter your age',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            validator: (String value) {
              int ageInput = int.tryParse(value);

              if (ageInput == null || ageInput <= 0) {
                return 'Correct age is Required';
              }

              return null;
            },
            onSaved: (String value) {
              age = int.tryParse(value);
            },
            autofocus: false,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white30,
              filled: true,
              hintText: 'Enter your email',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Email is Required';
              }

              if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return 'Please enter a valid email Address';
              }

              return null;
            },
            onSaved: (String value) {
              email = value;
            },
            autofocus: false,
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white30,
              filled: true,
              hintText: 'Enter your password',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 16.0,
              ),
            ),
            autofocus: false,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Password is Required';
              } else if (value.length < 6) {
                return 'Password should be at least 6 characters';
              }

              return null;
            },
            onSaved: (String value) {
              password = value;
            },
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            width: double.infinity,
            height: 50.0,
            child: FlatButton(
              color: Colors.red[800],
              child: Text(
                "Register",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  try {
                    showLoading(true);
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email, password: password);

                    showLoading(false);
                  } on FirebaseAuthException catch (e) {
                    showLoading(false);
                    onFormChange(FormType.error, message: e.message);
                  }
                }
              },
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: 50.0,
            child: FlatButton(
              color: Colors.grey[800],
              child: Text(
                "Login",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () => onFormChange(FormType.login),
            ),
          )
        ],
      ),
    );
  }
}

class _ErrorForm extends StatelessWidget {
  final String message;
  final Function onFormChange;

  const _ErrorForm({Key key, this.message, this.onFormChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        "Error",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
      Spacer(),
      Container(
        width: double.infinity,
        height: 50.0,
        child: FlatButton(
          color: Colors.grey[800],
          child: Text(
            "Register",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: () => onFormChange(FormType.register),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        width: double.infinity,
        height: 50.0,
        child: FlatButton(
          color: Colors.grey[800],
          child: Text(
            "Login",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: () => onFormChange(FormType.login),
        ),
      )
    ]);
  }
}
