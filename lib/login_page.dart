import 'package:flutter/material.dart';
import 'home_page.dart';
import 'services/api_service.dart';

// --- MODERN WARM PALETTE ---
const Color kPrimaryWarm =
    Color.fromARGB(255, 70, 159, 186); // Deep Terracotta (Official/Trust)
const Color kBackgroundWarm =
    Color.fromARGB(255, 222, 203, 208); // Warm Off-white
const Color kSurfaceWhite = Color(0xFFFFFFFF);
const Color kAccentSand = Color(0xFFFEEBC8); // Muted Gold accent
const Color kTextDark =
    Color.fromARGB(255, 3, 22, 56); // Slate Grey (Official Text)
const Color kBackWarm = Color.fromARGB(255, 2, 194, 247);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final inputPassword = _passController.text.trim();

    if (id.isEmpty || name.isEmpty || inputPassword.isEmpty) {
      setState(() => _errorMessage = 'Please fill all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final userData = await ApiService.loginUser(id, name);

    if (!mounted) return;

    if (userData != null) {
      String sheetPassword = userData['password']?.toString() ?? 'admin@123';

      if (inputPassword == sheetPassword) {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              userData: userData,
              memberId: id,
              memberName: name,
            ),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Incorrect App Password';
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid Member ID or Name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWarm,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- LOGO SECTION ---
                // REPLACE YOUR ICON SECTION WITH THIS:
                Container(
                  height: 100, // Adjust size as needed
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryWarm.withOpacity(
                            0.15), // Uses your terracotta theme color
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(
                          8.0), // Padding to keep logo from edges
                      child: Image.asset(
                        'assets/image/logo.jpeg',
                        fit: BoxFit.contain,
                        // Fallback: If image fails to load, show a bank icon so the app doesn't look broken
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.account_balance,
                            size: 60,
                            color: kPrimaryWarm,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // --- TITLE SECTION ---
                const Text(
                  "जुन्नर तालुका प्राथमिक शिक्षक\nसहकारी पतसंस्था मर्या., जुन्नर",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'MarathiFont',
                    fontWeight: FontWeight.w800,
                    color: kTextDark,
                    height: 1.3,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Member Login Portal",
                  style: TextStyle(
                    fontSize: 14,
                    color: kTextDark.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),

                // --- INPUT FIELDS ---
                _buildModernTextField(
                  controller: _idController,
                  label: 'Member ID',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildModernTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),
                _buildModernTextField(
                  controller: _passController,
                  label: 'App Password',
                  icon: Icons.lock_open_outlined,
                  isPassword: true,
                ),

                // --- ERROR MESSAGE ---
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // --- LOGIN BUTTON ---
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryWarm,
                    foregroundColor: kSurfaceWhite,
                    minimumSize: const Size(double.infinity, 56),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: kSurfaceWhite,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Login to Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // REUSABLE MODERN TEXT FIELD COMPONENT
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kSurfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: kTextDark, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              TextStyle(color: kTextDark.withOpacity(0.4), fontSize: 14),
          prefixIcon: Icon(icon, color: kPrimaryWarm, size: 22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: kSurfaceWhite,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
