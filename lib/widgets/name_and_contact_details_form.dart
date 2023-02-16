import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import '../screens/sign_in_form_screen.dart';

class NameAndDetailsForm extends StatefulWidget {
  final GlobalKey<FormState> nameAndContactDetailsFormKey;
  final List<Map<String, dynamic>> formEntries;

  const NameAndDetailsForm({
    Key? key,
    required this.nameAndContactDetailsFormKey,
    required this.formEntries,
  }) : super(key: key);

  @override
  State<NameAndDetailsForm> createState() => _NameAndDetailsFormState();
}

class _NameAndDetailsFormState extends State<NameAndDetailsForm> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
      child: Form(
          key: widget.nameAndContactDetailsFormKey,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.formEntries.length + 1,
            itemBuilder: (ctx, index) {
              Size size = MediaQuery.of(ctx).size;
              return (index == widget.formEntries.length)
                  ? Container(
                      height: size.height * 0.022,
                      width: size.width,
                      margin: EdgeInsets.only(top: size.height * 0.19),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                  color: Color(0xffB4B4B4), fontSize: 16),
                            ),
                            SizedBox(
                              width: size.width * 0.135,
                              child: TextButton(
                                onPressed: () => Navigator.of(context).popAndPushNamed(SignInForm.routeName),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Color(0xff1E4B6C),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(ctx).size.height * 0.014),
                      child: TextFormField(
                        controller: widget.formEntries[index]['controller']
                            as TextEditingController,
                        decoration: InputDecoration(
                          labelText: widget.formEntries[index]['hint'] as String,
                          hintText: widget.formEntries[index]['hint'] as String,
                          hintStyle: const TextStyle(
                            color: Color(0xffB4B4B4),
                            fontSize: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xff1E4B6C), width: 0.9),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xff1E4B6C), width: 1.2),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          enabled: true,
                          suffixIcon: (widget.formEntries[index]['hint'] == 'Password') ? IconButton(onPressed: (){
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          }, icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),) : null,
                        ),
                        autocorrect: (widget.formEntries[index]['hint'] == 'Password')
                            ? false
                            : true,
                        obscureText: (widget.formEntries[index]['hint'] == 'Password')
                            ? _isObscured
                            : false,
                        textInputAction: widget.formEntries[index]['actionType'],
                        keyboardType: widget.formEntries[index]['keyboardType'],
                      ),
                    );
            },
          ),),
    ).animate().slideX(curve: Curves.fastOutSlowIn);
  }
}
