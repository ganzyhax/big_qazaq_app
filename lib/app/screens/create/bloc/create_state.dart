part of 'create_bloc.dart';

@immutable
sealed class CreateState {}

final class CreateInitial extends CreateState {}

final class CreateLoaded extends CreateState {
  List module = [];
  var progresses = [];
  var isDownloadDone = [];
  var isDownloadStarted = [];
  var isUploadingPdf = [];
  CreateLoaded(
      {required this.module,
      required this.progresses,
      required this.isUploadingPdf,
      required this.isDownloadDone,
      required this.isDownloadStarted});
}

final class CreateEditState extends CreateState {
  final String courseName;
  final String courseImage;
  CreateEditState({required this.courseImage, required this.courseName});
}
