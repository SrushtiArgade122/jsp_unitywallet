import 'package:flutter/material.dart';

// --- MODERN WARM PALETTE ---
const Color kPrimaryWarm =
    Color.fromARGB(255, 74, 157, 182); // Deep Terracotta (Official/Trust)
const Color kBackgroundWarm = Color.fromARGB(255, 245, 223, 228);
const Color kTextDark = Color(0xFF2D3748); // Slate Charcoal
const Color kSurfaceWhite = Color(0xFFFFFFFF);
const Color kAccentSand = Color(0xFFFEEBC8); // Muted Gold

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({super.key, required this.userData});

  String _get(String requestedKey) {
    String key = requestedKey.toLowerCase();
    dynamic value = userData[key];

    if (value == null) {
      String cleanKey = key.replaceAll('_', '');
      value = userData[cleanKey];
    }

    if (value == null ||
        value.toString().isEmpty ||
        value.toString().toLowerCase() == 'null') {
      return "N/A";
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final String userName = _get('name');
    final String userId = _get('id');
    final String school = _get('school');
    final String center = _get('center');
    final String bankAcNo = _get('bank_ac_no');
    final String bankName = _get('bank_name');
    final String branch = _get('branch');
    final String ifscCode = _get('ifsc_code');

    return Scaffold(
      backgroundColor: kBackgroundWarm,
      appBar: AppBar(
        title: const Text("Member Profile"),
        backgroundColor: kPrimaryWarm,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. TOP PROFILE HEADER SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 50),
              decoration: const BoxDecoration(
                color: kPrimaryWarm,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: kAccentSand.withOpacity(0.3),
                    child: const Icon(Icons.person_rounded,
                        size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName != 'N/A' ? userName : 'Member',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Member ID: $userId",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 14),
                  ),
                ],
              ),
            ),

            // 2. INFORMATION SECTIONS
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // PERSONAL CARD
                    _buildSectionCard(
                      title: "Official Details",
                      icon: Icons.badge_outlined,
                      rows: [
                        _buildProfileRow("School", school),
                        _buildProfileRow("Center", center),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),

                    // BANK CARD
                    _buildSectionCard(
                      title: "Bank Accounts",
                      icon: Icons.account_balance_outlined,
                      rows: [
                        _buildProfileRow("Account No.", bankAcNo),
                        _buildProfileRow("Bank", bankName),
                        _buildProfileRow("Branch", branch),
                        _buildProfileRow("IFSC", ifscCode),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. LOGOUT / BACK BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text("Back to Dashboard"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryWarm,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurfaceWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kPrimaryWarm, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: kTextDark.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: kTextDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
