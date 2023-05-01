import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/util/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/screens/comments_screen.dart';

import '../resources/firestore_methods.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState(){
    super.initState();
    getComments();
  }

  void getComments() async{
    try{
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();

      commentLen = snap.docs.length;
    }
    catch(err){
      showSnackBar(err.toString(), context);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final user users = Provider
        .of<userProvider>(context)
        .getUser;
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        //Header section
          children: [
      Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
          .copyWith(right: 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(widget.snap['profImage'].toString(),),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    Dialog(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shrinkWrap: true,
                        children: [
                          'Delete',
                        ]
                            .map(
                              (e) =>
                              InkWell(
                                onTap: () async{
                                  FirestoreMethods().deletePost(widget.snap['postId']);
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: Text(e),
                                ),
                              ),
                        )
                            .toList(),
                      ),
                    ),
              );
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
    ),
    GestureDetector(
    onDoubleTap:() async {
    await FirestoreMethods().likePost(
    widget.snap['postId'].toString(),
    users.uid,
    widget.snap['likes']
    );
    setState(() {
    isLikeAnimating = true;
    });
    } ,
    child: Stack(
    alignment: Alignment.center,
    children: [SizedBox(
    height: MediaQuery.of(context).size.height * 0.35,
    width: double.infinity,
    child: Image.network(widget.snap['postUrl'].toString(),
    fit: BoxFit.cover,
    ),
    ),
    AnimatedOpacity(
    opacity: isLikeAnimating? 1:0,
    duration: Duration(milliseconds: 200) ,
    child: LikeAnimation(
    child: const Icon(Icons.favorite, color: Colors.white, size: 100,),
    isAnimating: isLikeAnimating,
    duration: Duration(milliseconds: 400),
    onEnd: () {
    setState(() {
    isLikeAnimating = false;
    });
    },),
    )
    ]
    ),
    ),

    //like comment share section
    Row(
    children: [
    LikeAnimation(
    isAnimating: widget.snap['likes'].contains(users.uid),
    smallLike: true,
    child: IconButton(
    onPressed: () async {
    await FirestoreMethods().likePost(
    widget.snap['postId'].toString(),
    users.uid,
    widget.snap['likes']
    );},
    icon: widget.snap['likes'].contains(users.uid)? const Icon(
    Icons.favorite,
    color: Colors.red,
    ): const Icon(Icons.favorite_border,),
    ),
    ),
    IconButton(
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen(
        snap: widget.snap,
      ),),);
    },
    icon: Icon(
    Icons.comment_outlined,
    ),
    ),
    IconButton(
    onPressed: () {},
    icon: Icon(
    Icons.send,
    ),
    ),
    Expanded(
    child: Align(
    alignment: Alignment.bottomRight,
    child: IconButton(
    onPressed: () {},
    icon: Icon(Icons.bookmark_border),
    ),
    ),
    ),
    ],
    ),
    //Description and comments
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    DefaultTextStyle(
    style: Theme.of(context).textTheme.subtitle2!.copyWith(
    fontWeight: FontWeight.w800,
    ),
    child: Text(
    '${widget.snap['likes'].length} likes',
    style: Theme.of(context).textTheme.bodyText2,
    ),
    ),
    Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: 8),
    child: RichText(
    text: TextSpan(
    style: TextStyle(color: Colors.white),
    children: [
    TextSpan(
    text: widget.snap['username'],
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    TextSpan(
    text: ' ${widget.snap['description']}',
    ),
    ],
    ),
    ),
    ),
    InkWell(
    onTap: () {},
    child: Container(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
    'View all $commentLen comments',
    style: TextStyle(fontSize: 16, color: Colors.white38),
    ),
    ),
    ),
    Container(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
    DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
    style: TextStyle(fontSize: 16, color: Colors.white38),
    ),
    ),
    ],
    ),
    )
    ],
    ),
    );
    }
  }
