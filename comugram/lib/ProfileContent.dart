import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comugram/EditProfile.dart';
import 'package:comugram/HomeContent.dart';
import 'package:comugram/Login.dart';
import 'package:comugram/ResetPassword.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'model/User.dart';

class ProfileContent extends StatefulWidget {
  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> with SingleTickerProviderStateMixin{
  User profile;
  int cPost,cOwn,cJoined;
  FirestoreServices Fs = FirestoreServices();
  bool _progressController = true;

  void SignOut() async{
    GoogleSignIn g = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await g.signOut();
  }

  void initialDisplayProfile()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection('User').document(user.uid).get().then((snapshot){
      profile = User.fromMap(snapshot.data);
      setState(() {
        profile;
        _progressController = false;
      });
    });
    await Firestore.instance.collection('Post').where('id_user', isEqualTo: profile.uid).getDocuments().then((value){
      setState(() {
        cPost = value.documents.length;
      });
    });
    await Firestore.instance.collection('joined').where('id_user', isEqualTo: profile.uid).getDocuments().then((value){
      setState(() {
        cJoined = value.documents.length;
      });
    });
    await Firestore.instance.collection('Komunitas').where('owner', isEqualTo: profile.uid).getDocuments().then((value){
      setState(() {
        cOwn = value.documents.length;
      });
    });
  }


  @override
  void initState() {
    initialDisplayProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _progressController? Scaffold(body: Center(child: CircularProgressIndicator()),) : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: Text("${profile.username}", style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15,),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.settings,color: Colors.white, size: 30,),
              onSelected: (String result){
                print(result);
                if(result == 'pickReset'){
                  Navigator.push(this.context, MaterialPageRoute(builder: (BuildContext context) => ResetPassword()));
                }else{
                  print(result);//
                  SignOut();
                  Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (BuildContext context) => Login()));
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                    value: 'pickReset',
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.lock_open,color: Colors.orange,),
                        SizedBox(width: 5,),
                        Text('Reset Password'),
                      ],
                    )
                ),
                PopupMenuItem(
                  value: 'pickSignOut',
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.power_settings_new,color: Colors.orange,),
                      SizedBox(width: 5,),
                      Text('SignOut'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: Colors.white,
                        height: 275,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 10, top: 15),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: profile.urlProfile != null ? Image.network(profile.urlProfile) : Image.asset('images/user.png'),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("${profile.namaLengkap}", style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.alternate_email,size: 17,color: Colors.orange,),
                                          SizedBox(width: 5,),
                                          Text('${profile.email}',style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      cPost == null? CircularProgressIndicator() : Text("$cPost", style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("Post", style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 15,
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      cOwn == null? CircularProgressIndicator() : Text("$cOwn", style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("Owned Komunitas", style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 15,
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      cJoined == null? CircularProgressIndicator() : Text("$cJoined", style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("Joined Komunitas", style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 15,
                                      ),),
                                    ],
                                  ),
                                ],
                              ),
                              Padding (
                                padding: EdgeInsets.only(top: 25.0,bottom:15.0,right: 10),
                                child: Row(
                                  children: <Widget> [
                                    Expanded(
                                      child: Material(
                                        elevation: 1.0,
                                        color: Color.fromRGBO(255, 153, 0, 1),
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.push(this.context, MaterialPageRoute(builder: (BuildContext context) => EditProfile(profile)));
                                          },
                                          child: Text('Edit Profile',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              Container(
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                ),
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.orange,
                  indicator: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  ),
                  tabs: [
                    Tab(icon: Icon(Icons.apps), text: 'Post',),
                    Tab(icon: Icon(Icons.supervised_user_circle), text: 'Owned Komunitas',),
                    Tab(icon: Icon(Icons.group_work), text: 'Joined Komunitas',),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    HomeContent(),
                    HomeContent(),
                    HomeContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}