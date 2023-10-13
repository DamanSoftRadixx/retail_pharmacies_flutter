import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_retail_pharmacies/core/local_library/scroll_to_index.dart';

Widget wrapScrollTag(
    {required int index,
    required Widget child,
    required AutoScrollController autoScrollController}) {
  return AutoScrollTag(
    key: ValueKey(index),
    controller: autoScrollController,
    index: index,
    child: child,
    highlightColor: Colors.black.withOpacity(0.1),
  );
}
