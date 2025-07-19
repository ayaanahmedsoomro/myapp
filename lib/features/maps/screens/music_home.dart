import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicHomeScreen extends StatefulWidget {
  const MusicHomeScreen({super.key});

  @override
  State<MusicHomeScreen> createState() => _MusicHomeScreenState();
}

class _MusicHomeScreenState extends State<MusicHomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongModel> _songs = [];
  List<SongModel> _foundSongs = [];
  String _searchText = '';
  String _message = '';
  String _currentSongTitle = '';

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextSong();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      _querySongs();
    } else {
      // Handle permission denied
    }
  }

  _querySongs() async {
    _songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    _foundSongs = _songs; // Initialize with all songs
    setState(() {});
  }

  _searchSongs(String text) {
    _searchText = text;
    if (text.isEmpty) {
      _foundSongs = _songs;
      _message = '';
    } else {
      _foundSongs = _songs
          .where((song) =>
              song.title.toLowerCase().contains(text.toLowerCase()))
          .toList();
      if (_foundSongs.isEmpty) {
        _message = 'Not Found';
      } else {
        _message = 'Found';
      }
    }
    setState(() {});
  }

  _playSong(String? uri, String title) async {
    try {
      if (uri != null) {
        await _audioPlayer.setUrl(uri);
        _audioPlayer.play();
        setState(() {
          _currentSongTitle = title;
        });
      }
    } catch (e) {
      // Handle errors
    }
  }

  _pauseSong() {
    _audioPlayer.pause();
  }

  _stopSong() {
    _audioPlayer.stop();
    setState(() {
      _currentSongTitle = '';
    });
  }

  _playNextSong() {
    if (_foundSongs.isNotEmpty) {
      int currentIndex = _foundSongs.indexWhere((song) => song.title == _currentSongTitle);
      if (currentIndex < _foundSongs.length - 1) {
        _playSong(_foundSongs[currentIndex + 1].uri, _foundSongs[currentIndex + 1].title);
      } else {
        _stopSong(); // Stop if it's the last song
      }
    }
  }

  _playPreviousSong() {
     if (_foundSongs.isNotEmpty) {
      int currentIndex = _foundSongs.indexWhere((song) => song.title == _currentSongTitle);
      if (currentIndex > 0) {
        _playSong(_foundSongs[currentIndex - 1].uri, _foundSongs[currentIndex - 1].title);
      } else {
        // Optionally loop or stop at the beginning
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search music...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              onChanged: _searchSongs,
            ),
            const SizedBox(height: 16.0),
            Text(_message),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _foundSongs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_foundSongs[index].title),
                    subtitle: Text(_foundSongs[index].artist ?? 'Unknown Artist'),
                    onTap: () => _playSong(_foundSongs[index].uri, _foundSongs[index].title),
                  );
                },
              ),
            ),
            if (_currentSongTitle.isNotEmpty)
              Column(
                children: [
                  Text('Currently playing: $_currentSongTitle'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _playPreviousSong,
                      ),
                      IconButton(
                        icon: Icon(_audioPlayer.playing ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          if (_audioPlayer.playing) {
                            _pauseSong();
                          } else {
                            _audioPlayer.play();
                          }
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.stop),
                        onPressed: _stopSong,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: _playNextSong,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
