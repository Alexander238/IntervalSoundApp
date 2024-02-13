import 'package:flutter/material.dart';

Widget heightDivider(context, [double? reducer]) {
  if (reducer != null) {
    double hValue = (MediaQuery.of(context).size.height * 0.05) - reducer;

    if (hValue < 10) {
      hValue = 10;
    }
    return SizedBox(
      height: hValue,
    );
  }
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.05,
  );
}
