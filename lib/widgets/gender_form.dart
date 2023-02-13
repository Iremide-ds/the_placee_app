import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../constants/my_constants.dart';

class GenderForm extends StatefulWidget {
  final Function changeGender;

  const GenderForm({Key? key, required this.changeGender}) : super(key: key);

  @override
  State<GenderForm> createState() => _GenderFormState();
}

class _GenderFormState extends State<GenderForm> {
  final List<Genders> genderOptions = Genders.values;
  Genders _gender = Genders.Male;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const Color primaryColor = Color(0xff1E4B6C);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05,),
      child: Column(
        children: [
          const Expanded(
              child: Text(
            'I am...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xffB4B4B4),
            ),
          )),
          SizedBox(
            height: size.height * 0.6,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: genderOptions.length,
              itemBuilder: (ctx, index) {
                return SizedBox(
                  height: size.height * 0.063,
                  width: size.width,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      genderOptions[index].name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                    leading: Radio(
                      fillColor: MaterialStateProperty.all(primaryColor),
                      value: genderOptions[index],
                      groupValue: _gender,
                      onChanged: (Genders? newGender) {
                        setState(() {
                          _gender = newGender!;
                        });
                        widget.changeGender(_gender.name);
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    ).animate().slideX(curve: Curves.fastOutSlowIn);
  }
}
