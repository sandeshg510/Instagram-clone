import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/reels/create_reel_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/reels/get_reels_usecase.dart';
import 'package:instagram_clone/domain/usecases/firebase_usecases/storage/upload_thumbnail_to_storage_usecase.dart';

part 'reel_state.dart';

class ReelCubit extends Cubit<ReelState> {
  ReelCubit(
      {required this.uploadThumbnailToStorageUseCase,
      required this.createReelUseCase,
      required this.getReelsUseCase})
      : super(ReelInitial());

  final CreateReelUseCase createReelUseCase;
  final GetReelsUseCase getReelsUseCase;
  final UploadThumbnailToStorageUseCase uploadThumbnailToStorageUseCase;

  Future<void> createReels({required ReelEntity reel}) async {
    emit(ReelLoading());
    try {
      await createReelUseCase.call(reel);
    } on SocketException catch (_) {
      emit(ReelFailure());
    } catch (e) {
      emit(ReelFailure());
    }
  }

  Future<String> createThumbnails({required String videoFilePath}) async {
    emit(ReelLoading());
    try {
      final thumbnailUrl =
          await uploadThumbnailToStorageUseCase.call(videoFilePath);
      return thumbnailUrl;
    } on SocketException catch (_) {
      emit(ReelFailure());
      return 'null';
    } catch (e) {
      emit(ReelFailure());
      return 'null';
    }
  }

  Future<void> getReels({required ReelEntity reel}) async {
    emit(ReelLoading());
    try {
      final streamResponse = getReelsUseCase.call(reel);
      streamResponse.listen((reels) {
        emit(ReelLoaded(reels: reels));
      });
    } on SocketException catch (_) {
      emit(ReelFailure());
    } catch (_) {
      emit(ReelFailure());
    }
  }
}
