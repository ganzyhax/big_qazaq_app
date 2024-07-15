part of 'create_bloc.dart';

@immutable
sealed class CreateEvent {}

final class CreateLoad extends CreateEvent {
  String? id;
  CreateLoad({this.id});
}

final class CreateAddModule extends CreateEvent {
  String moduleName;
  CreateAddModule({required this.moduleName});
}

final class CreateDeleteModule extends CreateEvent {
  String moduleName;

  CreateDeleteModule({required this.moduleName});
}

final class CreateAddLesson extends CreateEvent {
  String lessonName;
  String moduleName;
  CreateAddLesson({required this.lessonName, required this.moduleName});
}

final class CreateRemoveLesson extends CreateEvent {
  String lessonName;
  String moduleName;

  CreateRemoveLesson({required this.lessonName, required this.moduleName});
}

final class CreateVideoUpload extends CreateEvent {
  final String moduleName;
  final String lessonName;
  CreateVideoUpload({
    required this.moduleName,
    required this.lessonName,
  });
}

final class CreateCreateFinally extends CreateEvent {
  final String courseName;
  final String courseImage;
  CreateCreateFinally({required this.courseImage, required this.courseName});
}

final class CreateUploadPdf extends CreateEvent {
  final String moduleName;
  final String fileName;
  CreateUploadPdf({
    required this.moduleName,
    required this.fileName,
  });
}

final class CreateDeletePdf extends CreateEvent {
  final String moduleName;
  final int index;
  CreateDeletePdf({
    required this.moduleName,
    required this.index,
  });
}
