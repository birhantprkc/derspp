import 'source_service.dart';
import 'f_source_service.dart';
import 'f2_source_service.dart';
import 'youtube_source_service.dart';

class SourceFactory {
  static final Map<String, SourceService> _services = {
    'fsource': FSourceService(),
    'f2source': F2SourceService(),
    'youtube': YoutubeSourceService(),
  };

  static SourceService getSourceService(String type) {
    final service = _services[type];
    if (service == null) {
      return _services['fsource']!;
    }
    return service;
  }

  static List<String> get availableSourceTypes => _services.keys.toList();
}
