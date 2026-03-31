import 'package:flutter/material.dart';

// --- MODERN WARM PALETTE ---
const Color kPrimaryWarm =
    Color.fromARGB(255, 74, 157, 182); // Deep Terracotta (Official/Trust)
const Color kBackgroundWarm =
    Color.fromARGB(255, 245, 223, 228); // Warm Off-white
const Color kTextDark = Color(0xFF2D3748); // Slate Charcoal
const Color kAccentSand = Color(0xFFFEEBC8); // Muted Gold

class FixedDepositPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const FixedDepositPage({super.key, required this.userData});

  // 🔢 SAFE NUMBER PARSER
  double numVal(dynamic v) {
    if (v == null) return 0;
    return double.tryParse(v.toString().replaceAll(',', '')) ?? 0;
  }

  // 🔍 ROBUST KEY FINDER FOR FIXED DEPOSIT
  double _getFixedDepositValue(String key) {
    List<String> keysToCheck = [
      key,
      key.toLowerCase(),
      'fixed_deposit',
      'Fixed Deposit',
      'mudat_thev',
    ];

    for (String k in keysToCheck) {
      if (userData.containsKey(k)) {
        double deposit = numVal(userData[k]);
        if (deposit != 0) return deposit;
      }
    }
    return 0.0;
  }

  String _getUserName() {
    return userData['Name']?.toString() ??
        userData['name']?.toString() ??
        'Member';
  }

  @override
  Widget build(BuildContext context) {
    final double fixedDeposit = _getFixedDepositValue('FixedDeposit');
    final String userName = _getUserName();

    return Scaffold(
      backgroundColor: kBackgroundWarm,
      appBar: AppBar(
        title: const Text("मुदत ठेव"),
        backgroundColor: kPrimaryWarm,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. DYNAMIC HEADER SECTION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: const BoxDecoration(
              color: kPrimaryWarm,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, $userName",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),

          // 2. MAIN DEPOSIT CARD
          Transform.translate(
            offset: const Offset(0, -25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Service Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: kAccentSand,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.savings_outlined,
                        color: kPrimaryWarm,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "तुमची मुदत ठेव शिल्लक",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "₹ ${fixedDeposit.toStringAsFixed(2)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: kPrimaryWarm,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Maturity Label / Badge
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          // 3. NAVIGATION BUTTON
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.dashboard_outlined),
              label: const Text("Back to Dashboard"),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryWarm,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
