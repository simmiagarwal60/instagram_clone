import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_page.dart';
import 'package:instagram_clone/util/utils.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
    try{
      setState(() {
        isLoading = true;
      });
      var userSnap = await FirebaseFirestore.instance.collection('simran').doc(widget.uid).get();
      //get Post Length
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
    }
    catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading? const Center(
      child: CircularProgressIndicator(),
    ): Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(userData['username']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(16)),
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStatColumn(postLen, 'posts'),
                            buildStatColumn(followers, 'followers'),
                            buildStatColumn(following, 'following'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == widget.uid? FollowButton(
                              text: 'Sign Out',
                              backgroundColor: Colors.black87,
                              borderColor: Colors.grey,
                              textColor: Colors.white,
                              function: () async{
                                await AuthMethods().signOut();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                              },

                            ): isFollowing? FollowButton(
                              text: 'Unfollow',
                              backgroundColor: Colors.black87,
                              borderColor: Colors.grey,
                              textColor: Colors.white,
                              function: () async{
                                await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);

                                setState(() {
                                  isFollowing = false;
                                  followers--;
                                });
                              },
                            ): FollowButton(
                              text: 'Follow',
                              backgroundColor: Colors.blue,
                              borderColor: Colors.blue,
                              textColor: Colors.white,
                              function: () async{
                                await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);
                                setState(() {
                                  isFollowing = true;
                                  followers++;
                                });

                              },

                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 15,),
                  child: Text(
                    userData['username'], style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    userData['bio']
                  ),
                  ),
                ),

            ],
          ),
          const Divider(),
          FutureBuilder(builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 1.5,
                childAspectRatio: 1),
                shrinkWrap: true,
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index){
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                  return Container(
                    child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
            },);
          },
          future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),),
        ],
      ),
    );
  }
  Column buildStatColumn(int num, String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        Container(
          margin: const EdgeInsets.only(top: 4),
            child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),)),
      ],
    );
  }
}
