import 'package:tiket/Helpers/helper.dart';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Size getWidgetSize(GlobalKey key) {
  final RenderBox renderBox = key.currentContext?.findRenderObject();
  return renderBox?.size;
}

//widget untuk tampilan loading
Widget loadingWidget (BuildContext context){
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(
        backgroundColor: ACCENT_COLOR,
        valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
      ),
    ),
  );
}

Widget loadingWidgetCenter (BuildContext context){
  return Container(
    child: Center(
      child: CircularProgressIndicator(
        backgroundColor: ACCENT_COLOR,
        valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
      ),
    ),
  );
}

//widget untuk toast success
Flushbar showSuccessToast(BuildContext context, String message) {
  return Flushbar(
    title: 'Success',
    message: message,
    icon: Icon(
      Icons.check,
      size: 28.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.green[600], Colors.green[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

//widget untuk toast error
Flushbar showErrorToast(BuildContext context, String message) {
  return Flushbar(
    title: 'Error',
    message: message,
    icon: Icon(
      Icons.error,
      size: 28.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.red[600], Colors.red[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

//widget untuk tampilin kosong
Widget nullWidget(BuildContext context) => SizedBox.shrink();
