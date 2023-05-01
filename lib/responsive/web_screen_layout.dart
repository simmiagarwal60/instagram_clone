import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/util/globalVariables.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';

class WebScreenLayout extends StatefulWidget{
  WebScreenLayout({Key? key}) : super(key:key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController1;

  @override
  void initState() {
    pageController1 = PageController();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    pageController1.dispose();
  }

  void navigationTapped(int page){
    pageController1.jumpToPage(page);
    setState(() {
      _page = page;
    });

  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: false,
        title: SvgPicture.asset('assets/images/ic_instagram.svg',
          color: Colors.white,
          height: 32,),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            icon: Icon(Icons.home), color: _page == 0? Colors.white: Colors.grey,),
          IconButton(
            onPressed: () => navigationTapped(1),
            icon: Icon(Icons.search),color: _page == 1? Colors.white: Colors.grey,),
          IconButton(
            onPressed: () => navigationTapped(2),
            icon: Icon(Icons.add_a_photo),color: _page == 2? Colors.white: Colors.grey,),
          IconButton(
            onPressed: () => navigationTapped(3),
            icon: Icon(Icons.favorite),color: _page == 3? Colors.white: Colors.grey,),
          IconButton(
            onPressed: () => navigationTapped(4),
            icon: Icon(Icons.person),color: _page == 4? Colors.white: Colors.grey,),

        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController1,
        children: homeScreenItems,
        onPageChanged: onPageChanged,
      ),

    );
  }
}