import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_stream_app/const/colors.dart';
import 'package:movie_stream_app/models/movie_info.dart';

Padding bigTitle({String? text, var textSize}) {
  return Padding(
    padding: const EdgeInsets.only(left: 16),
    child: Text(text!,
        style: TextStyle(
          fontSize: textSize * 0.08,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        )),
  );
}

Container builRoundBackground(
    {bool isRatingEnabled = false, required String text}) {
  return Container(
    padding: const EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4),
    decoration: const BoxDecoration(
        color: lightGrey, borderRadius: BorderRadius.all(Radius.circular(5))),
    child: Row(
      children: [
        isRatingEnabled
            ? Text(
                text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400),
              )
            : Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: starColor,
                    size: 18,
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ],
              )
      ],
    ),
  );
}

CarouselSlider buildMySlider(
  List<MovieInfo> list, {
  bool autoPlay = true,
  bool showdetails = true,
  double height = 0,
  double viewPortFraction = 1,
  CenterPageEnlargeStrategy enlargeStrategy = CenterPageEnlargeStrategy.height,
  bool showplayIcon = false,
}) {
  return CarouselSlider.builder(
    itemCount: list.length,
    options: CarouselOptions(
      autoPlay: autoPlay,
      height: height,
      enlargeCenterPage: true,
      viewportFraction: viewPortFraction,
    ),
    itemBuilder: (context, index, realIndex) {
      return Container(
        // color: Colors.green,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(list[index].img)),
                if (showdetails) ...[
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        builRoundBackground(
                            text: list[index].ageRestriction,
                            isRatingEnabled: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: builRoundBackground(
                              text: list[index].generes, isRatingEnabled: true),
                        ),
                        builRoundBackground(
                            text: list[index].ratings.toString()),
                      ],
                    ),
                  ),
                ],
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    list[index].movieName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
              ],
            ),
            if (showplayIcon) ...[
              const Icon(
                Icons.play_circle,
                color: Colors.red,
              )
            ],
          ],
        ),
      );
    },
  );
}
