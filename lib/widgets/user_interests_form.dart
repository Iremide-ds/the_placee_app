import 'package:flutter/material.dart';

import 'package:bubble_chart/bubble_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CircleScatteredWidget extends StatefulWidget {
  final List interests;
  final Function addOrRemoveInterest;

  const CircleScatteredWidget(
      {super.key, required this.interests, required this.addOrRemoveInterest});

  @override
  State<CircleScatteredWidget> createState() => _CircleScatteredWidgetState();
}

class _CircleScatteredWidgetState extends State<CircleScatteredWidget> {
  final List<int> _clickedIndexes = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // final double circleSize = constraints.maxWidth / 8;

        return BubbleChartLayout(
          duration: const Duration(seconds: 1),
          padding: 4,
          children: widget.interests.map((interest) {
            final int index = widget.interests.indexOf(interest);

            return BubbleNode.node(
              children: [
                BubbleNode.leaf(
                  value: (constraints.maxWidth /
                      interest['name'].toString().length),
                  options: BubbleOptions(
                    color: _clickedIndexes.contains(index) ? const Color(0xff1E4B6C) : Colors.white,
                    border:
                        Border.all(color: const Color(0xff1E4B6C), width: 2),
                    child: GestureDetector(
                      onTap: () {
                        if (_clickedIndexes.contains(index)) {
                          _clickedIndexes.remove(index);
                        }else {
                          _clickedIndexes.add(index);
                        }
                        widget.addOrRemoveInterest(interest['id'].toString());
                        setState((){});
                      },
                      child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            interest['name'].toString(),
                            style: TextStyle(
                              color: _clickedIndexes.contains(index) ? Colors.white : const Color(0xff1E4B6C),
                              fontWeight: FontWeight.w500,
                              fontSize: 16 * MediaQuery.textScaleFactorOf(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ).animate().slideX(curve: Curves.fastOutSlowIn);
      },
    );
  }
}
