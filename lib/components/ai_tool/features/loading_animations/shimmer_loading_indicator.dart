import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


/// a widget that displays a shimmer loading indicator
/// used to show a placeholder while content is loading
class ShimmerLoadingIndicator extends StatelessWidget {

  /// constructor for the shimmer loading indicator
  const ShimmerLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {

    return Shimmer.fromColors(

      /// color used as the base color of the shimmer effect
      baseColor: Colors.grey[300]!,

      /// color used as the highlight color of the shimmer effect
      highlightColor: Colors.grey[100]!,

      child: GridView.builder(

        /// padding around the grid view
        padding: const EdgeInsets.all(10.0),

        /// number of items to display in the grid view
        itemCount: 20,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

          /// number of columns in the grid
          crossAxisCount: 2,

          /// aspect ratio of each grid item
          childAspectRatio: 3 / 2,

          /// spacing between grid items in the horizontal direction
          crossAxisSpacing: 10,

          /// spacing between grid items in the vertical direction
          mainAxisSpacing: 10,

        ),

        itemBuilder: (ctx, i) => GridTile(

          /// footer displayed at the bottom of each grid tile
          footer: const GridTileBar(
            backgroundColor: Colors.black54,
          ),

          /// content of each grid tile
          child: Container(color: Colors.white),

        ),

      ),

    );
  }// end 'build' overrided method

}// end 'ShimmerLoadingIndicator' widget class