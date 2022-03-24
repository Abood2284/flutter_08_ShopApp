/// This code was provided my Max{tutor} though i will explain the working of the code
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../model/https_exception.dart';

/// This will decide what UI rendered based on authMode whether user choose to login or signup
///
/// coz if login then we ask for pass only once wile rendering container with height 260
/// else if user choose signup we ask user to enter pass twice to confirm wile rendering container with height 320
enum AuthMode { Signup, Login }

/// * Is responsible for backgroundColor, Location of the authCard, MyShop Text
class AuthScreen extends StatelessWidget {
  static const routeName = 'auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          /// * Base Child of the stack,
          ///
          /// * Purpose is just to reder the LinearGradient color as the bg color of the screen
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            /// * Second base child of the Stack
            /// Whihc takes the full device width and height
            ///
            /// It renders a scorollable col having another 2 containers
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    /// * Renders the Shop Text at the center by setting [Column] Axis Alignment to center, mostly its the Decoration done for this container
                    ///! SHOP TEXT
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),

                      /// This transform the container on the z axis[what you can see x is left-right, y is top-down and z is form your eye to inside the screen or on the screen]
                      /// .. is used to ignore the return value .translate returns void and is used on MAtrix4 though transform need Matrix4 value not null so to ignore translate value we use dart feature
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .headline6!
                              .color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  // 3rd the last child of the stack below the Column It renders the form that have the logic and the UI of authentication
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// * Returns a Card which holds the logic and UI for user to signup & login
class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  /// To manage the state of the form from the state
  final GlobalKey<FormState> _formKey = GlobalKey();

  /// * Setting default auth mode to login
  AuthMode _authMode = AuthMode.Login;

  /// * This stores the email & password of the user
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  /// * Load a spinner while true
  var _isLoading = false;

  /// * Used for holding the passowrd input and compare this with the [confirm password field] input in signup authMode
  final _passwordController = TextEditingController();

  /// * Variable _controller of type Animation controller
  late AnimationController _controller;

  /// * Controller is other thing i also need a animation, which is generic type.
  /// * As here i want to animate height/size of the Container(Holding auth UI which changes it size to 360 when user press signup and shrinks back to 260 when user press login)
  late Animation<Size> _heightAnimation; // Unused Code

  late Animation<double> _opacity;

  /// used by {FadeTransition}
  // Both Animation variable should be assigned when the state is created
  @override
  void initState() {
    /// * vsync: we need to pass a pointer to the widget that needs animation and when that widget is visisble on the screen then only the animation should run.
    /// * So i want to point to this widget or state which belongs to the widget which has build method
    /// ! Also you need to add (with SingleTickerProviderStateMixin) to your state class
    /// * Duration shouldnt be too long we just need to show user a small animation
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    /// * Now for Animation, animation is setup using tween class which in the end knows how to animate between 2 values (between same as tween).
    /// * Also type of generic so passing it Size, Size needs widht & height same does the end needs,  this means start with height 260 end with 360,
    /// ! and vice-versa as you didnt mention the duration(reverse or just duration), if you dont configure reverse diration then both duration will be configured the same for you as here both 300milliseconds
    _heightAnimation = Tween<Size>(
            begin: const Size(double.infinity, 250),
            end: const Size(double.infinity, 320))
        .animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn)); // See more animations with Curves.
    /// * Adding a listener to call setState when ever _heightAnimation changes
    // _heightAnimation.addListener(() {
    //   setState(() {});
    // });

    /// This opacitate from 0 (form invisible) to 1(fully visible) -> opacity can have value between 0 & 1
    _opacity = Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// * To display the error dialog in try-catch block,
  /// THough it is recommended that you create a seperate widget file for Showing Dialog and
  /// then you can call that widget anywhere in the project to display beautiful dialogs.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    /// Trigger and check validator if returned non null then invalid
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }

    /// Run onSaved on every field
    _formKey.currentState!.save();

    /// While you save and send data to server make the user wait while showing the spinner
    setState(() {
      _isLoading = true;
    });
    try {
      /// Check if the authmode === login mode
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';

      /// * These are some common error thrown by firebase,
      /// Also this is no the recommended way to handle error you could do is create a widget that shows error dialog
      /// and you can re-use it in multiple places where you want to show a error dialog
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// * Used to change the authMode
  void _switchAuthMode() {
    /// if authMode is login then change to Signup and vice-versa
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller
          .forward(); // Starts the animation & you want to enlarge the container when going to Signup mode.
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller
          .reverse(); // reverse the animation making the container shrink, which you want when going to login mode
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,

      /// ! MOre on Notion
      /// ! Switched from AnimatedBuilder -> AnimatedContainer
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubicEmphasized,

        /// Render the height based on the authMode as Signup needs more height to display confirm password Field
        height: _authMode == AuthMode.Signup ? 320 : 260,
        // height: _heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),

        /// ! FORM
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      //! ...Not a valid error handling
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    /// Store the value in a Map<String, String>
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      //! ...Not a valid error handling
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    /// Store the value in a Map<String, String>
                    _authData['password'] = value!;
                  },
                ),

                /// * Only if AuthMode is signup then show the confirm password field
                // if (_authMode == AuthMode.Signup)
                /// * Instead of if check we are using AnimatedContainer to prevent the reserved size for the ConfirmPass field as without if check it is permenant field,
                /// If we add if Check we will not be able to see the FadeTransition as it will be soo quick
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _opacity,
                    child: TextFormField(
                      ///? Still dont know that is the use of enabled: here
                      enabled: _authMode == AuthMode.Signup,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,

                      /// * Just a basic validator again checks if we are in signup Mode and compared value with the password controller if not the same then return error else null
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                //! ...Not a valid error handling
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    child:
                        // * Submits the data to the server while showing the text as what authMode selected
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                      // primary: Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                TextButton(
                  child: Text(

                      /// * When pressed swithches the authMode
                      /// Text is displayed if authMode is login show 'signup instead' else 'login instead'
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 4),
                    // Decreacing the tap size of the button to get better user experience
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    primary: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
