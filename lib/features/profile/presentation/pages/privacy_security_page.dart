import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../features/auth/presentation/viewmodels/auth_view_model.dart';

class PrivacySecurityPage extends StatefulWidget {
  const PrivacySecurityPage({super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildSecurityHeroCard(),
                  // _buildNotificationCard(),
                  _buildSecuritySettingsCard(context),
                  _buildBottomNotice(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            if (authVm.isLoading)
              Container(
                color: Colors.black.withOpacity(0.20),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.emerald500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.white,
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
                  'Privacy & Security',
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
            'Manage your privacy settings',
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

  Widget _buildSecurityHeroCard() {
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
        child: Column(
          children: [
            Row(
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
                        'Account Protected',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Your data is secure',
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
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Last security check: Today at 10:30 AM',
                      style: TextStyle(fontSize: 13, color: Colors.white),
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

  // Widget _buildNotificationCard() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
  //     child: Container(
  //       padding: const EdgeInsets.all(18),
  //       decoration: BoxDecoration(
  //         color: AppColors.white,
  //         borderRadius: BorderRadius.circular(18),
  //         border: Border.all(color: AppColors.gray200),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.03),
  //             blurRadius: 10,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.emerald50,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: const Icon(
  //                   Icons.notifications_none_outlined,
  //                   size: 18,
  //                   color: AppColors.emerald600,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               const Expanded(
  //                 child: Text(
  //                   'Notification Preferences',
  //                   style: TextStyle(
  //                     fontSize: 17,
  //                     fontWeight: FontWeight.w800,
  //                     color: AppColors.gray900,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 20),
  //           _buildNotificationSwitch(
  //             title: 'Push Notifications',
  //             subtitle: 'Meal reminders and health tips',
  //             value: _pushNotifications,
  //             onChanged: (v) => setState(() => _pushNotifications = v),
  //           ),
  //           Container(
  //             height: 1,
  //             color: AppColors.gray200,
  //             margin: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //           _buildNotificationSwitch(
  //             title: 'Email Notifications',
  //             subtitle: 'Weekly reports and updates',
  //             value: _emailNotifications,
  //             onChanged: (v) => setState(() => _emailNotifications = v),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildNotificationSwitch({
  //   required String title,
  //   required String subtitle,
  //   required bool value,
  //   required Function(bool) onChanged,
  // }) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               title,
  //               style: const TextStyle(
  //                 fontSize: 15,
  //                 fontWeight: FontWeight.w600,
  //                 color: AppColors.gray900,
  //               ),
  //             ),
  //             Text(
  //               subtitle,
  //               style: const TextStyle(
  //                 fontSize: 13,
  //                 color: AppColors.gray600,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Switch(
  //         value: value,
  //         onChanged: onChanged,
  //         activeColor: AppColors.emerald500,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSecuritySettingsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: Container(
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
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.blue500.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: AppColors.blue500,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Security Settings',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSecurityRow(
              icon: Icons.lock_outlined,
              iconColor: AppColors.blue500,
              title: 'Change Password',
              subtitle: 'Manage your account password',
              onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword),
            ),
            Container(
              height: 1,
              color: AppColors.gray200,
              margin: const EdgeInsets.symmetric(vertical: 12),
            ),
            _buildSecurityRow(
              icon: Icons.delete_outline,
              iconColor: AppColors.destructive,
              title: 'Delete Account',
              subtitle: 'Permanently remove your account',
              isDanger: true,
              onTap: _showDeleteConfirmationDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDanger ? AppColors.destructive : AppColors.gray900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDanger ? AppColors.destructive : AppColors.gray500,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account?'),
        content: const Text(
          'This action is permanent and cannot be undone. All profile data will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showPasswordDialog();
            },
            child: const Text(
              'Continue',
              style: TextStyle(color: AppColors.destructive),
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog() {
    final passwordController = TextEditingController();
    bool obscure = true;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Confirm Password'),
          content: TextField(
            controller: passwordController,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: 'Current password',
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setDialogState(() => obscure = !obscure),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final pwd = passwordController.text.trim();
                if (pwd.isEmpty) return;
                _deleteAccount(pwd);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.destructive),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAccount(String password) {
    Navigator.pop(context);
    context.read<AuthViewModel>().deleteAccount(context, password);
  }

  Widget _buildBottomNotice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.emerald50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.emerald500.withOpacity(0.30),
          ),
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
                'Your privacy matters: We use industry-standard encryption to protect your data. Your health information is never shared without your explicit consent.',
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