import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/responsive/responsive_screen_layout.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/screens/login_page.dart';
import 'package:instagram_clone/util/colors.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

import '../util/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
  }

  void navigateToSignin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: Colors.white,
                height: 64,
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5OjcBCgoKDQwNGg8PGjclHyU3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3N//AABEIAH8AfwMBIgACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAAABAUDBgcBAv/EADMQAAICAQICBwYFBQAAAAAAAAABAgMEBREhMQYSE0FRccEjMmGBkaEHIkJS0RRicoLw/8QAFgEBAQEAAAAAAAAAAAAAAAAAAAEC/8QAFhEBAQEAAAAAAAAAAAAAAAAAAAER/9oADAMBAAIRAxEAPwDuIAAAAAAAAAAAAAAAAAAAAAAAAB5JpJtvbYD0wXZVVXBveXguZDys2U94VNqPj3shlkRNnqE+UIpefEwvMvf69vJGAFwSFm3r9afmjNXqEt9rIJ+RBAwXNORXcvyS4+D5mYoOT3J+JmvhC5+Uv5JhqwATBFAAAAAArM/I683XD3VzfiyZmW9lQ2vefBFOWAACsgMOZl04WPLIybFCuPN+PwXxNRzOmOTKbWHj1119zs/NJ+iA3QGn6f0xs7RR1CiDg+dlW6a+T5m202130wtpmp1zXWjKL4NAfYAKJ+n5G77Kf+r9CwKGLaaaezXIuqLFbVGa70ZqxkABFAABWalP2sYruW5DM+c98qfyMBqIAAI0TpnnyyNS/pYy9lj7cPGbXF+n1NfLDpDFx1zOT59q39eJXlA2voNnS7S3AnLeDj2ta8H3r1+pqhd9DYuWu1tL3a5t/Tb1COgAAihYaZPeM4Pu4oryXpj9vJf2irFoADKgAAqM9bZUvikyOTdTh+eE1ya2IRqIAAI03prplkchajVHeuaUbdv0yXJ+T9PiasdbcVJOLSkmtmmt90UWboehOze5V47fHaFvU+wGgm6dDNMsx6rM66PVlalGtPn1ebfz9Cdp+i6LCanjQqvlF8HKztNvlyLkAAABM0xe2k/CJDLHTIbVym17z4CrE4AGVAABhyqu2pce/mvMpmtnxWxfldqGNxdta/yXqWJUErtZ1jH0mlO19e2XuVR5v+F8TPqebXp+DZlW8VBcI/ub5I5pl5NuZkTyMifWsm92/RfA0idqWu5+oSanc66nyqqeyXqyrSS5IAGi4NPvXJ+Bc6Z0kz8GSjOf9RT+yx8fk+a+5TADqGmajj6njq3Gnvt70H70X4MlnMNK1C7TcyGRTx7pw7px8DpeNfXlUV30y61dkVKLXgwMsIynJRiuLeyLuqCrrjCPJIi4GN2a7Sa/O1wXgiaZrQACAAAAYAGp9NdBy9Sxq3p7i+zbnKlvbrv4ffgc0tqsoslXdCVdkeEoyWzR3fbcgano+n6nX1M7Ghbtyk+Eo+TXFFlSxxQHQc38PKJtywc2yr+22HXX1W3qVln4faon7PIxJrxcpL0NamNRBt9X4fanJ+1ysWC8U5S9EW2D+H2FU1LOyrch/tguzj6v7obDGgYmLkZl0acSmdtsuUYrf/kdU6JaNkaZpsas6cJ2qTlGMeKrT7viWuDp+Hp9PZYWPXTDvUFz833kpGbVkegAigAAAAAAAAAAAAAAAAAAAAAAAP/Z'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _usernameController,
                  isPass: false,
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  isPass: false,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _passwordController,
                  isPass: true,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: _bioController,
                  isPass: false,
                  hintText: 'Enter your bio',
                  textInputType: TextInputType.text),
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signupUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text('Sign up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Already have an account?"),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                  GestureDetector(
                    onTap: navigateToSignin,
                    child: Container(
                      child: Text(
                        "Sign in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
