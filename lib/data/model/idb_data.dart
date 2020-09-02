// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

class IdRepository {
  final Storage _localStorage = window.localStorage;
  Future save(String id) async {
    _localStorage['data'] = id;
  }

  Future<String> getId() async => _localStorage['data'];

  Future invalidate() async {
    _localStorage.remove('data');
  }
}
