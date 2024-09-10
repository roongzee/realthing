import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import
import 'register_face_screen.dart';
import 'my_video_screen.dart'; // 새 화면 import

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account Information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountInfoScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.video_library),
            title: Text('My Videos'), // 이름 변경
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyVideosScreen()), // 새 화면으로 연결
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Recently Watched'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecentlyWatchedScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Register Face'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterFaceScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async {
              // 로그아웃 처리
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');  // 토큰 제거
              await prefs.remove('user_email');  // 이메일 제거

              // 로그아웃 후 로그인 화면으로 이동
              Navigator.pushReplacementNamed(context, '/login');  // 로그인 화면으로 이동
            },
          ),
        ],
      ),
    );
  }
}

// 세부 화면들...

class AccountInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
      ),
      body: Center(child: Text('Account Information')),
    );
  }
}

class RecentlyWatchedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recently Watched'),
      ),
      body: Center(child: Text('Recently Watched Videos')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(child: Text('Settings Content')),
    );
  }
}
