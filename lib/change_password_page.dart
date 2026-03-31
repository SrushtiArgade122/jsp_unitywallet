import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// --- MODERN WARM PALETTE ---
const Color kPrimaryWarm =
    Color.fromARGB(255, 74, 157, 182); // Deep Terracotta (Official/Trust)
const Color kBackgroundWarm =
    Color.fromARGB(255, 245, 223, 228); // Warm Off-white
const Color kTextDark = Color(0xFF2D3748); // Slate Charcoal
const Color kSurfaceWhite = Color(0xFFFFFFFF);

class ChangePasswordPage extends StatefulWidget {
  final String memberId;

  const ChangePasswordPage({super.key, required this.memberId});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _updatePassword() async {
    String newPass = _newPasswordController.text.trim();
    String confirmPass = _confirmPasswordController.text.trim();

    if (newPass.isEmpty || newPass.length < 4) {
      _showSnackBar("Password must be at least 4 characters long");
      return;
    }

    if (newPass != confirmPass) {
      _showSnackBar("Passwords do not match!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String scriptUrl =
          "https://script.google.com/macros/s/AKfycbwGh10XS2iOi8t6F9UGE79JkqPWd7LlQLaGPXxLnYfyQnZaGD4ArFTt8f872TnVUo5KpA/exec";

      final url = Uri.parse(
          "$scriptUrl?action=changePassword&id=${widget.memberId}&newPassword=$newPass");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _showSnackBar("Password updated successfully!");
          if (!mounted) return;
          Navigator.pop(context);
        } else {
          _showSnackBar("Error: ${data['message']}");
        }
      } else {
        _showSnackBar("Failed to connect to server");
      }
    } catch (e) {
      _showSnackBar("An error occurred: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kTextDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWarm,
      appBar: AppBar(
        title: const Text("Security Settings"),
        backgroundColor: kPrimaryWarm,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Update Password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kTextDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ensure your new password is secure and at least 4 characters long.",
              style: TextStyle(color: kTextDark.withOpacity(0.6), fontSize: 14),
            ),
            const SizedBox(height: 32),

            // New Password Input
            _buildModernField(
              controller: _newPasswordController,
              label: "New Password",
              icon: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: 20),

            // Confirm Password Input
            _buildModernField(
              controller: _confirmPasswordController,
              label: "Confirm New Password",
              icon: Icons.lock_reset_rounded,
            ),
            const SizedBox(height: 40),

            // Update Button
            ElevatedButton(
              onPressed: _isLoading ? null : _updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryWarm,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                shadowColor: kPrimaryWarm.withOpacity(0.3),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Update Password",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kSurfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: true,
        style: const TextStyle(color: kTextDark, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: kTextDark.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: kPrimaryWarm),
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
