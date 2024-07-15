// ignore_for_file: dead_code_on_catch_subtype

import 'dart:developer';
import 'dart:io';

import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/api/video_api.dart';
import 'package:big_qazaq_app/app/screens/course/bloc/course_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:video_uploader/video_uploader.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc() : super(CreateInitial()) {
    List<Map<String, dynamic>> modules = [];
    String createdId = '';
    final ImagePicker _picker = ImagePicker();
    var progresses = [];
    var isDownloadDone = [];
    var isDownloadStarted = [];
    bool isGlobalIsDownload = false;
    var isUploadingPdf = [];
    on<CreateEvent>((event, emit) async {
      if (event is CreateLoad) {
        if (event.id != null) {
          var courseData =
              await ApiClient().getDocumentById('courses', event.id!);
          createdId = event.id!;

          modules = List<Map<String, dynamic>>.from(courseData['modules']);

          for (var i = 0; i < modules.length; i++) {
            isDownloadDone.add([]);
            isDownloadStarted.add([]);
            progresses.add([]);
            isUploadingPdf.add([false]);
            for (var l = 0; l < modules[i]['lessons'].length; l++) {
              progresses[i].add(100);
              isDownloadDone[i].add(true);
              isDownloadStarted[i].add(true);
            }
          }
          emit(CreateEditState(
              courseImage: courseData['image'],
              courseName: courseData['name']));
          emit(CreateLoaded(
              module: modules,
              isUploadingPdf: isUploadingPdf,
              progresses: progresses,
              isDownloadDone: isDownloadDone,
              isDownloadStarted: isDownloadStarted));
        } else {
          progresses = [];
          isDownloadDone = [];
          isDownloadStarted = [];
          createdId = '';
          modules = [];
          emit(CreateLoaded(
              module: modules,
              isUploadingPdf: isUploadingPdf,
              progresses: progresses,
              isDownloadDone: isDownloadDone,
              isDownloadStarted: isDownloadStarted));
        }
      }
      if (event is CreateAddModule) {
        progresses.add([]);
        isDownloadDone.add([]);
        isDownloadStarted.add([]);
        isUploadingPdf.add(false);
        modules.add({'moduleName': event.moduleName, 'lessons': []});
        emit(CreateLoaded(
            module: modules,
            isUploadingPdf: isUploadingPdf,
            progresses: progresses,
            isDownloadDone: isDownloadDone,
            isDownloadStarted: isDownloadStarted));
      }
      if (event is CreateDeleteModule) {
        modules.removeWhere(
            (element) => element['moduleName'] == event.moduleName);
        emit(CreateLoaded(
            module: modules,
            isUploadingPdf: isUploadingPdf,
            progresses: progresses,
            isDownloadDone: isDownloadDone,
            isDownloadStarted: isDownloadStarted));
      }
      if (event is CreateAddLesson) {
        for (var i in modules) {
          if (i['moduleName'] == event.moduleName) {
            int index = modules.indexOf(i);
            progresses[index].add(0.0);
            isDownloadDone[index].add(false);
            isDownloadStarted[index].add(false);
            i['lessons'].add({
              'lessonName': event.lessonName,
            });
          }
        }
        emit(CreateLoaded(
            module: modules,
            progresses: progresses,
            isUploadingPdf: isUploadingPdf,
            isDownloadDone: isDownloadDone,
            isDownloadStarted: isDownloadStarted));
      }
      if (event is CreateRemoveLesson) {
        for (var i = 0; i < modules.length; i++) {
          if (modules[i]['moduleName'] == event.moduleName) {
            for (var c = 0; c < modules[i]['lessons'].length; c++) {
              if (modules[i]['lessons'][c]['lessonName'] == event.lessonName) {
                modules[i]['lessons'].removeAt(c);
                progresses[i].removeAt(c);
                isDownloadDone[i].removeAt(c);
                isDownloadStarted[i].removeAt(c);
              }
            }
          }
        }

        emit(CreateLoaded(
            module: modules,
            isUploadingPdf: isUploadingPdf,
            progresses: progresses,
            isDownloadDone: isDownloadDone,
            isDownloadStarted: isDownloadStarted));
      }
      if (event is CreateVideoUpload) {
        int mIndex = -1;
        int lIndex = -1;
        var source = ImageSource.gallery;
        XFile? video = await _picker.pickVideo(
          source: source,
        );
        var s = (File(video!.path).lengthSync() / (1024 * 1024))
            .toStringAsFixed(2)
            .toString();
        log(s);

        void handleUploadError(dynamic e) {
          isDownloadDone[mIndex][lIndex] = false;
          isDownloadStarted[mIndex][lIndex] = false;
          log(e.toString());
          emit(CreateLoaded(
            module: modules,
            isUploadingPdf: isUploadingPdf,
            progresses: progresses,
            isDownloadDone: isDownloadDone,
            isDownloadStarted: isDownloadStarted,
          ));
        }

        if (video != null) {
          Future<void> attemptUpload(String videoPath) async {
            try {
              for (var i in modules) {
                if (i['moduleName'] == event.moduleName) {
                  mIndex = modules.indexOf(i);
                  for (var l in i['lessons']) {
                    if (l['lessonName'] == event.lessonName) {
                      lIndex = i['lessons'].indexOf(l);
                      isDownloadStarted[mIndex][lIndex] = true;
                      emit(CreateLoaded(
                        module: modules,
                        isUploadingPdf: isUploadingPdf,
                        progresses: progresses,
                        isDownloadDone: isDownloadDone,
                        isDownloadStarted: isDownloadStarted,
                      ));
                      break;
                    }
                  }
                  break;
                }
              }
              ApiVideoUploader.setTimeout(6000000);
              // ApiVideoUploader.setChunkSize(60000000);
              ApiVideoUploader.setApiKey(
                  'UTfzaMxBnTaISZWd60ng1PReroG2bB51TflB3eQawB7');
              var s = await ApiVideoUploader.uploadWithUploadToken(
                'to4ZcfVEufmySfNp2OdSa04N',
                videoPath,
                onProgress: (gettinProgress) {
                  try {
                    progresses[mIndex][lIndex] = gettinProgress;
                  } catch (e) {
                    lIndex = lIndex - 1;
                    progresses[mIndex][lIndex] = gettinProgress;
                  }
                  emit(CreateLoaded(
                    module: modules,
                    isUploadingPdf: isUploadingPdf,
                    progresses: progresses,
                    isDownloadDone: isDownloadDone,
                    isDownloadStarted: isDownloadStarted,
                  ));
                },
              );
              isDownloadDone[mIndex][lIndex] = true;
              // Update lesson details after successful upload
              for (var i in modules) {
                if (i['moduleName'] == event.moduleName) {
                  for (var l in i['lessons']) {
                    if (l['lessonName'] == event.lessonName) {
                      l['lessonVideoUrl'] = s.assets?.hls.toString();
                      l['lessonVideoImage'] = s.assets!.thumbnail;
                      emit(CreateLoaded(
                        module: modules,
                        isUploadingPdf: isUploadingPdf,
                        progresses: progresses,
                        isDownloadDone: isDownloadDone,
                        isDownloadStarted: isDownloadStarted,
                      ));
                      break;
                    }
                  }
                  break;
                }
              }

              // Save or update the document in the database
              if (createdId == '') {
                createdId = await ApiClient()
                    .addDocument('courses', {'modules': modules}, false);
              } else {
                await ApiClient()
                    .updateDocument('courses', createdId, {'modules': modules});
              }

              emit(CreateLoaded(
                module: modules,
                isUploadingPdf: isUploadingPdf,
                progresses: progresses,
                isDownloadDone: isDownloadDone,
                isDownloadStarted: isDownloadStarted,
              ));
            } catch (e) {
              log('malll');
              handleUploadError(e);
              await Future.delayed(Duration(seconds: 2));

              await attemptUpload(video.path);
            }
          }

          // Attempt to upload initially
          try {
            await attemptUpload(video.path);
          } on PlatformException catch (e) {
            // Handle platform exceptions such as timeouts
            handleUploadError(e);
            // Retry the upload after a delay
            await Future.delayed(Duration(seconds: 2));
            await attemptUpload(video.path);
          } catch (e) {
            handleUploadError(e);
          }
        }
      }

// Function to attempt the upload and handle progress

      if (event is CreateCreateFinally) {
        await ApiClient().updateDocument('courses', createdId, {
          'modules': modules,
          'name': event.courseName,
          'id': createdId,
          'image': event.courseImage
        });

        add(CreateLoad());
      }
      if (event is CreateUploadPdf) {
        for (var i = 0; i < modules.length; i++) {
          if (modules[i]['moduleName'] == event.moduleName) {
            isUploadingPdf[i] = true;
          }
        }
        emit(CreateLoaded(
            module: modules,
            isUploadingPdf: isUploadingPdf,
            progresses: progresses,
            isDownloadDone: isDownloadDone,
            isDownloadStarted: isDownloadStarted));
        String? pdfUrl = await FileApi().uploadPDF();

        if (pdfUrl.toString() != 'null') {
          for (var i in modules) {
            if (i['moduleName'] == event.moduleName) {
              // Check if pdfFiles already exists
              if (i.containsKey('pdfFiles')) {
                // pdfFiles exists, modify it
                if (i['pdfFiles'] is List) {
                  i['pdfFiles']
                      .add({'fileUrl': pdfUrl, 'fileName': event.fileName});
                } else {
                  // Handle case where pdfFiles is not a List (though it should be)
                  i['pdfFiles'] = [
                    {'fileUrl': pdfUrl, 'fileName': event.fileName}
                  ];
                }
              } else {
                // pdfFiles does not exist, initialize it
                i['pdfFiles'] = [
                  {'fileUrl': pdfUrl, 'fileName': event.fileName}
                ];
              }
            }
          }
        }
        await ApiClient().updateDocument('courses', createdId, {
          'modules': modules,
          'id': createdId,
        });
        for (var i = 0; i < modules.length; i++) {
          if (modules[i]['moduleName'] == event.moduleName) {
            isUploadingPdf[i] = false;
          }
        }

        emit(CreateLoaded(
            module: modules,
            isUploadingPdf: isUploadingPdf,
            progresses: progresses,
            isDownloadDone: isDownloadDone,
            isDownloadStarted: isDownloadStarted));
      }
      if (event is CreateDeletePdf) {
        for (var i = 0; i < modules.length; i++) {
          if (modules[i]['moduleName'] == event.moduleName) {
            log(modules[i]['pdfFiles'].toString());
            modules[i]['pdfFiles'].removeAt(event.index);
          }
        }
        emit(CreateLoaded(
            module: modules,
            isUploadingPdf: isUploadingPdf,
            progresses: progresses,
            isDownloadDone: isDownloadDone,
            isDownloadStarted: isDownloadStarted));
      }
    });
  }
}
