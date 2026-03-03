import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/vehicle_provider.dart';
import '../widgets/animated_scale_button.dart';
import '../widgets/loading_progress_dialog.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate a slight delay to show the loading state more clearly in a "fast" app
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final success = await Provider.of<AuthProvider>(context, listen: false)
        .login(_usernameController.text, _passwordController.text);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('登入失敗，請檢查帳號密碼'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // 登入成功，顯示載入進度對話框
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, // 禁止點擊外部關閉
          builder: (context) => LoadingProgressDialog(
            onLoading: () async {
              // 觸發真實的資料獲取
              // Defer calling fetchVehicles to avoid setState during build
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await Provider.of<VehicleProvider>(context, listen: false).fetchVehicles();
                // onFinished will be called by LoadingProgressDialog after onLoading completes
              });
            },
            onFinished: () {
              // 加載完成後跳轉
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.directions_car_filled_outlined,
                    size: 64,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF9A8B), Color(0xFFFF6A88)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Text(
                      'Wheelie',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40, // 稍微加大字體讓漸層更明顯
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white, // ShaderMask 會將顏色覆蓋，這裡設為白色
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your best friend Wheelie',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: '帳號',
                      hintText: '輸入您的帳號或 Email',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請輸入帳號';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      labelText: '密碼',
                      hintText: '輸入您的密碼',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '請輸入密碼';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  
                  AnimatedScaleButton(
                    onPressed: _isLoading ? null : _submit,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              '登 入',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('註冊功能開發中')),
                      );
                    },
                    child: Text(
                      '還沒有帳號？立即註冊',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

