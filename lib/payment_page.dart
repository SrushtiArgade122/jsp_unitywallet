import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- MODERN WARM PALETTE ---
const Color kPrimaryWarm =
    Color.fromARGB(255, 74, 157, 182); // Deep Terracotta (Official/Trust)
const Color kBackgroundWarm =
    Color.fromARGB(255, 245, 223, 228); // Warm Off-white
const Color kTextDark = Color(0xFF2D3748); // Slate Charcoal
const Color kAccentSand = Color(0xFFFEEBC8); // Muted Gold

class PaymentPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PaymentPage({super.key, required this.userData});

  String _getUserName() {
    return userData['Name']?.toString() ??
        userData['name']?.toString() ??
        'Member';
  }

  @override
  Widget build(BuildContext context) {
    final String userName = _getUserName();
    const String qrCodeAssetPath = 'assets/image/bank_qr.jpeg';

    return Scaffold(
      backgroundColor: kBackgroundWarm,
      appBar: AppBar(
        title: const Text("Add Money"),
        backgroundColor: kPrimaryWarm,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. TOP HEADER SECTION
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
                children: [
                  const Text(
                    "Add deposit to your account",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // 2. BANK DETAILS CARD
            Transform.translate(
              offset: const Offset(0, -25),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.account_balance_rounded,
                              color: kPrimaryWarm),
                          SizedBox(width: 10),
                          Text(
                            "बँक तपशील (Bank Details)",
                            style: TextStyle(
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
                      _buildDetailRow("खात्याचे नाव",
                          "जुन्नर तालुका प्राथमिक शिक्षक सहकारी पतसंस्था मर्या.,जुन्नर"),
                      _buildDetailRow("खाते क्रमांक", "005131100000001",
                          canCopy: true, context: context),
                      _buildDetailRow("IFSC Code", "HDFC0CPDCCB",
                          canCopy: true, context: context),
                      _buildDetailRow(
                          "बँकचे नाव", "पुणे जिल्हा मध्य. सहकारी बँक"),
                      _buildDetailRow("शाखा", "जुन्नर"),
                    ],
                  ),
                ),
              ),
            ),

            // 3. QR CODE SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    "Scan QR to Pay",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kTextDark),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kAccentSand, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        qrCodeAssetPath,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. BACK BUTTON
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool canCopy = false, BuildContext? context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: kTextDark.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kTextDark),
                ),
              ),
              if (canCopy && context != null)
                IconButton(
                  icon: const Icon(Icons.copy_rounded,
                      size: 18, color: kPrimaryWarm),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Copied to clipboard"),
                          behavior: SnackBarBehavior.floating),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
