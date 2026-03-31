import 'package:flutter/material.dart';

// --- MODERN WARM PALETTE ---
const Color kPrimaryWarm =
    Color.fromARGB(255, 74, 157, 182); // Deep Terracotta (Official/Trust)
const Color kBackgroundWarm = Color.fromARGB(255, 245, 223, 228);
const Color kTextDark = Color(0xFF2D3748); // Slate Charcoal
const Color kAccentSand = Color(0xFFFEEBC8); // Muted Gold

class ContingentLoanPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ContingentLoanPage({super.key, required this.userData});

  // 🔢 SAFE NUMBER PARSER
  double numVal(dynamic v) {
    if (v == null) return 0;
    return double.tryParse(v.toString().replaceAll(',', '')) ?? 0;
  }

  // 🔍 ROBUST KEY FINDER FOR LOAN VALUE
  double _getLoanValue(String key) {
    List<String> keysToCheck = [
      key,
      key.toLowerCase(),
      'ContingentLoan',
      'contingent_loan',
      'आकस्मिक कर्ज'
    ];

    for (String k in keysToCheck) {
      if (userData.containsKey(k)) {
        double loan = numVal(userData[k]);
        if (loan > 0) return loan;
      }
    }
    return 0.0;
  }

  String _getUserName() {
    return userData['name']?.toString() ??
        userData['Name']?.toString() ??
        'Member';
  }

  @override
  Widget build(BuildContext context) {
    final double contingentLoan = _getLoanValue('ContingentLoan');
    final String userName = _getUserName();

    return Scaffold(
      backgroundColor: kBackgroundWarm,
      appBar: AppBar(
        title: const Text("आकस्मिक कर्ज"),
        backgroundColor: kPrimaryWarm,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. HEADER SECTION (Greeting)
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

          // 2. MAIN BALANCE CARD
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
                    const Icon(Icons.bolt_rounded,
                        color: kPrimaryWarm, size: 40),
                    const SizedBox(height: 16),
                    const Text(
                      "तुमची कर्जाची एकूण शिल्लक",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "₹ ${contingentLoan.toStringAsFixed(2)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: kPrimaryWarm,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          // 3. ACTION BUTTONS
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
