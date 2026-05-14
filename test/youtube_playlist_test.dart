import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  test('Fetch playlists from channel', () async {
    final yt = YoutubeExplode();
    final channelId = 'UC_x5XG1OV2P6uZZ5FSM9Ttw';

    print('Kanal ID: $channelId için oynatma listeleri aranıyor...\n');
    final playlists = await yt.channels.getPlaylists(channelId);

    print('Toplam ${playlists.length} oynatma listesi bulundu:\n');
    for (var playlist in playlists.take(5)) {
      print('- ${playlist.title} (${playlist.url})');
    }

    expect(playlists.isNotEmpty, true);
    
    yt.close();
  });
}
