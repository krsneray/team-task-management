import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:team_task_management/providers/auth_provider.dart';
import 'package:team_task_management/themes/theme.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLogoAndTitle(textTheme),
              const SizedBox(height: 50),

              Text("Giriş Yap", style: textTheme.headlineLarge),
              const SizedBox(height: 4),
              Text(
                "Hesabınıza erişmek için bilgilerinizi girin.",
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),

              _buildInputLabel("E-POSTA"),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  "ad@sirket.com",
                  Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInputLabel("ŞİFRE"),
                  GestureDetector(
                    onTap: () {
                      // Şifremi unuttum aksiyonu
                    },
                    child: Text(
                      "Unuttum?",
                      style: TextStyle(
                        color: AppColors.link,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration("Şifreniz", Icons.lock_outlined),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() => _rememberMe = value ?? false);
                    },
                  ),
                  Text("Beni hatırla", style: textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 20),

              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.errorMessage == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),

              _buildPrimaryButton(context),
              const SizedBox(height: 20),

              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("veya"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hesabınız yok mu?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Yöneticinize Başvurun",
                      style: TextStyle(
                        color: AppColors.link,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle(TextTheme textTheme) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x593B82F6), // 0xFF3B82F6 with alpha 0.35
                offset: Offset(0, 8),
                blurRadius: 32,
              ),
            ],
          ),
          child: SvgPicture.asset(
            "assets/icons/boardicon.svg",
            width: 50,
            height: 50,
          ),
        ),
        const SizedBox(height: 20),
        Text("TaskBoard", style: textTheme.headlineLarge),
        const SizedBox(height: 10),
        const Text("Ekibinize bağlı kalın."),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Color(0x4D3B82F6), // 0xFF3B82F6 with alpha 0.30
                offset: Offset(0, 4),
                blurRadius: 24,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : () => _handleLogin(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text("Giriş Yap", style: TextStyle(fontSize: 16)),
          ),
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final succes = await authProvider.login(email, password);

    if (!mounted) return;

    if (succes) {
      context.go("/home");
    }
  }
}
