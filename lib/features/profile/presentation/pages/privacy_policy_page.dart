import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
              
              // GREEN HERO CARD
              _buildHeroCard(),
              
              // MAIN POLICY CONTENT CARDS
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
                  'Privacy Policy',
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
                Icons.shield_outlined,
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
                    'Your Privacy Matters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'We protect your health data',
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
          // Section 1: Information We Collect
          _buildSectionCard(
            title: '1. Information We Collect',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSubSection(
                  'Personal Information',
                  'When you create a FitViora account, we collect your name, email address, date of birth, and password to provide you with personalized nutrition recommendations.',
                ),
                const SizedBox(height: 16),
                _buildSubSection(
                  'Health Data',
                  'We collect health metrics including height, weight, BMI, dietary preferences, allergies, health goals, activity levels, and meal planning data to deliver customized nutrition plans tailored to your needs.',
                ),
                const SizedBox(height: 16),
                _buildSubSection(
                  'Usage Information',
                  'We automatically collect information about your interactions with FitViora, including meal selections, progress tracking, report views, and app usage patterns to improve our services.',
                ),
              ],
            ),
          ),
          
          // Section 2: How We Use Your Information
          _buildSectionCard(
            title: '2. How We Use Your Information',
            content: _buildBulletList([
              'Generate AI-powered personalized meal recommendations based on your health profile and Sri Lankan dietary context',
              'Track your BMI, nutritional intake, and health progress over time',
              'Identify nutrient gaps and provide tailored recommendations for balanced nutrition',
              'Send you meal reminders, health tips, and weekly progress reports',
              'Improve our AI algorithms and enhance the FitViora experience',
              'Provide customer support and respond to your inquiries',
            ]),
          ),
          
          // Section 3: Data Storage & Security
          _buildSectionCard(
            title: '3. Data Storage & Security',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your health data is stored locally on your device using secure browser storage (localStorage). We employ industry-standard encryption and security measures to protect your information from unauthorized access, alteration, disclosure, or destruction.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray600,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Security Measures:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBulletList([
                  'Encrypted data transmission using HTTPS',
                  'Secure password hashing and authentication',
                  'Optional biometric authentication for enhanced security',
                  'Regular security audits and updates',
                ]),
              ],
            ),
          ),
          
          // Section 4: Information Sharing
          _buildSectionCard(
            title: '4. Information Sharing',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'We do not sell your personal health data to third parties. We may share your information only in the following circumstances:',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray600,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 14),
                _buildBulletList([
                  'With Your Consent: When you explicitly authorize us to share your information',
                  'Service Providers: With trusted third-party services that help us operate FitViora (e.g., AI processing, analytics)',
                  'Legal Requirements: When required by law or to protect our rights and safety',
                ]),
              ],
            ),
          ),
          
          // Section 5: Your Rights & Control
          _buildSectionCard(
            title: '5. Your Rights & Control',
            content: _buildBulletList([
              'Access: View and download all your personal data stored in FitViora',
              'Update: Edit your profile information and health data at any time',
              'Delete: Request complete deletion of your account and all associated data',
              'Opt-out: Disable notifications and data sharing preferences in Privacy Settings',
              'Export: Download your health data in a portable format',
            ]),
          ),
          
          // Section 6: Data Retention
          _buildSectionCard(
            title: '6. Data Retention',
            content: const Text(
              'We retain your personal data for as long as your account is active or as needed to provide you services. If you delete your account, we will permanently remove all your personal information within 30 days, except where we are required by law to retain certain information.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray600,
                height: 1.6,
              ),
            ),
          ),
          
          // Section 7: Children's Privacy
          _buildSectionCard(
            title: '7. Children\'s Privacy',
            content: const Text(
              'FitViora is not intended for use by individuals under 13 years of age. We do not knowingly collect personal information from children under 13. If you believe we have collected information from a child under 13, please contact us immediately.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray600,
                height: 1.6,
              ),
            ),
          ),
          
          // Section 8: Updates to This Policy
          _buildSectionCard(
            title: '8. Updates to This Policy',
            content: const Text(
              'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting a notice in the app or sending you an email. Your continued use of FitViora after such modifications constitutes your acknowledgment and acceptance of the updated policy.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray600,
                height: 1.6,
              ),
            ),
          ),
          
          // Section 9: Contact Us
          _buildSectionCard(
            title: '9. Contact Us',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'If you have any questions or concerns about this Privacy Policy or our data practices, please contact us:',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray600,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
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
                        'FitViora Support Team',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Email: privacy@fitviora.com',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.gray600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Support Portal: app.fitviora.com/support',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                child: const Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: AppColors.emerald600,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray900,
                  ),
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

  Widget _buildSubSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.gray600,
            height: 1.5,
          ),
        ),
      ],
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emerald500,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray600,
                    height: 1.5,
                  ),
                ),
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
            Text(
              '🔒',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your health data is protected: FitViora is committed to maintaining the highest standards of data privacy and security. We continuously update our practices to protect your personal health information.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.gray700,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
