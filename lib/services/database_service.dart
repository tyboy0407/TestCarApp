import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/vehicle_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // 指向您的 API Bridge 網址 (例如部署在 Vercel 上的網址)
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  // User Methods
  Future<User?> getUser(String username) async {
    // 透過您的 API 取得使用者資訊
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/auth'),
      headers: _headers,
      body: json.encode({'username': username}),
    );
    if (response.statusCode == 200 && response.body != 'null') {
      return User.fromJson(json.decode(response.body));
    }
    return null;
  }

  Future<void> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/register'),
        headers: _headers,
        body: json.encode(user.toJson()),
      ).timeout(const Duration(seconds: 60)); // 增加超時至 60 秒

      if (response.statusCode == 200) {
        return;
      } else {
        // 嘗試解析後端回傳的錯誤訊息
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error'] ?? '註冊失敗 (${response.statusCode})';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('連線至伺服器失敗: $e');
    }
  }

  Future<User?> authenticateUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/users/auth'),
        headers: _headers,
        body: json.encode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 && response.body != 'null') {
        return User.fromJson(json.decode(response.body));
      } else if (response.statusCode == 200) {
        return null; // 帳號或密碼錯誤
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? '驗證失敗');
      }
    } catch (e) {
      print('Auth error: $e');
      return null;
    }
  }

  // Vehicle Methods
  Future<List<Vehicle>> getVehicles({String? userId}) async {
    final url = userId != null 
        ? '$_baseUrl/api/vehicles?userId=$userId' 
        : '$_baseUrl/api/vehicles';
        
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((j) => Vehicle.fromJson(j)).toList();
    }
    return [];
  }

  Future<void> saveVehicle(Vehicle vehicle) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/vehicles'),
      headers: _headers,
      body: json.encode(vehicle.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('儲存失敗');
    }
  }
}
