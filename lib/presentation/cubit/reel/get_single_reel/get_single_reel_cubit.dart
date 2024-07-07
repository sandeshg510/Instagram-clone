import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import '../../../../domain/usecases/firebase_usecases/reels/get_single_reel_usecase.dart';
part 'get_single_reel_state.dart';

class GetSingleReelCubit extends Cubit<GetSingleReelState> {
  final GetSingleReelUseCase getSingleReelUseCase;
  GetSingleReelCubit({required this.getSingleReelUseCase})
      : super(GetSingleReelInitial());

  Future<void> getSingleReel({required String reelId}) async {
    emit(GetSingleReelLoading());
    try {
      final streamResponse = getSingleReelUseCase.call(reelId);
      streamResponse.listen((reels) {
        emit(GetSingleReelLoaded(reel: reels.first));
      });
    } on SocketException catch (_) {
      emit(GetSingleReelFailure());
    } catch (_) {
      emit(GetSingleReelFailure());
    }
  }
}
