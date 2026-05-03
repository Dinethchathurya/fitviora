import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP HEADER AREA
              _buildHeader(context),
              
              // EMERALD GRADIENT HERO CARD
              _buildHeroCard(),
              
              // MAIN TERMS CONTENT CARDS
              _buildContentCards(),
              
              // BOTTOM GREEN NOTICE BOX
              _buildBottomNotice(),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: AppColors.gray900,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.gray900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Last updated: April 18, 2026',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.gray200),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [AppColors.emerald500, AppColors.teal600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.emerald600.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.18),
              ),
              child: const Icon(
                Icons.gavel_outlined,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Please read before using FitViora',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: Column(
        children: [
          // Section 1: Acceptance of Terms
          _buildSectionCard(
            title: '1. Acceptance of Terms',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'By accessing and using FitViora, you accept and agree to be bound by the terms and provision of this Terms of Service. Your access to and use of FitViora is conditioned upon your acceptance of and compliance with these Terms.',
                  style: TextStyle(fontSize: 14, color: AppColors.gray600, height: 1.6),
                ),
              ],
            ),
          ),

          // Section 2: Description of Service
          _buildSectionCard(
            title: '2. Description of Service',
            content: const Text(
              'FitViora provides personalized nutrition recommendations, meal planning, health tracking, and AI-powered dietary guidance based on user profile data. The service is provided "as is" and "as available".',
              style: TextStyle(fontSize: 14, color: AppColors.gray600, height: 1.6),
            ),
          ),

          // Section 3: User Account
          _buildSectionCard(
            title: '3. User Account',
            content: _buildBulletList([
              'You must provide accurate information when creating an account',
              'You are responsible for maintaining the confidentiality of your account',
              'You agree to notify us immediately of any unauthorized use of your account',
              'You may not share your account credentials with others',
            ]),
          ),

          // Section 4: Medical Disclaimer - AMBER/YELLOW WARNING CARD
          _buildWarningCard(
            title: '4. Medical Disclaimer',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FitViora is NOT a medical service. We do not provide medical advice, diagnosis, or treatment. Always consult qualified healthcare professionals for medical concerns.',
                  style: TextStyle(fontSize: 14, color: AppColors.gray900, fontWeight: FontWeight.w600, height: 1.6),
                ),
                const SizedBox(height: 12),
                _buildBulletList([
                  'Nutritional recommendations are for informational purposes only',
                  'Do not replace professional medical advice with app suggestions',
                  'Consult your doctor before making dietary changes',
                  'We are not liable for any health outcomes from using the app',
                ]),
              ],
            ),
          ),

          // Section 5: User Content and Data
          _buildSectionCard(
            title: '5. User Content and Data',
            content: _buildBulletList([
              'You retain ownership of content you submit to FitViora',
              'You grant us a worldwide, non-exclusive license to use your content',
              'You are responsible for the accuracy of your health data',
              'We may use anonymized data for research and service improvement',
            ]),
          ),

          // Section 6: Prohibited Conduct
          _buildSectionCard(
            title: '6. Prohibited Conduct',
            content: _buildBulletList([
              'Do not use FitViora for commercial purposes without permission',
              'Do not attempt to hack or interfere with our systems',
              'Do not provide false information or impersonate others',
              'Do not use automated systems to access the service',
            ]),
          ),

          // Section 7: Intellectual Property
          _buildSectionCard(
            title: '7. Intellectual Property',
            content: const Text(
              'All content, features, and functionality of FitViora, including text, graphics, logos, and AI algorithms are owned by FitViora or its licensors and protected by copyright and trademark laws.',
              style: TextStyle(fontSize: 14, color: AppColors.gray600, height: 1.6),
            ),
          ),

          // Section 8: Third Party Services
          _buildSectionCard(
            title: '8. Third Party Services',
            content: _buildBulletList([
              'FitViora may contain links to third-party websites',
              'We are not responsible for third-party content or services',
              'Your use of third-party services is at your own risk',
              'Third parties may have their own terms and privacy policies',
            ]),
          ),

          // Section 9: Payments and Subscriptions
          _buildSectionCard(
            title: '9. Payments and Subscriptions',
            content: const Text(
              'Premium features may require subscription. All payments are processed securely. You authorize recurring billing for subscriptions. Cancellation does not provide refunds.',
              style: TextStyle(fontSize: 14, color: AppColors.gray600, height: 1.6),
            ),
          ),

          // Section 10: Termination
          _buildSectionCard(
            title: '10. Termination',
            content: _buildBulletList([
              'We may suspend or terminate your account for violations',
              'You may terminate your account at any time',
              'Upon termination, you lose access to all services',
              'Certain provisions survive termination',
            ]),
          ),

          // Section 11: Limitation of Liability
          _buildSectionCard(
            title: '11. Limitation of Liability',
            content: const Text(
              'To the maximum extent permitted by law, FitViora is not liable for any indirect, incidental, or consequential damages. Our total liability shall not exceed the amount you paid us in the past 12 months.',
              style: TextStyle(fontSize: 14, color: AppColors.gray600, height: 1.6),
            ),
          ),

          // Section 12: Indemnification
          _buildSectionCard(
            title: '12. Indemnification',
            content: const Text(
              'You agree to indemnify and hold harmless FitViora from any claims arising from your violation of these Terms or use of the service.',
              style: TextStyle(fontSize: 14, color: AppColors.gray600, height: 1.6),
            ),
          ),

          // Section 13: Governing Law
          _buildSectionCard(
            title: '13. Governing Law',
            content: const Text(
              'These Terms are governed by the laws of Sri Lanka. Any disputes shall be resolved in the courts of Sri Lanka.',
              style: TextStyle(fontSize: 14, color: AppColors.gray600, height: 1.6),
            ),
          ),

          // Section 14: Contact Information
          _buildSectionCard(
            title: '14. Contact Information',
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FitViora Legal Team',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.gray900),
                  ),
                  SizedBox(height: 8),
                  Text('Email: legal@fitviora.com', style: TextStyle(fontSize: 13, color: AppColors.gray600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.emerald50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.emerald500.withOpacity(0.3)),
                ),
                child: const Icon(Icons.description_outlined, size: 16, color: AppColors.emerald600),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.gray900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          content,
        ],
      ),
    );
  }

  Widget _buildWarningCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.orange500.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange500.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.orange500.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.orange500.withOpacity(0.4)),
                ),
                child: const Icon(Icons.warning_amber_outlined, size: 16, color: AppColors.orange500),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.gray900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          content,
        ],
      ),
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.emerald500),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(item, style: const TextStyle(fontSize: 13, color: AppColors.gray600, height: 1.5)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNotice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.emerald50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.emerald500.withOpacity(0.3)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📋', style: TextStyle(fontSize: 18)),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'By using FitViora, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
                style: TextStyle(fontSize: 13, color: AppColors.gray700, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
