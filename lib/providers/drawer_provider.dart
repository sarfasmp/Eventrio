import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerProvider = StateNotifierProvider<DrawerNotifier, GlobalKey<ScaffoldState>?>((ref) {
  return DrawerNotifier();
});

class DrawerNotifier extends StateNotifier<GlobalKey<ScaffoldState>?> {
  DrawerNotifier() : super(null);

  void setScaffoldKey(GlobalKey<ScaffoldState> key) {
    state = key;
  }

  void openDrawer() {
    state?.currentState?.openEndDrawer();
  }
}

