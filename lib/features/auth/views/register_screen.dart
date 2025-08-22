import 'package:cinemabooking/config/theme.dart';
import 'package:cinemabooking/features/auth/providers/auth_provider.dart';
import 'package:cinemabooking/shared/widgets/reusable_password_field.dart';
import 'package:cinemabooking/shared/widgets/reusable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (authProvider.isLoggedIn) {
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: TextStyle(fontSize: 16, color: AppTheme.textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Name Field
                ReusableTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppTheme.primary,
                  ),
                  borderRadius: 12.0,
                  labelStyle: const TextStyle(color: AppTheme.textGrey),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                ReusableTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppTheme.primary,
                  ),
                  borderRadius: 12.0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Field
                ReusableTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  labelText: 'Phone (Optional)',
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: AppTheme.primary,
                  ),
                  borderRadius: 12.0,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^\+?[\d\s-()]+$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                ReusablePasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.primary,
                  ),
                  borderRadius: 12.0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    if (!RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                    ).hasMatch(value)) {
                      return 'Password must contain uppercase, lowercase, and number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                ReusablePasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.primary,
                  ),
                  borderRadius: 12.0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Error Message
                if (authProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      authProvider.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Register Button
                ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.white,
                            ),
                          ),
                        )
                      : const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: AppTheme.textPrimary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
