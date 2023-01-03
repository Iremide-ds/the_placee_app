import 'dart:developer';
import 'dart:math' as mat;

import 'package:flutter/material.dart';

import '../constants/my_constants.dart';

class InterestsForm extends StatefulWidget {
  final Function addInterest;

  const InterestsForm({Key? key, required this.addInterest}) : super(key: key);

  @override
  State<InterestsForm> createState() => _InterestsFormState();
}

class _InterestsFormState extends State<InterestsForm> {
  final List<Interests> _interests = Interests.values;
  final List<Widget> _bubbleChartNodes = [];
  final List<List<int>> _bubbleNodes = [];

  List<int> _generateUniqueNumbers(int bubbleCount, double limit) {
    // Create a set to store the unique numbers
    Set<int> uniqueNumbers = {};

    // Create a random number generator
    final random = mat.Random();

    // Generate numbers until we have n unique numbers
    /*while (uniqueNumbers.length < bubbleCount) {
      // uniqueNumbers.add(random.nextDouble() * limit);
      uniqueNumbers.add(random.nextInt(limit.toInt()) + 1);
    }*/
    while (uniqueNumbers.length < bubbleCount) {
      int number = random.nextInt(bubbleCount * 50) + 50;
      if (!uniqueNumbers.contains(number)) {
        uniqueNumbers.add(number);
      }}
    log('generated numbers - ${uniqueNumbers.toList().toString()}', name: '_InterestsFormState._generateUniqueNumbers', time: DateTime.now(),);
    // Return the list of unique numbers
    return uniqueNumbers.toList();
  }

  void _generatePositions(int bubbleCount) {
    log('Generating Bubble positions...',
        name: '_InterestsFormState._generatePositions()', time: DateTime.now());
    //top values i.e height
    _bubbleNodes.add(_generateUniqueNumbers(bubbleCount,
        WidgetsBinding.instance.window.physicalSize.height * 0.17));
    //left values i.e width
    _bubbleNodes.add(_generateUniqueNumbers(
        bubbleCount,
        WidgetsBinding.instance.window.physicalSize.width * 0.5/*+
            (WidgetsBinding.instance.window.physicalSize.width * 0.5)*/));
  }

  void _buildInterestNodes() {
    int index = 0;
    log('building bubbles...',
        name: '_InterestsFormState._buildInterestNodes()');
    _generatePositions(_interests.length);
    for (Interests interest in _interests) {
      _bubbleChartNodes.add(Positioned(
        top: _bubbleNodes[0][index].toDouble() + _interests.length,
        left: _bubbleNodes[1][index].toDouble() + _interests.length,
        child:
            CircleButton(addInterest: widget.addInterest, interest: interest),
      ));
      index += 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _buildInterestNodes();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.13),
        padding: EdgeInsets.zero,
        width: size.width + (size.width * 0.5),
        height: size.height * 0.47,
        child: Stack(
          alignment: Alignment.center,
          children: _bubbleChartNodes,
        ),
      ),
    );
  }
}

class CircleButton extends StatefulWidget {
  final Function addInterest;
  final Interests interest;

  const CircleButton({
    Key? key,
    required this.addInterest,
    required this.interest,
  }) : super(key: key);

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  final Color _colorOne = const Color(0xff1E4B6C);
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double radius = (widget.interest.name.length % 2) == 0
        ? size.height * 0.067
        : size.height * 0.098;

    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.addInterest(widget.interest);
      },
      child: Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
          color: _isSelected ? _colorOne : Colors.transparent,
          border: Border.all(
            color: _isSelected ? Colors.transparent : _colorOne,
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            widget.interest.name,
            style: TextStyle(
              fontSize: 16,
              color: _isSelected ? Colors.white : _colorOne,
            ),
          ),
        ),
      ),
    );
  }
}
