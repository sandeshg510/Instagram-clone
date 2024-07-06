part of 'reel_cubit.dart';

abstract class ReelState extends Equatable {
  const ReelState();
}

class ReelInitial extends ReelState {
  @override
  List<Object> get props => [];
}

class ReelLoading extends ReelState {
  @override
  List<Object> get props => [];
}

class ReelLoaded extends ReelState {
  final List<ReelEntity> reels;

  const ReelLoaded({required this.reels});

  @override
  List<Object> get props => [reels];
}

class ReelFailure extends ReelState {
  @override
  List<Object> get props => [];
}
