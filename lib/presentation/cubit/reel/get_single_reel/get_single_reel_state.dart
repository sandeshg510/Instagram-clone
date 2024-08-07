part of 'get_single_reel_cubit.dart';

abstract class GetSingleReelState extends Equatable {
  const GetSingleReelState();
}

class GetSingleReelInitial extends GetSingleReelState {
  @override
  List<Object> get props => [];
}

class GetSingleReelLoading extends GetSingleReelState {
  @override
  List<Object> get props => [];
}

class GetSingleReelLoaded extends GetSingleReelState {
  final ReelEntity reel;

  const GetSingleReelLoaded({required this.reel});
  @override
  List<Object> get props => [reel];
}

class GetSingleReelFailure extends GetSingleReelState {
  @override
  List<Object> get props => [];
}
