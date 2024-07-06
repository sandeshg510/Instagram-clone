import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/domain/entities/reels/reels_entity.dart';
import 'package:instagram_clone/presentation/cubit/reel/reel_cubit.dart';
import 'package:instagram_clone/presentation/pages/reels/widgets/single_reel_card_widget.dart';
import 'package:video_player/video_player.dart';
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
    Size size = MediaQuery.of(context).size;
    int index = 0;

    return Scaffold(
      backgroundColor: backGroundColor,
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
            print('reel loaded');
            return
                // PageView(
                //   controller: pageController,
                //   scrollDirection: Axis.vertical,
                //   onPageChanged: (index) {
                //     setState(() {
                //       reel = reelState.reels[index++];
                //     });
                //   },
                //   children: [
                //     BlocProvider(
                //         create: (context) => di.sl<ReelCubit>(),
                //         child: SingleReelCardWidget(reel: reel)),
                //   ]

                ListView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: reelState.reels.length,
              itemBuilder: (context, index) {
                final reel = reelState.reels[index];
                return BlocProvider(
                    create: (context) => di.sl<ReelCubit>(),
                    child: SingleReelCardWidget(reel: reel));
              },
            );
          }
          return const Center(
            child: Text('No reel'),
          );
        }),
      ),
    );
  }
}
