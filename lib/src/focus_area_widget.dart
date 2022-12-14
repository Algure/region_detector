import 'dart:core';

import 'package:flutter/material.dart';

import 'focus_notifier.dart';

/// Focus area is required to provide listener for pointer up and down events and then trigger callbacks on
/// [FocusPointerDetector] widgets when pointer enters the region of such widgets.
/// This widget must be an ancestor of [FocusPointerDetector] and share same context. It should appear only once
/// anywhere in the widget tree as an ancestor of [FocusPointerDetector] and it take just one required widget parameter
/// which should contain [FocusPointerDetector] widgets.
///
/// As this widget is essentially a [Listener], using listener widgets at
/// any other point in the widget tree would lead to erratic behaviour.
///

class FocusArea extends StatefulWidget {
  const FocusArea({Key? key,
    required this.child,
    this.onPointerDown,
    this.onPointerUp
  }) : super(key: key);

  final Widget child;
  /// This callback that can be set to be called after the pointer is down.
  final Function()? onPointerDown;
  /// This callback that can be set to be called after the pointer is up.
  final Function()? onPointerUp;

  @override
  State<FocusArea> createState() => _FocusAreaState();
}


/// This variable [_isPointed] tracks the pointer state of the screen and is broadcasted to [FocusPointerDetector] widgets further
/// down the tree via [FocusNotifierWidget] an [InheritedNotifier].
///
class _FocusAreaState extends State<FocusArea> {
  bool _isPointed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (mouseEvent) {
        setPointer(true);
        if(widget.onPointerDown != null){
          widget.onPointerDown!.call();
        }
      },
      onPointerUp: (mouseEvent) {
        setPointer(false);
        if(widget.onPointerUp != null){
          widget.onPointerUp!.call();
        }
      },
      child: FocusNotifierWidget(isPointed: _isPointed, child: widget.child),
    );
  }

  void setPointer(bool bool) {
    _isPointed = bool;
    if (mounted) {
      setState(() {});
    }
  }
}
