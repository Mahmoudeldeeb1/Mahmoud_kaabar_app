import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const KaabarApp());
}

class KaabarApp extends StatelessWidget {
  const KaabarApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color seed = Color(0xFF0066FF);

    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        primary: seed,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto',
    );

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        primary: seed,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: 'Roboto',
    );

    return MaterialApp(
      title: 'Kaabar',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

// SPLASH

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Kaabar',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0066FF),
          ),
        ),
      ),
    );
  }
}

// ONBOARDING

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardData> _pages = const [
    _OnboardData(
      imageUrl:
          'https://images.pexels.com/photos/8370756/pexels-photo-8370756.jpeg',
      title: 'Lorem ipsum is simply dummy',
      subtitle:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.',
    ),
    _OnboardData(
      imageUrl:
          'https://images.pexels.com/photos/208773/pexels-photo-208773.jpeg',
      title: 'Lorem ipsum is simply dummy',
      subtitle:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.',
    ),
    _OnboardData(
      imageUrl:
          'https://images.pexels.com/photos/1640770/pexels-photo-1640770.jpeg',
      title: 'Lorem ipsum is simply dummy',
      subtitle:
          'Lorem ipsum is simply dummy text of the printing and typesetting industry.',
    ),
  ];

  void _goNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _currentPage == _pages.length - 1;
    final Color textColor = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          data.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.subtitle,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: List.generate(
                                    _pages.length,
                                    (i) => Container(
                                      margin: const EdgeInsets.only(right: 6),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _currentPage == i
                                            ? const Color(0xFF0066FF)
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _goNext,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0066FF),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(isLast ? 'Get Started' : 'Next'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _OnboardData({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}

// LOGIN

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _showError = false;
  bool _isLoading = false;

  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://dummyjson.com'),
  );

  String? _accessToken;
  String? _refreshToken;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  InputBorder _border({bool error = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: error ? Colors.red : Colors.grey.shade400,
        width: 1.2,
      ),
    );
  }

  Future<void> _getCurrentUser() async {
    if (_accessToken == null) return;

    final response = await _dio.get(
      '/auth/me',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      ),
    );

    debugPrint('Current user: ${response.data}');
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _showError = true;
      });
      return;
    }

    setState(() {
      _showError = false;
      _isLoading = true;
    });

    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          // DummyJSON expects username; you can type "emilys" here when testing
          'username': _email.text.trim(),
          'password': _password.text.trim(),
          'expiresInMins': 30,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final data = response.data as Map<String, dynamic>;
      _accessToken = data['accessToken'] as String?;
      _refreshToken = data['refreshToken'] as String?;

      if (_accessToken != null) {
        await _getCurrentUser();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      // TODO: Navigate to your Kaabar home screen here
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } on DioException catch (e) {
      setState(() {
        _showError = true;
      });
      final msg = e.response?.data.toString() ?? e.message ?? 'Login failed';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF0066FF);
    final Color textColor = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Hello',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    ' Again!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Welcome back you've\nbeen missed!",
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.6),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email / Username',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your username (e.g. emilys)',
                        isDense: true,
                        border: _border(error: _showError),
                        enabledBorder: _border(error: _showError),
                        focusedBorder: _border(error: _showError),
                        errorBorder: _border(error: true),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        isDense: true,
                        border: _border(error: _showError),
                        enabledBorder: _border(error: _showError),
                        focusedBorder: _border(error: _showError),
                        errorBorder: _border(error: true),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (value.length < 6) {
                          return 'Min 6 characters';
                        }
                        return null;
                      },
                    ),
                    if (_showError) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Invalid email/username or password',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or continue with',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _SocialButton(
                    label: 'Facebook',
                    assetIcon: Icons.facebook,
                    color: Color(0xFF1877F2),
                  ),
                  SizedBox(width: 16),
                  _SocialButton(
                    label: 'Google',
                    assetIcon: Icons.g_mobiledata,
                    color: Colors.redAccent,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData assetIcon;
  final Color color;

  const _SocialButton({
    required this.label,
    required this.assetIcon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(assetIcon, color: color),
        label: Text(
          label,
          style: const TextStyle(fontSize: 13),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
