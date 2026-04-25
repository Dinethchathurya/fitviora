import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../viewmodels/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = context.watch<ProfileViewModel>();
    final authVm = context.read<AuthViewModel>();
    final profile = profileVm.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emerald100,
              ),
              child: const Icon(
                Icons.person,
                size: 48,
                color: AppColors.emerald600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile?.fullName.isNotEmpty == true
                  ? profile!.fullName
                  : 'FitViora User',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              profile?.email ?? 'Profile tab starter implementation',
              style: const TextStyle(
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: 28),
            const ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy & Security'),
              trailing: Icon(Icons.chevron_right),
            ),
            const ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.chevron_right),
            ),
            const ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text('Terms of Service'),
              trailing: Icon(Icons.chevron_right),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => authVm.logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.destructive,
              ),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
