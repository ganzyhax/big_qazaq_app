import 'dart:developer';

import 'package:big_qazaq_app/api/api.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  BannerBloc() : super(BannerInitial()) {
    List banners = [];
    on<BannerEvent>((event, emit) async {
      if (event is BannerLoad) {
        banners = await ApiClient().getAllDocuments('banners');
        emit(BannerLoaded(banners: banners));
      }
      if (event is BannerAdd) {
        var data = {'image': event.imageUrl};
        await ApiClient().addDocument('banners', data, true);
        add(BannerLoad());
      }
      if (event is BannerDelete) {
        await ApiClient().deleteDocument('banners', event.id);
        add(BannerLoad());
      }
    });
  }
}
