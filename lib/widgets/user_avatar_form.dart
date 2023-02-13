import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_svg/flutter_svg.dart';

// import '../constants/my_constants.dart';

class AvatarForm extends StatefulWidget {
  final List avatarURIs;
  final Function setAvatar;

  const AvatarForm({Key? key, required this.avatarURIs, required this.setAvatar}) : super(key: key);

  @override
  State<AvatarForm> createState() => _AvatarFormState();
}

class _AvatarFormState extends State<AvatarForm> {
  String _chosenAvatar = '';

  void _selectAvatar(String avatar) {
    setState(() {
      _chosenAvatar = avatar;
    });
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      _chosenAvatar = widget.avatarURIs[0]['uri'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: size.height * 0.15,
          backgroundColor: Colors.transparent,
          child: SvgPicture.network(
            _chosenAvatar,
            height: size.height * 0.15,
            width: size.width * 0.15,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            semanticsLabel: 'User Avatar',
          ),
        ),
        SizedBox(
          width: size.width * 0.64,
          height: size.height * 0.057,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              backgroundColor: const Color(0xffEBEBEB),
            ),
            onPressed: () {},
            child: const Text(
              'Select',
              style: TextStyle(
                color: Color(0xff1E4B6C),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: size.height * 0.025),
          width: size.width,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: widget.avatarURIs.map((avatar) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          (avatar['uri'].toLowerCase() == _chosenAvatar.toLowerCase())
                              ? const Color(0xffEBEBEB)
                              : Colors.transparent,
                      elevation: 0.0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8.0)),
                  onPressed: () {
                    _selectAvatar(avatar['uri']);
                    widget.setAvatar(avatar['id'].toString());
                  },
                  child: SvgPicture.network(avatar['uri'], placeholderBuilder: (ctx) {
                    return const CircularProgressIndicator();
                  },));
            }).toList(),
          ),
        ),
      ],
    ).animate().slideX(curve: Curves.fastOutSlowIn);
  }
}
