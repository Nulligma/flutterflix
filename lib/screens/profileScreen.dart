import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflix/assets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

enum SettingsFormType { login, register }

class _ProfileScreenState extends State<ProfileScreen> {
  SettingsFormType type;

  @override
  void initState() {
    super.initState();

    type = SettingsFormType.login;
  }

  void changeForm(SettingsFormType newType) {
    setState(() {
      type = newType;
    });
  }

  Widget get form {
    switch (type) {
      case SettingsFormType.login:
        return _LoginForm(
          onFormChange: changeForm,
        );
      case SettingsFormType.register:
        return _RegisterForm(
          onFormChange: changeForm,
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _LoginForm({Key key, @required this.onFormChange}) : super(key: key);

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
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                _formKey.currentState.save();

                print(email);
                print(password);
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
              onPressed: () => onFormChange(SettingsFormType.register),
            ),
          )
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  final Function onFormChange;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _RegisterForm({Key key, @required this.onFormChange}) : super(key: key);

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
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                _formKey.currentState.save();

                print(email);
                print(password);
                print(name);
                print(age);
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
              onPressed: () => onFormChange(SettingsFormType.login),
            ),
          )
        ],
      ),
    );
  }
}
