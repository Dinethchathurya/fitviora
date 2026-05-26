# TODO

## Progress page UI
- [ ] Replace placeholder `lib/features/progress/presentation/pages/progress_page.dart` with body-only static UI (SafeArea + SingleChildScrollView + Padding). No Scaffold/AppBar/bottom nav.
- [ ] Create reusable widgets under `lib/features/progress/presentation/widgets/`:
  - [ ] `progress_stat_card.dart`
  - [ ] `bmi_trend_card.dart`
  - [ ] `bmi_summary_card.dart`
  - [ ] `progress_status_card.dart`
- [ ] Ensure styling uses `AppColors`, rounded white cards, emerald/teal theme, soft shadows, no overflow.
- [ ] Add bottom padding (~90) to avoid bottom navigation overlap.
- [ ] Run `flutter analyze` and `flutter run`.

