import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

abstract class UserParser<T> {
  Map<String, dynamic> toJson(T user);

  T fromJson(Map<String, dynamic> json);
}

class AuthSession {
  bool get isAuthenticated => _token != null;

  String get token => _token ?? '';

  dynamic get user => _user;

  static Future<void> initWith(UserParser storage) async {
    _file = File((await getApplicationDocumentsDirectory()).path +
        r'$__app_auth.session');

    if (!(await _file!.exists())) {
      await _file!.create();
    } else {
      final raw = await _file!.readAsString();
      if (raw.isNotEmpty) {
        final data = jsonDecode(await _file!.readAsString());
        _user = storage.fromJson(data);
        _token = data['token'].toString();
      }
    }

    if (_storage == null) {
      _storage = storage;
    } else {
      throw '[AuthSession.initWith] has already been called';
    }
  }

  Future<void> wipe() async {
    await (_file!.openWrite()..add([])).close();
    _user = null;
    _token = null;
  }

  Future<void> update(String token, dynamic user) async {
    _user = user;
    _token = token;
    if (_storage == null) {
      throw '[AuthSession.initWith] has not been called';
    }

    await (_file!.openWrite()
          ..write(
            jsonEncode(_storage!.toJson(user)..addAll({'access_token': token})),
          ))
        .close();
  }

  factory AuthSession() => _instance;

  AuthSession._();

  static final _instance = AuthSession._();
  static UserParser? _storage;
  static dynamic? _user;
  static String? _token;
  static File? _file;
}
