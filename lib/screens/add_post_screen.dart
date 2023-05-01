import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/util/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  _selectImage(BuildContext context) async{
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: Text('Take a photo'),
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: Text('Choose from gallery'),
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: Text('Cancel'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  void postImage(
    String username,
    String uid,
    String profImage,
) async{
    setState(() {
      _isLoading = true;
    });
    try{
      String res = await FirestoreMethods().uploadPost(_descriptionController.text, uid, _file!, username, profImage);

      if(res == 'success'){
        setState(() {
          _isLoading = false;
        });

        showSnackBar('Posted!', context);
        clearImage();
      }
      else{
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    }
    catch(e){
      showSnackBar(e.toString(), context);
    }
  }


  @override
  void dispose(){
    super.dispose();
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final user users = Provider.of<userProvider>(context).getUser;

    return _file == null? Center(
      child: IconButton(icon: Icon(Icons.upload),
      onPressed: ()=> _selectImage(context)),
    )
     :Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: clearImage),
        title: const Text('Post to'),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () => postImage(
            users.username,
            users.uid,
            users.photoUrl),
              child: const Text('Post', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: 16,
              ),
              ),
          ),
        ]
      ),
      body: Column(
        children: [
          _isLoading? const LinearProgressIndicator(): Padding(padding: EdgeInsets.only(top: 0),),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1549492423-400259a2e574?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YmFjayUyMGdyb3VuZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60'),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*0.45,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
                maxLines: 8,
              ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      )
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          )
        ],
      ),
    );
  }
}
