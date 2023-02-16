import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/my_constants.dart';
import '../widgets/form_header_widget.dart';
import '../widgets/name_and_contact_details_form.dart';
import '../widgets/gender_form.dart';
import '../widgets/user_interests_form.dart';
import '../widgets/user_avatar_form.dart';

class SignUpForm extends StatefulWidget {
  static const String routeName = '/new_user_sign_up_form';

  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _nameAndContactDetailsFormKey =
      GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _userGender = Genders.Male.name;
  final List<String> _userInterests = [];
  late List<Map<String, dynamic>> _forms;
  final List<QueryDocumentSnapshot<Object?>> _interests = [];
  final List<QueryDocumentSnapshot<Object?>> _avatars = [];

  int _formIndex = 0;
  bool _isLoading = true;
  String _chosenAvatarId = '0';
  bool _registering = false;
  bool _registered = false;

  void _selectAvatar(String avatarId) {
    setState(() {
      _chosenAvatarId = avatarId;
    });
  }

  List<QueryDocumentSnapshot<Object?>>? _getAllDocs(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) => doc).toList();
  }

  Future<void> _registerUser() async {
    setState(() {
      _registering = true;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) async {
        User? userInstance = value.user;

        await userInstance?.updateDisplayName(_nickNameController.text);
        await FirebaseFirestore.instance
            .collection('avatars')
            .where('id', isEqualTo: int.parse(_chosenAvatarId))
            .limit(1)
            .get()
            .then((result) async {
          if (kDebugMode) {
            print('Logggg - ${result.docs.first.data()}');
          }
          await userInstance?.updatePhotoURL(result.docs.first.data()['png_uri']);
        }).catchError((_, error) {
          if (kDebugMode) {
            print('error saving details');
          }
        });

        await FirebaseFirestore.instance.collection('user_details').add({
          'email': _emailController.text,
          'phone_number': _phoneController.text,
          'nick_name': _nickNameController.text,
          'interests': _userInterests,
          'gender': _userGender,
          'avatar_id': _chosenAvatarId,
        });
        if (value.user != null) {
          setState(() {
            _registered = true;
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      // TODO
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'An Error occurred'),
      ));
    }
  }

  void _goBack() {
    if (_formIndex != 0) {
      setState(() {
        _formIndex = _formIndex - 1;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _nextForm() {
    log(
      _emailController.text,
      name:
          '_SignUpFormState._nextForm() /checking if inputs were retained/ emailController.text',
    );

    if (_formIndex == 2 && _userInterests.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Select at least 5 topics!'),
        backgroundColor: Color(0xff1E4B6C),
      ));
      return;
    }

    if (_formIndex == 0) {
      if (_passwordController.text.length < 7) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password must be at least 7 characters!'),
          backgroundColor: Color(0xff1E4B6C),
        ));
        return;
      } else if (!_emailController.text.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enter a valid email address!'),
          backgroundColor: Color(0xff1E4B6C),
        ));
        return;
      }
    }

    if (_formIndex < (_forms.length - 1)) {
      setState(() {
        _formIndex = _formIndex + 1;
      });
    } else {
      _registerUser().then((value) {
        setState(() {
          _registering = false;
        });
        if (_registered) {
          Navigator.of(context).pop();
        }
        // Navigator.of(context).popAndPushNamed(NewsFeedWidget.routeName);
      });
    }
  }

  void _changeUserGender(String newGender) {
    setState(() {
      _userGender = newGender;
    });
    log('User gender = $_userGender');
  }

  void _addInterest(String interestId) {
    int index = _userInterests.indexOf(interestId);
    if (index == -1) {
      _userInterests.add(interestId);
      log(
        'interest added',
        name: '_SignUpFormState._addInterest()',
        time: DateTime.now(),
      );
    } else {
      _userInterests.removeAt(index);
      log(
        'interest removed',
        name: '_SignUpFormState._addInterest()',
        time: DateTime.now(),
      );
    }
    log(
      'total interests: ${_userInterests.length.toString()}',
      name: '_SignUpFormState._addInterest()',
      time: DateTime.now(),
    );
  }

  Future<void> _fetchInterestsAndAvatars() async {
    await FirebaseFirestore.instance
        .collection('topics')
        .snapshots()
        .first
        .then((value) {
      var temp = _getAllDocs(value);
      for (var i in temp!) {
        _interests.add(i);
      }
    });
    await FirebaseFirestore.instance
        .collection('avatars')
        .snapshots()
        .first
        .then((value) {
      var temp = _getAllDocs(value);
      for (var i in temp!) {
        _avatars.add(i);
      }
    });
  }

  Future<void> _buildForms() async {
    log(
      'building forms...',
      name: '_SignUpFormState._buildForms()',
      time: DateTime.now(),
    );
    setState(() {
      _forms = [
        {
          'header': 'Hello Again',
          'description': 'Create an account with us for free',
          'form': _buildNameAndContactDetailsForm(),
        },
        {
          'header': 'Let\'s get to know you',
          'description':
              'Tell us more about yourself so we can set-up your feed...',
          'form': _buildGenderForm(),
        },
        {
          'header': 'What topics would you be interested in',
          'description': 'Choose at least 5 topics',
          'form': _buildInterestsForm(),
        },
        {
          'header': 'Select an avatar',
          'description':
              'This is what will be displayed on your The place profile picture which can be changed later if you like.',
          'form': _buildAvatarForm(),
        },
      ];
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0.0,
      leading: Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.zero,
        child: _formIndex > 0
            ? SvgPicture.asset(
                'assets/icons/the_place_icon.svg',
                fit: BoxFit.contain,
              )
            : IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Back to landing page',
                // iconSize: MediaQuery.of(context).size.height * 0.06,
                onPressed: () => _goBack(),
                icon: SvgPicture.asset(
                  'assets/icons/back_button.svg',
                  fit: BoxFit.contain,
                ),
              ),
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.13,
      actions: _formIndex > 0
          ? [
              TextButton(
                onPressed: () => _nextForm(),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E4B6C),
                  ),
                ),
              )
            ]
          : [],
    );
  }

  Widget _buildFormHeader(String header, String description) {
    return MyFormHeader(header: header, description: description);
  }

  Widget _buildNameAndContactDetailsForm() {
    final List<Map<String, dynamic>> formHints = [
      {
        'hint': 'Email',
        'controller': _emailController,
        'actionType': TextInputAction.next,
        'keyboardType': TextInputType.emailAddress,
      },
      {
        'hint': 'Nickname',
        'controller': _nickNameController,
        'actionType': TextInputAction.next,
        'keyboardType': TextInputType.name,
      },
      {
        'hint': 'Password',
        'controller': _passwordController,
        'actionType': TextInputAction.next,
        'keyboardType': TextInputType.visiblePassword,
      },
      {
        'hint': 'Phone number',
        'controller': _phoneController,
        'actionType': TextInputAction.done,
        'keyboardType': TextInputType.phone,
      },
    ];

    return NameAndDetailsForm(
      nameAndContactDetailsFormKey: _nameAndContactDetailsFormKey,
      formEntries: formHints,
    );
  }

  Widget _buildGenderForm() {
    return GenderForm(changeGender: _changeUserGender);
  }

  Widget _buildInterestsForm() {
    log(
      'building form',
      name: '_SignUpFormState._buildInterestsForm()',
    );
    return CircleScatteredWidget(
      interests: _interests,
      addOrRemoveInterest: _addInterest,
    );
  }

  Widget _buildAvatarForm() {
    return AvatarForm(
      avatarURIs: _avatars,
      setAvatar: _selectAvatar,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchInterestsAndAvatars().then((value) {
      return _buildForms();
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _isLoading
        ? Scaffold(
            body: SizedBox(
              height: size.height,
              width: size.width,
              child: Center(
                child: const CircularProgressIndicator().animate().fadeIn(),
              ),
            ),
          )
        : Scaffold(
            appBar: _buildAppBar(),
            body: Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.04,
              ),
              height: size.height,
              width: size.width,
              child: _forms.isEmpty
                  ? Center(
                      child: const CircularProgressIndicator(
                        semanticsLabel: 'Loading...',
                      ).animate().fadeIn(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                            ),
                            child: _buildFormHeader(
                              _forms[_formIndex]['header'],
                              _forms[_formIndex]['description'],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.631,
                            width: size.width,
                            child: _forms[_formIndex]['form'],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize:
                                    Size(size.width, size.height * 0.067),
                                backgroundColor: const Color(0xff1E4B6C),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                if (!_registering) {
                                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please wait...'),));
                                  _nextForm();
                                }
                              },
                              child: _registering
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      (_formIndex == (_forms.length - 1))
                                          ? 'Sign up'
                                          : 'Continue',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
  }
}
