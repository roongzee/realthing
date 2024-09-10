import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyVideosScreen extends StatefulWidget {
  @override
  _MyVideosScreenState createState() => _MyVideosScreenState();
}

class _MyVideosScreenState extends State<MyVideosScreen> {
  List<String> _uploadedVideos = [];
  List<String> _processedVideos = [];

  @override
  void initState() {
    super.initState();
    _loadUploadedVideos();  // 업로드된 비디오 불러오기
    _loadProcessedVideos(); // 처리된 비디오 불러오기
  }

  // 업로드된 비디오 불러오기
  Future<void> _loadUploadedVideos() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/api/video/upload/')); // 업로드된 비디오 엔드포인트
      if (response.statusCode == 200) {
        final List<dynamic> videoData = jsonDecode(response.body);

        // 응답 데이터 출력 (디버깅)
        print("Uploaded video data: $videoData");

        // 데이터를 List<String>으로 변환
        setState(() {
          _uploadedVideos = videoData
              .where((data) => data is Map<String, dynamic> && data.containsKey('video_url')) // 올바른 데이터만 필터링
              .map<String>((data) => data['video_url'].toString()) // 각 항목을 String으로 변환
              .toList(); // List<String>으로 변환
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load uploaded videos')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred while loading uploaded videos')));
    }
  }


// 처리된 비디오 불러오기
  Future<void> _loadProcessedVideos() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/api/video/upload/edited/')); // 처리된 비디오 엔드포인트
      if (response.statusCode == 200) {
        final List<dynamic> videoData = jsonDecode(response.body);

        // 응답 데이터 출력 (디버깅)
        print("Processed video data: $videoData");

        // 데이터를 List<String>으로 변환
        setState(() {
          _processedVideos = videoData
              .where((data) => data is Map<String, dynamic> && data.containsKey('video_url')) // 올바른 데이터만 필터링
              .map<String>((data) => data['video_url'].toString()) // 각 항목을 String으로 변환
              .toList(); // List<String>으로 변환
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load processed videos')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred while loading processed videos')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Videos'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildVideoSection('Uploaded Videos', _uploadedVideos),
          Divider(),
          _buildVideoSection('Processed Videos', _processedVideos), // 처리된 비디오 섹션
        ],
      ),
    );
  }

  Widget _buildVideoSection(String title, List<String> videos) {
    return ExpansionTile(
      title: Text(title),
      children: videos.map((videoPath) => _buildVideoTile(videoPath)).toList(),
    );
  }

  Widget _buildVideoTile(String videoPath) {
    return ListTile(
      leading: Icon(Icons.play_circle_fill),
      title: Text(videoPath.split('/').last),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoPath: videoPath),
          ),
        );
      },
    );
  }
}

// 비디오 플레이어 화면
class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  VideoPlayerScreen({required this.videoPath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
