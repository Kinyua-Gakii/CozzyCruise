import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cozzy_cruise/utils/responsive.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const String _googleWebClientId =
      '458724976161-g8pck8oaspj1agda3hhsd790s9s19530.apps.googleusercontent.com';
  static const String _googleIosClientId =
      '458724976161-uhtuhbvue536ncvlj65nmg2ahuj29i7a.apps.googleusercontent.com';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLogin = true;

  Future<void> signInWithGoogle() async {
    try {
      debugPrint("Google button clicked");

      final UserCredential userCredential;

      if (kIsWeb) {
        userCredential = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: defaultTargetPlatform == TargetPlatform.iOS
              ? _googleIosClientId
              : null,
          serverClientId: _googleWebClientId,
        );

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          debugPrint("User cancelled sign-in");
          return;
        }

        debugPrint("Google user selected: ${googleUser.email}");

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        debugPrint("Got Google auth tokens");

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }

      debugPrint("Firebase sign-in success");

      final user = userCredential.user;

      if (user == null) {
        debugPrint("User is null after Firebase login");
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        "name": user.displayName,
        "email": user.email,
        "authProvider": "google",
        "profileCompleted": false,
      }, SetOptions(merge: true));

      debugPrint("Firestore write success");

      if (!mounted) return;

      context.go('/validation');
    } catch (e, stack) {
      debugPrint("Google Sign-In ERROR: $e");
      debugPrint("STACK: $stack");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Google Sign-In failed: $e")));
      }
      //context.go('/validation');
    }
  }

  static const Color _black = Color(0xFF111111);
  static const Color _beige = Color(0xFFF4E7D3);
  static const Color _white = Color(0xFFFDFDFB);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: _beige,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Image.asset(
                        'lib/assets/logo.jpeg',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _TogglePill(
                      isLogin: _isLogin,
                      onChanged: (value) => setState(() => _isLogin = value),
                    ),
                    const SizedBox(height: 24),
                    // Show sign-up specific fields only when in sign-up mode
                    if (!_isLogin) ...[
                      _GlassInputField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        borderRadius: 32,
                        height: 44,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _GlassInputField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        borderRadius: 32,
                        height: 44,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _GlassInputField(
                        controller: _idController,
                        label: 'ID Number',
                        icon: Icons.badge_outlined,
                        borderRadius: 32,
                        height: 44,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your ID Number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],

                    //show email + password for sign-in and sign-up
                    _GlassInputField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      borderRadius: 32,
                      height: 44,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _GlassInputField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      borderRadius: 32,
                      height: 44,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (value.contains(' ')) {
                          return 'Password cannot contain spaces';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter';
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'Password must contain at least one number';
                        }
                        if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
                          return 'Password must contain at least one symbol';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Confirm password only on sign-up
                    if (!_isLogin)
                      _GlassInputField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock_reset_outlined,
                        obscureText: true,
                        borderRadius: 32,
                        height: 44,
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
                    const SizedBox(height: 16),
                    // ...agreed to terms removed...
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _black,
                          foregroundColor: _white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(_isLogin ? 'Sign In' : 'Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Social login section at the bottom
                    Center(
                      child: Column(
                        children: [
                          Text(
                            _isLogin ? 'Or sign in with' : 'Or sign up with',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 56,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: _black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  side: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(56, 56),
                              ),
                              onPressed: signInWithGoogle,
                              child: Image.asset(
                                'lib/assets/google_icon.jpg',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(_isLogin ? 'Signing in...' : 'Creating account...'),
        backgroundColor: _black,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (!_isLogin) {
      // After sign up, switch to sign in mode in the same screen
      setState(() {
        _isLogin = true;
      });
      messenger.showSnackBar(
        SnackBar(
          content: Text('Account created successfully! Sign in.'),
          backgroundColor: _black,
        ),
      );
      return;
    }

    // After sign in, check verification status
    String verificationStatus = await _getVerificationStatus();
    _navigateBasedOnStatus(verificationStatus);
  }

  // Simulate fetching verification status (replace with real backend call)
  Future<String> _getVerificationStatus() async {
    // TODO: Replace this with your actual logic
    // return "not_submitted" | "pending" | "verified"
    return "not_submitted";
  }

  void _navigateBasedOnStatus(String verificationStatus) {
    if (verificationStatus == "not_submitted") {
      context.go('/validation');
    } else if (verificationStatus == "pending") {
      context.go('/pending');
    } else {
      context.go('/home');
    }
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({required this.isLogin, required this.onChanged});

  final bool isLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _AuthColors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _AuthColors.yellow.withValues(alpha: 0.26)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleButton(
              label: 'Sign Up',
              selected: !isLogin,
              onTap: () => onChanged(false),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ToggleButton(
              label: 'Sign In',
              selected: isLogin,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _AuthColors.black : Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? _AuthColors.white : _AuthColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassInputField extends StatefulWidget {
  const _GlassInputField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.borderRadius = 12,
    this.height = 56,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final double borderRadius;
  final double height;

  @override
  State<_GlassInputField> createState() => _GlassInputFieldState();
}

class _GlassInputFieldState extends State<_GlassInputField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: _AuthColors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: _AuthColors.yellow, width: 2),
      ),
      child: Center(
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscured,
          keyboardType: widget.keyboardType,
          style: TextStyle(color: _AuthColors.black),
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: Icon(widget.icon, color: _AuthColors.black),
            labelStyle: TextStyle(color: _AuthColors.black),
            floatingLabelStyle: TextStyle(color: _AuthColors.black),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            // show suffix eye icon only when field is originally obscured
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscured ? Icons.visibility_off : Icons.visibility,
                      color: _AuthColors.black,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _AuthColors {
  static const Color black = Color(0xFF111111);
  static const Color yellow = Color(0xFFF6C945);
  static const Color white = Color(0xFFFDFDFB);
}
