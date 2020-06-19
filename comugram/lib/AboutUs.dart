import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.orange,
          title: Text("Tentang"),
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              // ini kaya bikin shape yang bisa di customize sisi nya
              clipper: CustomShapeClipper(),
              child: Container(
                height: 350,
                decoration: BoxDecoration(color: Colors.orange,),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Image.asset('images/comugram logo 4.png', width: 300, height: 300,),
                  Text(
                    'Comugram wadah anda berkomunitas, \nbagikan kegiatan anda ke orang orang yang berada dalam komunitas anda.\n\n'
                        '\ndibuat oleh :\n'
                        '\nWilhelmus Krisvan'
                        '\nHandi Hermawan'
                        '\nWayan Edi Sudarma\n',
                    style: TextStyle(fontSize: 16, ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 20),
              child:Text('Copyright \u00a9 2020 by Comugram\'s Team',),
            )
          ],
        )
    );
  }
}
class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2, 280, size.width, 390.0 - 200.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}