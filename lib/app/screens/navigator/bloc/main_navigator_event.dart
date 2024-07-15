part of 'main_navigator_bloc.dart';

@immutable
sealed class MainNavigatorEvent {}

class MainNavigatorLoad extends MainNavigatorEvent {}

// ignore: must_be_immutable
class MainNavigatorChangePage extends MainNavigatorEvent {
  int index;
  MainNavigatorChangePage({required this.index});
}

class MainNavigatorClear extends MainNavigatorEvent {}
