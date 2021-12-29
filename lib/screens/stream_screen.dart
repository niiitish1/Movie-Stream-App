import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_stream_app/const/colors.dart';
import 'package:movie_stream_app/const/my_array.dart';
import 'package:movie_stream_app/const/string.dart';
import 'package:movie_stream_app/widget/same_widget.dart';

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  _StreamScreenState createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: darkBlue,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bigTitle(
              text: coming_soon,
              textSize: size.width,
            ),
            buildMySlider(commingSoonList,
                viewPortFraction: 1,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                showdetails: false,
                height: size.height * 0.35,
                showplayIcon: true,
                autoPlay: false),
            myChip(),
            bigTitle(
              text: trending_now,
              textSize: size.width,
            ),
            buildMySlider(
              trendingNowList,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              height: (size.height -
                      MediaQuery.of(context).padding.top +
                      kToolbarHeight) *
                  0.5,
              viewPortFraction: 0.5,
            ),
            bigTitle(
              text: bollywood,
              textSize: size.width,
            ),
            buildMySlider(
              bollyWoodList,
              autoPlay: false,
              showdetails: false,
              height: size.height * 0.35,
            ),
            bigTitle(
              text: south,
              textSize: size.width,
            ),
            buildMySlider(
              southList,
              autoPlay: false,
              showdetails: false,
              height: size.height * 0.35,
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView myChip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Wrap(
              spacing: 15,
              children: List.generate(
                chipArray.length,
                (index) => buildChoiceChip(index),
              ),
            )
          ],
        ),
      ),
    );
  }

  ChoiceChip buildChoiceChip(int index) {
    return ChoiceChip(
      backgroundColor: index == 0 ? Colors.red : lightBlue,
      label: Text(chipArray[index]),
      selected: _isSelected,
      onSelected: (newBoolValue) {
        setState(() {
          _isSelected = newBoolValue;
        });
      },
    );
  }
}
