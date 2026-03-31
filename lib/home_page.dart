import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'login_page.dart';
import 'payment_page.dart';
import 'loan_page.dart';
import 'rd_page.dart';
import 'profile_page.dart';
import 'cont_loan_page.dart';
import 'mort_loan_page.dart';
import 'fd_page.dart';
import 'death_fund_page.dart';
import 'shares_page.dart';
import 'monthly_saving_page.dart';
import 'divident_page.dart';
import 'change_password_page.dart';

// --- MODERN WARM PALETTE ---

const Color kPrimaryWarm =
    Color.fromARGB(255, 74, 162, 189); // Deep Terracotta (Official/Trust)
const Color kBackgroundWarm =
    Color.fromARGB(255, 241, 212, 219); // Warm Off-white
const Color kTextDark = Color.fromARGB(255, 47, 58, 77); // Slate Charcoal
const Color kAccentSand = Color(0xFFFEEBC8); // Muted Gold

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String memberId;
  final String memberName;

  const HomePage({
    super.key,
    required this.userData,
    required this.memberId,
    required this.memberName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> userData;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
  }

  String _getUserName() {
    return userData['Name']?.toString() ??
        userData['name']?.toString() ??
        'Member';
  }

  Future<void> refreshData() async {
    setState(() => loading = true);
    final refreshedData =
        await ApiService.loginUser(widget.memberId, widget.memberName);
    if (!mounted) return;
    setState(() {
      loading = false;
      if (refreshedData != null) {
        userData = refreshedData;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data refreshed successfully")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundWarm,
      body: CustomScrollView(
        slivers: [
          // 1. MODERN COLLAPSING HEADER
          SliverAppBar(
            expandedHeight: 120.0,
            pinned: true,
            backgroundColor: kPrimaryWarm,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                "Welcome, ${_getUserName()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimaryWarm, Color.fromARGB(255, 20, 125, 181)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: loading ? null : refreshData,
              ),
              const SizedBox(width: 8),
            ],
          ),

          // 2. MAIN MENU BODY - CONTINUOUS STREAMLINED LIST
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // --- UNIFIED SERVICES LIST ---
                  _buildListButton(context, Icons.account_balance_rounded,
                      "सर्वसाधारण कर्ज", LoanPage(userData: userData)),
                  _buildListButton(context, Icons.bolt_rounded, "आकस्मिक कर्ज",
                      ContingentLoanPage(userData: userData)),
                  _buildListButton(context, Icons.home_work_rounded,
                      "तारण कर्ज", MortgageLoanPage(userData: userData)),
                  _buildListButton(context, Icons.savings_rounded, "मुदत ठेव",
                      FixedDepositPage(userData: userData)),
                  _buildListButton(context, Icons.pie_chart_rounded, "शेअर्स",
                      SharesPage(userData: userData)),
                  _buildListButton(context, Icons.calendar_month_rounded,
                      "बचत ठेव वर्गणी", MonthlySavingsPage(userData: userData)),
                  _buildListButton(context, Icons.health_and_safety_rounded,
                      "मृत्यू निधी", MemberDeathFundPage(userData: userData)),
                  _buildListButton(context, Icons.history_edu_rounded,
                      "आवर्त ठेव", RDPage(userData: userData)),
                  _buildListButton(context, Icons.monetization_on_rounded,
                      "लाभांश", DividendPage(userData: userData)),
                  _buildListButton(context, Icons.add_card_rounded,
                      "Add Money in Bank", PaymentPage(userData: userData)),
                  _buildListButton(context, Icons.person_pin_rounded,
                      "View Profile", ProfilePage(userData: userData)),
                  _buildListButton(
                      context,
                      Icons.lock_reset_rounded,
                      "Change Password",
                      ChangePasswordPage(memberId: widget.memberId)),

                  const SizedBox(height: 30),

                  // LOGOUT BUTTON - Styled distinctively
                  _buildLogoutButton(context),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // AESTHETIC LIST BUTTON HELPER
  Widget _buildListButton(
      BuildContext context, IconData icon, String label, Widget page) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kPrimaryWarm.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: kPrimaryWarm.withOpacity(0.08)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kAccentSand.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: kPrimaryWarm, size: 22),
        ),
        title: Text(
          label,
          style: const TextStyle(
              fontSize: 18,
              fontFamily: 'MarathiFont',
              fontWeight: FontWeight.w600,
              color: kTextDark),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            color: kTextDark.withOpacity(0.2), size: 14),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }

  // LOGOUT BUTTON HELPER
  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
            SizedBox(width: 10),
            Text(
              "Logout Session",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 21),
            ),
          ],
        ),
      ),
    );
  }
}
