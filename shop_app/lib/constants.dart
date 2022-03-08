import 'package:logger/logger.dart';

/// Where in your project file you want to use {logger.d(meesage);} 
/// Just import this constant.dart at top of the file 

var logger = Logger(
    printer: PrettyPrinter(
  methodCount: 0,
  errorMethodCount: 5,
  lineLength: 50,
  colors: true,
  printEmojis: true,
  printTime: true,
));
