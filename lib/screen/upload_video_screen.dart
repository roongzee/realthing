//upload_video_screen.dart
/*
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart'; // MediaType import
import '../model/video_model.dart';

class UploadVideoScreen extends StatefulWidget {
  final Function(Video) onVideoUploaded;

  UploadVideoScreen({required this.onVideoUploaded});

  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;
  final TextEditingController _videoNameController = TextEditingController();
  String _selectedCategory = 'Mukbang';
  final List<String> _categories = ['Mukbang', 'Games', 'Sports', 'Daily'];

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null && _videoNameController.text.isNotEmpty) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8000/api/video/upload/'), // Django 백엔드의 비디오 업로드 URL
      );

      var mimeType = lookupMimeType(_videoFile!.path);
      var mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

      request.files.add(await http.MultipartFile.fromPath(
        'video', // Django에서 사용할 파일 키
        _videoFile!.path,
        contentType: mediaType,
      ));

      request.fields['name'] = _videoNameController.text; // 비디오 이름을 전송
      request.fields['category'] = _selectedCategory; // 선택된 카테고리를 전송

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var videoUrl = jsonDecode(responseData.body)['video_url']; // 반환된 URL 가져오기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully.')),
        );

        // 다운로드 기능 호출
        await _downloadVideo(videoUrl);

        final video = Video(
          path: _videoFile!.path, // 로컬 경로로 설정
          category: _selectedCategory,
        );

        widget.onVideoUploaded(video);

        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(); // 홈 화면으로 이동
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video upload failed.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a video and enter a name.')),
      );
    }
  }

  Future<void> _downloadVideo(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String appPath = appDir.path;
        final File file = File('$appPath/downloaded_video.mp4');

        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video downloaded successfully.')),
        );

        // 다운로드된 비디오 경로를 _downloadedVideos 리스트에 추가하여 UI에 반영
        setState(() {
          // 저장된 비디오를 로컬에 보관하거나 UI에 반영할 수 있습니다.
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video download failed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while downloading the video.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Select Video', style: TextStyle(fontSize: 18)),
            ),
            if (_videoFile != null) ...[
              SizedBox(height: 20),
              TextField(
                controller: _videoNameController,
                decoration: InputDecoration(labelText: 'Video Name'),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadVideo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Upload Video', style: TextStyle(fontSize: 18)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
*/
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart'; // MediaType import
import 'package:shared_preferences/shared_preferences.dart';
import '../model/video_model.dart';

class UploadVideoScreen extends StatefulWidget {
  final Function(Video) onVideoUploaded;

  UploadVideoScreen({required this.onVideoUploaded});

  @override
  _UploadVideoScreenState createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;
  final TextEditingController _videoNameController = TextEditingController();
  String _selectedCategory = 'Mukbang';
  final List<String> _categories = ['Mukbang', 'Games', 'Sports', 'Daily'];

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  // SharedPreferences에서 이메일을 가져오는 함수
  Future<String?> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');  // 로그인할 때 저장된 이메일을 가져옴
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null && _videoNameController.text.isNotEmpty) {
      String? email = await _getUserEmail();  // 이메일 가져오기

      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User email not found. Please log in again.')),
        );
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://172.30.1.72:8000/api/video/upload/'), // Django 백엔드의 비디오 업로드 URL
      );

      var mimeType = lookupMimeType(_videoFile!.path);
      var mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

      request.files.add(await http.MultipartFile.fromPath(
        'video', // Django에서 사용할 파일 키
        _videoFile!.path,
        contentType: mediaType,
      ));

      // 비디오 이름, 카테고리, 이메일 필드를 함께 전송
      request.fields['name'] = _videoNameController.text;
      request.fields['category'] = _selectedCategory;
      request.fields['email'] = email;  // 이메일 추가

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var videoUrl = jsonDecode(responseData.body)['video_url']; // 반환된 URL 가져오기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video uploaded successfully.')),
        );

        // 다운로드 기능 호출
        await _downloadVideo(videoUrl);

        final video = Video(
          path: _videoFile!.path, // 로컬 경로로 설정
          category: _selectedCategory,
        );

        widget.onVideoUploaded(video);

        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(); // 홈 화면으로 이동
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video upload failed.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a video and enter a name.')),
      );
    }
  }

  Future<void> _downloadVideo(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String appPath = appDir.path;
        final File file = File('$appPath/downloaded_video.mp4');

        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video downloaded successfully.')),
        );

        // 다운로드된 비디오 경로를 _downloadedVideos 리스트에 추가하여 UI에 반영
        setState(() {
          // 저장된 비디오를 로컬에 보관하거나 UI에 반영할 수 있습니다.
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video download failed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while downloading the video.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text('Select Video', style: TextStyle(fontSize: 18)),
            ),
            if (_videoFile != null) ...[
              SizedBox(height: 20),
              TextField(
                controller: _videoNameController,
                decoration: InputDecoration(labelText: 'Video Name'),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadVideo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text('Upload Video', style: TextStyle(fontSize: 18)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
