import 'package:flutter/material.dart';
import 'package:veritas_shiel/core/routes/app_router.dart';
import 'package:veritas_shiel/core/theme/app_colors.dart';
import 'package:veritas_shiel/features/onboarding/presentation/widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _rememberMe,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, Routes.home);
          } else if (state is AuthFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Top Illustration
                  Image.asset(
                    'assets/images/shakinghands.png',
                    height: size.height * 0.3,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 40),
                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'example@gmail.com',
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!value.contains('@')) return 'Please enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'XXXXXXXX',
                    prefixIcon: Icons.lock_outline,
                    isPassword: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.black45,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your password';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Remember me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) => setState(() => _rememberMe = value ?? false),
                            activeColor: AppColors.primary,
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Login Button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Log in',
                          onPressed: () => _onLogin(context),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: Colors.black26)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.black26)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Social Login
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/google.png',
                      height: 50,
                      width: 131,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, Routes.signup),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
