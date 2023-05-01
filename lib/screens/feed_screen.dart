import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/util/globalVariables.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width> webScreenSize? null: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: false,
        title: SvgPicture.asset('assets/images/ic_instagram.svg',
        color: Colors.white,
        height: 32,),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.message_outlined),),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemBuilder: (context, index) => PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
          itemCount: snapshot.data!.docs.length,);
        }
      ) ,
    );
  }
}
