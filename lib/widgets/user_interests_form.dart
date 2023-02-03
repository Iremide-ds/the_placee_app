import 'package:flutter/material.dart';

import 'package:bubble_chart/bubble_chart.dart';

class CircleScatteredWidget extends StatelessWidget {
  final List interests;
  final Function addOrRemoveInterest;

  const CircleScatteredWidget(
      {super.key, required this.interests, required this.addOrRemoveInterest});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // final double circleSize = constraints.maxWidth / 8;

        return BubbleChartLayout(
          duration: const Duration(seconds: 1),
          padding: 4,
          children: interests.map((interest) {
            return BubbleNode.node(
              children: [
                BubbleNode.leaf(
                  value: (constraints.maxWidth / interest['name'].toString().length),
                  options: BubbleOptions(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0, backgroundColor: Colors.transparent),
                      onPressed: () {
                        addOrRemoveInterest(interest['id'].toString());
                      },
                      child: Text(interest['name'].toString(), style: const TextStyle(color: Colors.red),),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
