import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/presentation/cubit/reel/get_single_reel/get_single_reel_cubit.dart';
import 'package:instagram_clone/presentation/cubit/reel/reel_cubit.dart';
import 'package:instagram_clone/presentation/pages/reels/widgets/single_reel_card_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class ReelsPage extends StatefulWidget {
  const ReelsPage({
    super.key,
  });

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    return Scaffold(
      body: BlocProvider(
        create: (context) => di.sl<ReelCubit>()..getReels(reel: ReelEntity()),
        child: BlocBuilder<ReelCubit, ReelState>(builder: (context, reelState) {
          if (reelState is ReelLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (reelState is ReelFailure) {
            Fluttertoast.showToast(
                msg: 'some failure occurred while getting the reel');
          }
          if (reelState is ReelLoaded) {
            return PageView.builder(
                scrollDirection: Axis.vertical,
                controller: pageController,
                itemCount: reelState.reels.length,
                itemBuilder: (context, index) {
                  final reel = reelState.reels[index];

                  return MultiBlocProvider(
                      providers: [
                        BlocProvider(create: (context) => di.sl<ReelCubit>()),
                        BlocProvider(
                            create: (context) => di.sl<GetSingleReelCubit>()),
                      ],
                      child: SingleReelCardWidget(
                        reel: reel,
                        reelId: reel.reelId!,
                      ));
                });
          }
          return const Center(
            child: Text('No reel'),
          );
        }),
      ),
    );
  }
}
