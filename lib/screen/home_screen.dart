//home_screen.dart
import 'package:flutter/material.dart';
import '../model/video_model.dart';
import '../widget/video_player.dart';
import 'video_player_screen.dart';
import 'action_select_screen.dart';
import 'upload_video_screen.dart';
import 'account_screen.dart'; // AccountScreen을 import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _selectedIndex = 0; // 현재 선택된 하단 네비게이션 바의 인덱스
  final List<String> _categories = ['All', 'Mukbang', 'Games', 'Sports', 'Daily'];

  final List<Video> _videos = [
    Video(path: 'assets/video/ex01.mp4', category: 'Mukbang'),
    Video(path: 'assets/video/ex02.mp4', category: 'Games'),
    Video(path: 'assets/video/ex03.mp4', category: 'Sports'),
    Video(path: 'assets/video/ex04.mp4', category: 'Daily'),
    Video(path: 'assets/video/ex05.mp4', category: 'Games'),
    Video(path: 'assets/video/ex06.mp4', category: 'Sports'),
    Video(path: 'assets/video/ex07.mp4', category: 'Daily'),
  ];

  void _addVideo(Video video) {
    setState(() {
      _videos.add(video);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Video> filteredVideos = _selectedCategoryIndex == 0
        ? _videos
        : _videos.where((video) => video.category == _categories[_selectedCategoryIndex]).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PrivStream',
          style: TextStyle(color: Colors.pink),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _buildBody(filteredVideos), // 현재 선택된 탭에 따라 다른 화면을 표시
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Video? uploadedVideo = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadVideoScreen(
                onVideoUploaded: (video) {
                  // 업로드 후 비디오를 반환하여 HomeScreen에서 처리
                  Navigator.pop(context, video);
                },
              ),
            ),
          );

          if (uploadedVideo != null) {
            _addVideo(uploadedVideo);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library), // 동영상 아이콘으로 변경
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 3) {  // Account 탭이 선택된 경우
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildBody(List<Video> filteredVideos) {
    // 현재 선택된 탭에 따라 화면을 다르게 표시
    switch (_selectedIndex) {
      case 0: // 홈 화면 콘텐츠
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recommended Videos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredVideos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            videoPath: filteredVideos[index].path,
                          ),
                        ),
                      );
                    },
                    child: _buildVideoCard(filteredVideos[index].path),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: _buildCategoryBar(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredVideos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            videoPath: filteredVideos[index].path,
                          ),
                        ),
                      );
                    },
                    child: _buildVerticalVideoItem(filteredVideos[index].path),
                  );
                },
              ),
            ),
          ],
        );
      case 1: // 구독 콘텐츠
        return Center(child: Text('Subscriptions Content'));
      case 2: // 비디오 탭 콘텐츠
        return Center(child: Text('Video Content')); // 비디오 탭을 선택했을 때의 콘텐츠
      default:
        return Center(child: Text('Home Content'));
    }
  }

  Widget _buildVideoCard(String videoPath) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(8.0),
      color: Colors.grey[300],
      child: VideoPlayerWidget(videoPath: videoPath),
    );
  }

  Widget _buildVerticalVideoItem(String videoPath) {
    return ListTile(
      title: Text(videoPath.split('/').last),
      subtitle: Text('Description for ${videoPath.split('/').last}'),
      trailing: Icon(Icons.play_arrow),
    );
  }

  Widget _buildCategoryBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _categories.map((category) {
        int index = _categories.indexOf(category);
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategoryIndex = index;
            });
          },
          child: Text(
            category,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _selectedCategoryIndex == index ? Colors.pink : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
