/// * this file is use to override the default animation you see when you jump to any other screeen, thats screen coming from down
import 'package:flutter/material.dart';

///* you can use this file for custom transition for custom screens,
/// for exmaple you only want to show this animation when you switch to orders screen? then in drawers you can see that we have added this class when navigating to orders
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    WidgetBuilder? builder,
    RouteSettings? settings,
  }) : super(
          builder: builder!,
          settings: settings,
        );

  /// * Overriding the default animation wiht our own
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

/// The same way you can create animation for IOS if you want different for native devices
/// Hence you can now use this class in main.dart to make transition for
/// * This will set animation for all screens, if you set this in main, all screen will have the same animation as FadeTransition
/// * For custom check above class
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
