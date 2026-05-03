import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../viewmodels/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
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
    final vm = context.watch<ProfileViewModel>();
    final authVm = context.read<AuthViewModel>();

    if (vm.isLoading && vm.profile == null) {
      return const Scaffold(
        backgroundColor: AppColors.gray50,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.emerald500),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileTopHeader(),
              const SizedBox(height: 18),
              _ProfileHeroCard(vm: vm),
              const SizedBox(height: 18),
              _DetailsCard(
                title: 'Personal Information',
                showEdit: true,
                content: [
                  _SingleRow(data: _RowData(Icons.email_outlined, 'Email', vm.displayEmail)),
                  _SingleRow(data: _RowData(Icons.phone_outlined, 'Phone', '+94 77 123 4567')),
                  _SingleRow(data: _RowData(Icons.calendar_today_outlined, 'Date of Birth', vm.displayDob)),
                  _SingleRow(data: _RowData(Icons.person_outline, 'Gender', vm.displayGender)),
                ],
              ),
              const SizedBox(height: 14),
              _DetailsCard(
                title: 'Health Information',
                content: [
                  _SingleRow(data: _RowData(Icons.height, 'Height', vm.displayHeight)),
                  _SingleRow(data: _RowData(Icons.monitor_weight_outlined, 'Weight', vm.displayWeight)),
                  _SingleRow(data: _RowData(Icons.favorite_outline, 'Activity Level', vm.displayActivityLevel)),
                  // _GoalRow(vm: vm),
                  // _HealthBadgesRow(vm: vm),
                ],
              ),
              const SizedBox(height: 14),
              _DietaryPreferenceCard(vm: vm),
              const SizedBox(height: 14),
              _ActionGroupCard(authVm: authVm),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'FitViora v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTopHeader extends StatelessWidget {
  const _ProfileTopHeader();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w900,
            color: AppColors.gray900,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Manage your account settings',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _ProfileHeroCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.emerald500, AppColors.teal600],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald600.withOpacity(0.22),
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
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.14),
                ),
                child: const Icon(Icons.person_outline, color: Colors.white, size: 34),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vm.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vm.displayEmail,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.92),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Current BMI',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  vm.bmiValue,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final bool showEdit;
  final List<Widget> content;

  const _DetailsCard({
    required this.title,
    required this.content,
    this.showEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray900,
                  ),
                ),
              ),
              if (showEdit)
                const Icon(Icons.edit_outlined, size: 18, color: AppColors.gray500),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(content.length, (index) {
            return Column(
              children: [
                content[index],
                if (index < content.length - 1)
                  const Divider(height: 18, color: AppColors.gray200),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _RowData {
  final IconData icon;
  final String label;
  final String value;
  _RowData(this.icon, this.label, this.value);
}

class _GoalRow extends StatelessWidget {
  final ProfileViewModel vm;
  const _GoalRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.emerald50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            vm.goalEmoji,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          const Text(
            'Goal',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            vm.displayGoal,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.emerald500,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthBadgesRow extends StatelessWidget {
  final ProfileViewModel vm;
  const _HealthBadgesRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    final badges = vm.healthConditionBadges;
    if (badges.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Conditions',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: badges.map((badge) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.emerald100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.emerald500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _SingleRow extends StatelessWidget {
  final _RowData data;
  const _SingleRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(data.icon, size: 18, color: AppColors.gray500),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            data.label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Flexible(
          child: Text(
            data.value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _DietaryPreferenceCard extends StatelessWidget {
  final ProfileViewModel vm;
  const _DietaryPreferenceCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dietary Preference',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.emerald50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text(vm.foodPreferenceEmoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(
                  vm.displayFoodPreference,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionGroupCard extends StatelessWidget {
  final AuthViewModel authVm;
  const _ActionGroupCard({required this.authVm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
_ActionTile('Privacy & Security', () => Navigator.pushNamed(context, AppRoutes.privacySecurity)),
          const Divider(height: 1),
          _ActionTile('Privacy Policy', () => Navigator.pushNamed(context, AppRoutes.privacyPolicy)),
          const Divider(height: 1),
_ActionTile('Terms of Service', () => Navigator.pushNamed(context, '/terms-of-service')),
          const Divider(height: 2),
          _ActionTile('Log Out', () => authVm.logout(context), danger: true),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool danger;
  const _ActionTile(this.title, this.onTap, {this.danger = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          color: danger ? AppColors.destructive : AppColors.gray900,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: danger ? AppColors.destructive : AppColors.gray500,
      ),
    );
  }
}
